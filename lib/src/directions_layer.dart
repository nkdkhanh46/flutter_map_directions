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

  const DirectionsLayer({super.key, required this.coordinates, this.color, this.strokeWidth});

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
    final response = await http.get(
        Uri.parse('https://router.project-osrm.org/route/v1/driving/$destinations?overview=full&geometries=geojson')
    );
    final routes = OsrmRouteResponse.fromJson(jsonDecode(response.body));
    _directions.clear();
    for (var element in routes.routes) {
      _directions.add(
        Polyline(
          points: element.geometry.coordinates.map((e) => latlong2.LatLng(e.points.last, e.points.first)).toList(),
          strokeJoin: StrokeJoin.round,
          borderStrokeWidth: widget.strokeWidth ?? _defaultStrokeWidth,
          color: widget.color ?? _defaultColor,
          borderColor: widget.color ?? _defaultColor,
        )
      );
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: _directions,
    );
  }
}