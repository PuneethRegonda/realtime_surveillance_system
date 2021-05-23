import 'package:facemap_app/models/camera_locations.dart';
import 'package:facemap_app/models/location.dart';
import 'package:facemap_app/models/recognized_face.dart';
import 'package:flutter/foundation.dart';

class RecognizedFacesProvider extends ChangeNotifier {
  // main data of all locations with recognized people in those locations
  Map<String, Location> _allLocations = {};
  Map<String, Location> get allLocations => _allLocations;

  List<RecognizedFace> _realTimeList = [];
  List<RecognizedFace> get realtimefaces => _realTimeList;

  set realtimefaces(List<RecognizedFace> faces) {
    // if (faces != null)
    _realTimeList = faces;
    notifyListeners();
  }

// used on new faces detected
  void addFacetoLocation(RecognizedFace face) {
    allLocations[face.location].totalFaces.add(face);
    notifyListeners();
  }

// on old data we just add face
  void addFaceListtoLocations(List<RecognizedFace> fromOldFacesJsonList) {
    for (RecognizedFace face in fromOldFacesJsonList) {
      if (allLocations.containsKey(face.location)) {
        allLocations[face.location].totalFaces.add(face);
        notifyListeners();
      } else {
        print("Location ${face.location} is not present");
        allLocations[face.location] = Location(totalFaces: [])
          ..totalFaces.add(face);
      }
    }
  }

  void saveCameraLocations(Map<String, CameraLocations> locations) {
    _allLocations = Location.fromCameraLocations(locations);
  }

  List<RecognizedFace> getTotalRecognizedFaces() {
    List<RecognizedFace> _totalFaces = [];
    allLocations.forEach((key, value) => _totalFaces.addAll(value.totalFaces));
    return _totalFaces;
  }

  void addRealtimeList(List<RecognizedFace> facesatLocation) {
    realtimefaces = facesatLocation;
    print("old faces added");
    notifyListeners();
  }

  Map<String, dynamic> _mailing_list = {};

  Map<String, dynamic> get mailingList => _mailing_list;

  void setUniqueFaces(String location) {
    _mailing_list = {};
    for (RecognizedFace face in realtimefaces) {
      if (face.location == location) if (!_mailing_list
          .containsKey(face.name)) {
        _mailing_list[face.name] = face.time;
      }
    }
    notifyListeners();
  }

  void mailingListRemoveAt(int index) {
    mailingList.remove(mailingList.keys.elementAt(index));
    notifyListeners();
  }
}
