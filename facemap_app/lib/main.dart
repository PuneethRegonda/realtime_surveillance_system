import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/recognized_faces.dart';
import 'splash_screen.dart';

void main() {
  runApp(FaceMap());
}

class FaceMap extends StatelessWidget {
  const FaceMap({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecognizedFacesProvider())
      ],
      child: MaterialApp(
          theme: ThemeData.light(),
          debugShowMaterialGrid: false,
          showPerformanceOverlay: false,
          debugShowCheckedModeBanner: false,
          home: SplashScreen()),
    );
  }
}
