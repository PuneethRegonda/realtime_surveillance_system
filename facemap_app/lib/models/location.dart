import 'package:facemap_app/models/camera_locations.dart';
import 'package:facemap_app/models/recognized_face.dart';

class Location {
  String name;
  String lat, long;
  double id;
  List<RecognizedFace> totalFaces = [];
  Map<String, RecognizedFace> realTimeFaces = {};
  // List<RecognizedFace> realTimeFaces=[];
  Location(
      {this.name,
      this.lat,
      this.long,
      this.realTimeFaces,
      this.totalFaces,
      this.id});

  static Map<String, Location> fromCameraLocations(
      Map<String, CameraLocations> locations) {
    Map<String, Location> map = {};

    for (String location in locations.keys) {
      map[locations[location].name] = Location(
          name: locations[location].name,
          id: locations[location].id,
          long: locations[location].long,
          lat: locations[location].lat,
          realTimeFaces: {},
          totalFaces: []);
    }
    return map;
  }
}
