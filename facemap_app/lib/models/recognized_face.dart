class RecognizedFace {
  String name, location, time, lastLocation;
  RecognizedFace({this.name, this.time, this.location, this.lastLocation = ""});

  factory RecognizedFace.fromOldFacesJSON(map) {
    if (map == null) return null;
    return RecognizedFace(
        name: map["name"],
        location: map["current_location"],
        time: map["createdAt"]);
  }

  factory RecognizedFace.fromKnownFace(map) {
    if (map == null) return null;
    return RecognizedFace(
        name: map["name"],
        location: map["current_location"],
        time: map["createdAt"],
        lastLocation: map["last_location"]);
  }

  static List<RecognizedFace> fromOldFacesJsonList(List<dynamic> list) {
    List<RecognizedFace> _out = [];
    for (dynamic map in list) {
      _out.add(RecognizedFace.fromOldFacesJSON(map));
    }
    return _out;
  }

  @override
  String toString() {
    return "RecognizedFace{name: $name, location: $location, time: $time,lastLocation: $lastLocation}";
  }

  static List<RecognizedFace> facesatLocation({String location, data}) {
    print("converting map to Objects");
    List<RecognizedFace> list = [];
    // print(data.toString().substring(10));
    for (dynamic user in data) {
      print(user["current_location"]);
      if (user["current_location"].toString() == location) {
        print("location matched adding $location");
        list.add(RecognizedFace.fromKnownFace(user));
      }
    }
    return list;
  }
}
