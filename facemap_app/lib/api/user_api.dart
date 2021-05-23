import 'dart:convert';

import 'package:facemap_app/utils/result.dart';
import 'package:facemap_app/utils/session.dart';
import 'package:facemap_app/utils/urls.dart';
import 'package:http/http.dart';

class UserAPI {
  static Future<Result> checkhistory(String name) async {
    print("___Feteching History____");

    Response response = await get(Uri.parse(Urls.check_history),
        headers: {'auth-token': await Session.getAuthToken(), 'nm': name});
    dynamic data = json.decode(response.body);
    print(data);
    Result result = Result();
    if (response.statusCode == 200) {
      result.isSuccess = true;
      result.data = data['data']['history'];
      result.message = data['message'];
    }

    return result;
  }

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
}
