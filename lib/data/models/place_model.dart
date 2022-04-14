class Place{
  late PlaceResult result;

  Place.fromJson(dynamic json){
    result = PlaceResult.fromJson(json['result']);
  }
}

class PlaceResult {
  late PlaceGeometry geometry;

  PlaceResult.fromJson(dynamic json){
    geometry = PlaceGeometry.fromJson(json['geometry']);
  }
}

class PlaceGeometry {
  late PlaceLocation location;

  PlaceGeometry.fromJson(dynamic json){
    location = PlaceLocation.fromJson(json['location']);
  }
}

class PlaceLocation {
  late double lat;
  late double lng;

  PlaceLocation.fromJson(dynamic json){
    lat = json['lat'];
    lng = json['lng'];
  }
}
