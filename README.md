# flutter_map_directions

A [flutter_map](https://pub.dev/packages/flutter_map) plugin for displaying directions between coordinates.

## Usage
Add `flutter_map_directions` to your `pubspec.yaml`:

```
dependencies:
  flutter_map_directions: any // or latest version
```

Add the layer widget into FlutterMap:

```
final DirectionController _directionController = DirectionController();

Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          ...
        ),
        nonRotatedChildren: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
            ),
            MarkerLayer(
              ...
            ),
            DirectionsLayer(
                coordinates: [],
                controller: _directionController,
            ), // <-- add layer here
        ],
    );
}
```

To update route:

```
void _loadRoute() async {
    await ...;
    _coordinates = [...]; // new coordinates after awaiting
    _directionController.updateDirection(_coordinates);
  }
```
