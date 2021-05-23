import 'dart:convert';

import 'package:facemap_app/utils/result.dart';
import 'package:facemap_app/utils/session.dart';
import 'package:facemap_app/utils/urls.dart';
import 'package:http/http.dart';

class AdminServices {
  static Future<Result> sendGroupMail(List<String> userlist, String location,
      String subject, String bodytxt) async {
        
    print("___Sending Group Mail_____");
    Response response = await post(Uri.parse(Urls.groupMail),
        body: json.encode({
          "location": location,
          "userlist": userlist,
          'subject': subject,
          'text': bodytxt
        }),
        headers: {
          'auth-token': await Session.getAuthToken(),
          'content-type': 'application/json',
        });
    Result result = Result();
    if (response.statusCode == 200) {
      result.isSuccess = true;
      result.message = "Sent mails";
    } else {
      result.isSuccess = false;
      result.message = "Something went wrong !";
    }
    result.data = json.decode(response.body);

    print(result);
    return result;
  }
}
