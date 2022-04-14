import 'package:dio/dio.dart';
import 'package:flutter_maps/others/values/strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDio {
  late Dio dio;

  MapDio() {
    BaseOptions options = BaseOptions(
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }


  Future<List<dynamic>> fetchPlaceSuggestions(String place, String sessionToken) async {
    try {
      Response response = await dio.get(
        MyStrings.googlePlaceSuggestionsBaseUrl,
        queryParameters: {
          'input': place,
          'types': 'address',
          'components': 'country:eg',
          'key': MyStrings.googleMapApiKey,
          'sessiontoken': sessionToken
        },
      );
      return response.data['predictions'];
    } catch (error) {
      print('WEBSERVICES @GET PLACE_SUGGESTIONS ERROR: ${error.toString()}');
      return [];
    }
  }

  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        MyStrings.googlePlaceDetailsBaseUrl,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': MyStrings.googleMapApiKey,
          'sessiontoken': sessionToken
        },
      );
      return response.data;
    } catch (error) {
      print('WEBSERVICES @GET PLACE_LOCATION ERROR: ${error.toString()}');
      return Future.error('Place Location error: ', StackTrace.fromString('This is trace'));
    }
  }

  //origin equals currentLocation
  //destination equals searchedLocation
  Future<dynamic> getDirections(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(
        MyStrings.googleDirectionsBaseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': MyStrings.googleMapApiKey,
        },
      );
      return response.data;
    } catch (error) {
      print('WEBSERVICES @GET DIRECTIONS ERROR: ${error.toString()}');
      return Future.error('DIRECTIONS error: ', StackTrace.fromString('This is trace'));
    }
  }

}
