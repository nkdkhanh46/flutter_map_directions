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
Widget build(BuildContext context) {
    return FlutterMap(
        children: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
            ),
            DirectionsLayer(
                coordinates: []
            ), // <-- add layer here
        ],
    );
}
```