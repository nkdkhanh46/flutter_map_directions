class OsrmRouteResponse {
  late List<OsrmRoute> routes;

  OsrmRouteResponse(this.routes);

  OsrmRouteResponse.fromJson(Map<String, dynamic> data) {
    routes = List.of(data['routes'])
    .map((e) => OsrmRoute.fromJson(e)).toList();
  }
}

class OsrmRoute {
  final OsrmGeometry geometry;

  OsrmRoute(this.geometry);

  OsrmRoute.fromJson(Map<String, dynamic> data):
      geometry = OsrmGeometry.fromJson(data['geometry']);
}

class OsrmGeometry {

  final List<OsrmCoordinate> coordinates;

  OsrmGeometry(this.coordinates);

  OsrmGeometry.fromJson(Map<String, dynamic> data):
        coordinates = (data['coordinates'] as List)
            .map((e) => OsrmCoordinate.fromJson(e)).toList();
}

class OsrmCoordinate {
  final List<double> points;

  OsrmCoordinate(this.points);

  OsrmCoordinate.fromJson(List<dynamic> data):
        points = data.cast<double>();
}