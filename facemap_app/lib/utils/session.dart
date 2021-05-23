import 'package:facemap_app/models/camera_locations.dart';
import 'package:facemap_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/auth.dart';
import 'result.dart';

class Session {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Session() {
    _prefs = SharedPreferences.getInstance();
  }

  // this is just for development
  static bool isLocalHost = true;
  static String authToken = "";
  static SessionUser user;
  static Map<String, CameraLocations> cameraLocations = {};

  static Future<bool> startSession() async {
    print(".........starting session..........");
    final SharedPreferences prefs = await _prefs;
    if (prefs.containsKey('auth-token')) {
      await getAuthToken();
      Result result = await AuthenticationApi.dashboard();
      if (result.isSuccess) {
        user = SessionUser.fromJSON(result.data['user']);
        authToken = result.data['auth-token'];
        await saveAuthToken(authToken);
        cameraLocations = CameraLocations.fromJSONList(result.data['location']);
        return true;
      }
    }
    print(".........NO auth-token++:REDIRECTION_LOGINSCREEN..........");
    return false;
  }

  static Future<bool> saveAuthToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    authToken = token;
    return await prefs.setString('auth-token', token);
  }

  static Future<String> getAuthToken() async {
    final SharedPreferences prefs = await _prefs;
    // print(prefs.getString('auth-token'));
    authToken = prefs.getString('auth-token');
    print(authToken);
    return authToken;
  }
}
