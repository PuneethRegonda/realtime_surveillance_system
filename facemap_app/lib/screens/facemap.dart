// import 'package:facemap_app/utils/map_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// const double CAMERA_ZOOM = 16;
// const double CAMERA_TILT = 80;
// const double CAMERA_BEARING = 30;
// const LatLng SOURCE_LOCATION = LatLng(17.725067383135777, 78.25470630079508);
// const LatLng DEST_LOCATION = LatLng(17.725012453203295, 78.2557537034154);

// class FaceMapScreen extends StatefulWidget {
//   @override
//   _FaceMapScreenState createState() => _FaceMapScreenState();
// }

// class _FaceMapScreenState extends State<FaceMapScreen> {
//   Location _location;
//   LocationData _currentLocation;
//   CameraPosition initialCameraPosition;
//   Set<Marker> _markers = Set<Marker>();
//   @override
//   void initState() {
//     super.initState();
//     _location = Location();
//     _location.onLocationChanged.listen((LocationData locData) {
//       _currentLocation = locData;
//     });

//     setInitialLocation();
//     _markers.add(Marker(
//       markerId: MarkerId("gandhi statue"),
//       position: SOURCE_LOCATION,
//       visible: true,
//     ));
//   }

//   void setInitialLocation() async {
//     // set the initial location by pulling the user's
//     // current location from the location's getLocation()
//     _currentLocation = await _location.getLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     initialCameraPosition = CameraPosition(
//         zoom: CAMERA_ZOOM,
//         tilt: CAMERA_TILT,
//         bearing: CAMERA_BEARING,
//         target: SOURCE_LOCATION);

//     if (_currentLocation != null) {
//       initialCameraPosition = CameraPosition(
//           target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
//           zoom: CAMERA_ZOOM,
//           tilt: CAMERA_TILT,
//           bearing: CAMERA_BEARING);
//     }
//     return GoogleMap(
//         myLocationEnabled: true,
//         compassEnabled: true,
//         tiltGesturesEnabled: false,
//         mapType: MapType.normal,
//         onTap: (data) {
//           print(data);
//         },
//         initialCameraPosition: initialCameraPosition,
//         onMapCreated: (GoogleMapController controller) {
//           controller.setMapStyle(MapStyle.normal);
//         });
//   }
// }
