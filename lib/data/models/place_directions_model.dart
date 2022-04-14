import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDirections {
  //bounds
  late LatLngBounds bounds;
  late List<PointLatLng> polyLinePoints;
  late String totalDistance;
  late String totalDuration;

  PlaceDirections({
    required this.bounds,
    required this.polyLinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory PlaceDirections.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['routes'][0]);
    final northEast = data['bounds']['northeast'];
    final northEastLatLng = LatLng(northEast['lat'], northEast['lng']);
    final southWest = data['bounds']['southwest'];
    final southWestLatLng = LatLng(southWest['lat'], southWest['lng']);
    final bounds = LatLngBounds(
        northeast: northEastLatLng,
        southwest: southWestLatLng
    );
    late String distance;
    late String duration;
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return PlaceDirections(
        bounds: bounds,
        polyLinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
        totalDistance: distance,
        totalDuration: duration);
  }
}
