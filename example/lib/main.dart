import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
import 'package:latlong2/latlong.dart';

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

  List<DirectionCoordinate> _coordinates = [];
  final MapController _mapController = MapController();
  final DirectionController _directionController = DirectionController();

  @override
  void initState() {
    _loadNewRoute();
    super.initState();
  }

  void _loadNewRoute() async {
    await Future.delayed(const Duration(seconds: 5));
    _coordinates = [
      DirectionCoordinate(10.776983, 106.690581),
      DirectionCoordinate(10.780691, 106.658819)
    ];
    final bounds = LatLngBounds.fromPoints(
      _coordinates.map((location) =>
        LatLng(location.latitude, location.longitude)
      ).toList()
    );
    _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(50)));
    _directionController.updateDirection(_coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(10.776983, 106.690581),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: _coordinates.map((location) {
                  return Marker(
                    point: LatLng(location.latitude, location.longitude),
                    width: 35,
                    height: 35,
                    child: const Icon(
                      Icons.location_pin,
                    ),
                    alignment: Alignment.topCenter,
                  );
                }).toList()
              ),
              DirectionsLayer(
                coordinates: _coordinates,
                color: Colors.deepOrange,
                onCompleted: (routes) => _updateMessage(routes),
                controller: _directionController,
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
          ),
        ],
      )
    );
  }

  void _updateMessage(List<OsrmRoute> routes) {
    if (_coordinates.length < 2) return;

    setState(() {
      _message = routes.isNotEmpty ? 'Found route' : 'No route found';
    });
  }
}
