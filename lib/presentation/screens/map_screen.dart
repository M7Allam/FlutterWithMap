import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubit/map/map_cubit.dart';
import 'package:flutter_maps/business_logic/cubit/map/map_states.dart';
import 'package:flutter_maps/data/models/place_directions_model.dart';
import 'package:flutter_maps/data/models/place_model.dart';
import 'package:flutter_maps/data/models/place_suggestions_model.dart';
import 'package:flutter_maps/data/repository/places_repository.dart';
import 'package:flutter_maps/data/webservices/map_dio.dart';
import 'package:flutter_maps/others/helpers.dart';
import 'package:flutter_maps/others/values/colors.dart';
import 'package:flutter_maps/presentation/widgets/distance_and_duration.dart';
import 'package:flutter_maps/presentation/widgets/drawer.dart';
import 'package:flutter_maps/presentation/widgets/place_suggestions_item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapCubit _mapCubit = MapCubit(MapRepository(MapDio()));
  static Position? position;
  static final CameraPosition _currentLocationCameraPosition = CameraPosition(
    target: LatLng(position!.latitude, position!.longitude),
    bearing: 0.0,
    zoom: 17,
  );
  final Completer<GoogleMapController> _mapController = Completer();
  final FloatingSearchBarController _floatingSearchBarController =
      FloatingSearchBarController();
  List<dynamic> _placeSuggestions = [];

  //This variables to getPlaceLocation
  final Set<Marker> _markers = {};
  late PlaceSuggestion _placeSuggestion;
  late Place _selectedPlace;
  late Marker _searchedLocationMarker;
  late Marker _currentLocationMarker;
  late CameraPosition _searchedLocationCameraPosition;

  //This variables to getPlaceDirections
  PlaceDirections? directions;
  bool progressIndicator = false;
  late List<LatLng> polyLinesPoints;
  bool isSearchedPlaceMarkerClicked = false;
  bool isDistanceAndDurationVisible = false;
  late String time;
  late String distance;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null ? buildMap() : buildLoadingMap(),
          buildFloatingSearchBar(),
          isSearchedPlaceMarkerClicked
              ? DistanceAndTime(
                  isDistanceAndTimeVisible: isDistanceAndDurationVisible,
                  directions: directions,
                )
              : Container(),
        ],
      ),
      floatingActionButton: buildCurrentLocationFAB(),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return BlocProvider(
      create: (context) => _mapCubit,
      child: FloatingSearchBar(
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildPlaceSuggestionsBlocBuilder(),
                buildSelectedPlaceLocationBlocListener(),
                buildDirectionsBlocListener(),
              ],
            ),
          );
        },
        controller: _floatingSearchBarController,
        elevation: 6.0,
        hintStyle: const TextStyle(fontSize: 18.0),
        queryStyle: const TextStyle(fontSize: 18.0),
        hint: 'Find a place',
        border: const BorderSide(style: BorderStyle.none),
        margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        height: 52.0,
        iconColor: MyColors.blue,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 600),
        transitionCurve: Curves.easeInOut,
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        progress: progressIndicator,
        onQueryChanged: (String value) {
          if (value.isNotEmpty) {
            getPlaceSuggestions(value);
          }
        },
        onFocusChanged: (_) {
          setState(() {
            isDistanceAndDurationVisible = false;
          });
        },
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: Icon(
                Icons.place,
                color: Colors.black.withOpacity(0.6),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDirectionsBlocListener() {
    return BlocListener<MapCubit, MapStates>(
      listener: (context, state) {
        if (state is LoadedPlaceDirectionsState) {
          directions = (state).directions;
          _getPolyLinePoints();
        }
      },
      child: Container(),
    );
  }

  void _getPolyLinePoints() {
    polyLinesPoints = directions!.polyLinePoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  Widget buildSelectedPlaceLocationBlocListener() {
    return BlocListener<MapCubit, MapStates>(
      listener: (context, state) {
        if (state is LoadedPlaceLocationState) {
          _selectedPlace = (state).place;
          _gotoSearchedLocation();
          _getSearchedPlaceDirections();
        }
      },
      child: Container(),
    );
  }

  void _getSearchedPlaceDirections() {
    _mapCubit.emitPlaceDirections(_currentLocationCameraPosition.target,
        _searchedLocationCameraPosition.target);
  }

  void getPlaceSuggestions(String place) {
    final sessionToken = const Uuid().v4();
    _mapCubit.emitPlaceSuggestions(place, sessionToken);
  }

  void _getPlaceLocation(String placeId) {
    final sessionToken = const Uuid().v4();
    _mapCubit.emitPlaceLocation(placeId, sessionToken);
  }

  Widget buildPlaceSuggestionsBlocBuilder() {
    return BlocBuilder<MapCubit, MapStates>(
      builder: (context, state) {
        if (state is LoadedPlaceSuggestionsState) {
          _placeSuggestions = (state).placeSuggestions;
          if (_placeSuggestions.isNotEmpty) {
            return buildPlaceSuggestions();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildPlaceSuggestions() {
    return ListView.builder(
      itemBuilder: (context, index) {
        _placeSuggestion = _placeSuggestions[index];
        return InkWell(
          child: PlaceSuggestionsItem(suggestion: _placeSuggestion),
          onTap: () async {
            _placeSuggestion = _placeSuggestions[index];
            _floatingSearchBarController.close();
            _getPlaceLocation(_placeSuggestion.placeId);
            _removeAllMarkersAndPolyLinePointsAndUpdateUI();
          },
        );
      },
      itemCount: _placeSuggestions.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  Widget buildCurrentLocationFAB() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 8, 20),
      child: FloatingActionButton(
        backgroundColor: MyColors.blue,
        onPressed: _gotoCurrentLocation,
        child: const Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildMap() {
    return GoogleMap(
      initialCameraPosition: _currentLocationCameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      markers: _markers,
      polylines: directions != null
          ? {
              Polyline(
                polylineId: const PolylineId('1'),
                color: Colors.black,
                width: 2,
                points: polyLinesPoints,
              )
            }
          : {},
    );
  }

  Widget buildLoadingMap() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.blue,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _gotoCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_currentLocationCameraPosition));
  }

  Future<void> _gotoSearchedLocation() async {
    _searchedLocationCameraPosition = CameraPosition(
      target: LatLng(
        _selectedPlace.result.geometry.location.lat,
        _selectedPlace.result.geometry.location.lng,
      ),
      bearing: 0.0,
      tilt: 0.0,
      zoom: 15,
    );
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_searchedLocationCameraPosition));
    _buildSearchedPlaceMarker();
  }

  void _buildSearchedPlaceMarker() {
    _searchedLocationMarker = Marker(
      markerId: const MarkerId('1'),
      position: _searchedLocationCameraPosition.target,
      onTap: () {
        _buildCurrentPositionMarker();
        // show time and distance
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isDistanceAndDurationVisible = true;
        });
      },
      infoWindow: InfoWindow(
        title: _placeSuggestion.description,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    _addMarkerToMarkersAndUpdateUI(_searchedLocationMarker);
  }

  void _buildCurrentPositionMarker() {
    _currentLocationMarker = Marker(
      markerId: const MarkerId('2'),
      position: _currentLocationCameraPosition.target,
      infoWindow: const InfoWindow(
        title: 'Your current location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    _addMarkerToMarkersAndUpdateUI(_currentLocationMarker);
  }

  void _addMarkerToMarkersAndUpdateUI(Marker marker) {
    setState(() {
      _markers.add(marker);
    });
  }

  void _removeAllMarkersAndPolyLinePointsAndUpdateUI() {
    setState(() {
      _markers.clear();
      polyLinesPoints.clear();
    });
  }
}
