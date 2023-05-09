import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong2;

import 'latlng.dart';
import 'osrm_route_response.dart';

class DirectionsLayer extends StatefulWidget {

  final List<LatLng> coordinates;
  final Color? color;
  final double? strokeWidth;
  final Function(bool isRouteAvailable)? onCompleted;

  const DirectionsLayer({
    super.key,
    required this.coordinates,
    this.color,
    this.strokeWidth,
    this.onCompleted,
  });

  @override
  State<StatefulWidget> createState() => _DirectionsLayerState();
}

class _DirectionsLayerState extends State<DirectionsLayer> {

  final Color _defaultColor = Colors.blue;
  final double _defaultStrokeWidth = 3.0;

  final List<Polyline> _directions = [];

  @override
  void initState() {
    _getDirections();
    super.initState();
  }

  void _getDirections() async {
    final destinations = widget.coordinates.map((location) => '${location.longitude},${location.latitude}').join(';');
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