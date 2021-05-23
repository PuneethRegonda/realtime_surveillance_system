import 'package:facemap_app/provider/recognized_faces.dart';
import 'package:facemap_app/screens/dashboard.dart';
import 'package:facemap_app/screens/login_screen.dart';
import 'package:facemap_app/utils/session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  
  @override
  void initState() {
    super.initState();
    print("is running on web $kIsWeb");
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
    Session.startSession().then((bool value) async {
      if (value) {
        print("\nsession ${Session.authToken}");

        
        Provider.of<RecognizedFacesProvider>(context, listen: false)
            .saveCameraLocations(Session.cameraLocations);

    
        // saveCameraLocations

        await Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => DashBoard()),
            (route) => false);
      } else {

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/map_background.png',
            alignment: Alignment.center,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                "assets/realtime_surveillance_system.png",
                alignment: Alignment.center,
                fit: BoxFit.fitWidth,
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: Transform.rotate(
                angle: -130,
                child: Image.asset(
                  "assets/walk_color.png",
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * .4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
