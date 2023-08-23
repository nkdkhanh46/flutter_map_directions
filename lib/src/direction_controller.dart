import 'package:flutter_map_directions/flutter_map_directions.dart';

class DirectionController {
  late DirectionsLayerState _state;

  set state(DirectionsLayerState state) {
    _state = state;
  }

  void updateDirection(List<DirectionCoordinate> coordinates) {
    _state.updateCoordinates(coordinates);
  }
}