import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
import 'package:latlong2/latlong.dart' as latlong2;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Map Directions Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _message = 'Finding route...';

  @override
  Widget build(BuildContext context) {
    final coordinates = [
      LatLng(10.776983,106.690581),
      LatLng(10.780691,106.658819)
    ];

    final bounds = LatLngBounds.fromPoints(
      coordinates.map((location) =>
        latlong2.LatLng(location.latitude, location.longitude)
      ).toList()
    );
    const padding = 50.0;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              bounds: bounds,
              boundsOptions: FitBoundsOptions(
                padding: EdgeInsets.only(
                  left: padding,
                  top: padding + MediaQuery.of(context).padding.top,
                  right: padding,
                  bottom: padding,
                ),
              ),
            ),
            nonRotatedChildren: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: coordinates.map((location) {
                  return Marker(
                    point: latlong2.LatLng(location.latitude, location.longitude),
                    width: 35,
                    height: 35,
                    builder: (context) => const Icon(
                      Icons.location_pin,
                    ),
                    anchorPos: AnchorPos.align(AnchorAlign.top)
                  );
                }).toList()
              ),
              DirectionsLayer(
                coordinates: coordinates,
                color: Colors.deepOrange,
                onCompleted: (isRouteAvailable) => _updateMessage(isRouteAvailable),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text(_message),
            ),
          )
        ],
      )
    );
  }

  void _updateMessage(bool isRouteAvailable) {
    setState(() {
      _message = isRouteAvailable ? 'Found route' : 'No route found';
    });
  }
}
