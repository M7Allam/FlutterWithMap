import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/business_logic/cubit/map/map_states.dart';
import 'package:flutter_maps/data/repository/places_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCubit extends Cubit<MapStates> {

  final MapRepository _mapRepository;

  MapCubit(this._mapRepository) : super(InitialMapState());


  void emitPlaceSuggestions(String place, String sessionToken){
    _mapRepository.fetchPlaceSuggestions(place, sessionToken).then((placeSuggestions){
      print('WEBSERVICES @GET PLACE_SUGGESTIONS SUCCESS: ${placeSuggestions.toString()}');
      emit(LoadedPlaceSuggestionsState(placeSuggestions));
    }).catchError((error) {
      print('WEBSERVICES @GET PLACE_SUGGESTIONS ERROR: ${error.toString()}');
    });
  }

  void emitPlaceLocation(String placeId, String sessionToken){
    _mapRepository.getPlaceLocation(placeId, sessionToken).then((place){
      print('WEBSERVICES @GET PLACE_LOCATION SUCCESS: ${place.toString()}');
      emit(LoadedPlaceLocationState(place));
    }).catchError((error) {
      print('WEBSERVICES @GET PLACE_LOCATION ERROR: ${error.toString()}');
    });
  }

  void emitPlaceDirections(LatLng origin, LatLng destination){
    _mapRepository.getDirections(origin, destination).then((directions){
      print('WEBSERVICES @GET PLACE_DIRECTIONS SUCCESS: ${directions.toString()}');
      emit(LoadedPlaceDirectionsState(directions));
    }).catchError((error) {
      print('WEBSERVICES @GET PLACE_DIRECTIONS ERROR: ${error.toString()}');
    });
  }


}