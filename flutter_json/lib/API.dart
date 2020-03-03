import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://scodixreports.azurewebsites.net/api";

class API {
  static Future getMachines() {
    var url = baseUrl + "/Reports";
    return http.get(url);
  }
}