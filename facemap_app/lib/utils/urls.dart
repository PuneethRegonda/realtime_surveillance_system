import 'package:facemap_app/utils/session.dart';

class Urls {
  static String _localIp = "http://192.168.100.15:1291/api/user/";
  static String _localFLaskIP = "http://127.0.0.1:5000/";
  static String _production =
      "https://face-map-node-server.herokuapp.com/api/user/";
  static final String _baseUrl = Session.isLocalHost ? _localIp : _production;
  static String _recognizerServerbase =
      "https://facemap-flask-backend.herokuapp.com/";
// 192.168.100.15
  static final String _localhost = "http://192.168.100.15:1291/";
  static final String _productionhost =
      "https://face-map-node-server.herokuapp.com/";

  static final String host = Session.isLocalHost ? _localhost : _productionhost;

  static final String login = _baseUrl + "login";
  static final String dashboard = _baseUrl + "dashboard";
  static final String register = _baseUrl + "register";
  static final String groupMail = _baseUrl + "mail";

  static final String uploadPicture =
      (Session.isLocalHost ? _localFLaskIP : _recognizerServerbase) +
          "recognizer";

  static String check_history = _baseUrl + "check_history";
}
