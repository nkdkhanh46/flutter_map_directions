import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong2;

import 'direction_controller.dart';
import 'direction_coordinate.dart';
import 'osrm_route_response.dart';

class DirectionsLayer extends StatefulWidget {

  final List<DirectionCoordinate> coordinates;
  final Color? color;
  final double? strokeWidth;
  final Function(bool isRouteAvailable)? onCompleted;
  final DirectionController? controller;

  const DirectionsLayer({
    super.key,
    required this.coordinates,
    this.color,
    this.strokeWidth,
    this.onCompleted,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => DirectionsLayerState();

  void updateDirection(List<DirectionCoordinate> coordinates) {}
}

class DirectionsLayerState extends State<DirectionsLayer> {

  final Color _defaultColor = Colors.blue;
  final double _defaultStrokeWidth = 3.0;

  late List<DirectionCoordinate> _coordinates;
  final List<Polyline> _directions = [];

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!.state = this;
    }
    _coordinates = widget.coordinates;
    _getDirections();
    super.initState();
  }

  void updateCoordinates(List<DirectionCoordinate> coordinates) {
    _coordinates = coordinates;
    _getDirections();
  }

  void _getDirections() async {
    final destinations = _coordinates.map((location) => '${location.longitude},${location.latitude}').join(';');
    final http.Response response;
    try {
      response = await http.get(
          Uri.parse('https://router.project-osrm.org/route/v1/driving/$destinations?overview=full&geometries=geojson')
      );
      if (response.statusCode != 200) {
        _onCompleted(false);
      } else {
        _onRetrieveRouteSuccess(response);
      }
    } catch (_) {
      _onCompleted(false);
    }
  }

  void _onCompleted(bool isRouteAvailable) {
    if (widget.onCompleted != null) {
      widget.onCompleted!(isRouteAvailable);
    }
  }

  void _onRetrieveRouteSuccess(http.Response response) {
    final routes = OsrmRouteResponse.fromJson(jsonDecode(response.body));
    _directions.clear();
    for (var route in routes.routes) {
      _directions.add(
        Polyline(
          points: route.geometry.coordinates.map((e) => latlong2.LatLng(e.points.last, e.points.first)).toList(),
          strokeJoin: StrokeJoin.round,
          borderStrokeWidth: widget.strokeWidth ?? _defaultStrokeWidth,
          color: widget.color ?? _defaultColor,
          borderColor: widget.color ?? _defaultColor,
        )
      );
    }
    _onCompleted(_directions.isNotEmpty);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: _directions,
    );
  }
}