import 'package:flutter_maps/data/models/place_directions_model.dart';
import 'package:flutter_maps/data/models/place_model.dart';

abstract class MapStates {}

class InitialMapState extends MapStates {}

class LoadedPlaceSuggestionsState extends MapStates {
  final List<dynamic> placeSuggestions;

  LoadedPlaceSuggestionsState(this.placeSuggestions);
}

class LoadedPlaceLocationState extends MapStates {
  final Place place;

  LoadedPlaceLocationState(this.place);
}

class LoadedPlaceDirectionsState extends MapStates {
  final PlaceDirections directions;

  LoadedPlaceDirectionsState(this.directions);
}
