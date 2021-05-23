import 'package:facemap_app/models/camera_locations.dart';
import 'package:facemap_app/models/user.dart';
import 'package:facemap_app/utils/session.dart';
import 'package:http/http.dart';

import '../utils/result.dart';
import '../utils/urls.dart';

import 'dart:convert';

class AuthenticationApi {

  static Future<Result> dashboard() async {
    print("___Feteching dashboard data___");
    Response response = await post(Uri.parse(Urls.dashboard),
        body: {}, headers: {'auth-token': await Session.getAuthToken()});
    Result result = Result();
    if (response.statusCode == 200) {
      print(json.decode(response.body)['data']['user']);
      result.isSuccess = true;
      result.message = "Hi, Welcome back!";
      result.data = {
        'auth-token': response.headers["auth-token"],
        'location': json.decode(response.body)['data']['location'],
        'user': json.decode(response.body)['data']['user']
      };
    } else {
      result.isSuccess = false;
      result.message = "Something went wrong !";
      result.data = json.decode(response.body);
    }
    print(result);
    return result;
  }

  static Future<Result> login(String mail, String password) async {
    print("________LOGIN REQUEST_________ ");

    var payload = {
      "email": "puneethregonda1291@gmail.com",
      "password": "facemap_admin1291"
    };

    if (Session.isLocalHost) {
      payload = {
        'email': 'puneethregonda1291@gmail.com',
        'password': 'Password'
      };
    }

    if (mail != null && password != null) {
      payload = {'email': mail, 'password': password};
    }

    // print(payload.toString());
    Response response = await post(Uri.parse(Urls.login),
        body: payload, headers: {'auth-token': Session.authToken});
    Result result = Result();

    // print(json.decode(response.body));
    if (response.statusCode == 200) {
      print("Auth-Token ${response.headers["auth-token"]}");
      print("User: ${json.decode(response.body)['data']['user']}");
      result.isSuccess = true;
      result.message = "Login Succesful";
      result.data = {
        'auth-token': response.headers["auth-token"],
        'location': json.decode(response.body)['data']['location'],
        'user': json.decode(response.body)['data']['user']
      };
      Session.saveAuthToken(result.data['auth-token']);
      Session.cameraLocations =
          CameraLocations.fromJSONList(result.data['location']);
      Session.user =
          SessionUser.fromJSON(json.decode(response.body)['data']['user']);
    } else {
      result.isSuccess = false;
      result.message = "Login failed";
      result.data = json.decode(response.body);
    }
    print(result);
    return result;
  }

  static Future<Result> register_user(Map<String, dynamic> payload) async {
    print("Registering user");
    // payload['isAdmin'] = false;
    Response response = await post(Uri.parse(Urls.register), body: payload);
    Result result = Result();

    if (response.statusCode == 200) {
      result.isSuccess = true;
      result.message = "Registration Succesful";
      result.data = {};
    } else {
      result.isSuccess = false;
      result.message = "Login failed";
      result.data = json.decode(response.body);
    }

    print(result);
    return result;
  }
  
}
