import 'package:flutter_maps/data/models/place_directions_model.dart';
import 'package:flutter_maps/data/models/place_model.dart';
import 'package:flutter_maps/data/models/place_suggestions_model.dart';
import 'package:flutter_maps/data/webservices/map_dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRepository {
  final MapDio dioPlaces;

  MapRepository(this.dioPlaces);

  Future<List<dynamic>> fetchPlaceSuggestions(
      String place, String sessionToken) async {
    final placeSuggestions =
        await dioPlaces.fetchPlaceSuggestions(place, sessionToken);
    return placeSuggestions
        .map((suggestion) => PlaceSuggestion.fromJson(suggestion))
        .toList();
  }

  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async{
    final placeLocation = await dioPlaces.getPlaceLocation(placeId, sessionToken);
    return Place.fromJson(placeLocation);
  }

  Future<dynamic> getDirections(LatLng origin, LatLng destination) async{
    final directions = await dioPlaces.getDirections(origin, destination);
    return PlaceDirections.fromJson(directions);
  }
}
