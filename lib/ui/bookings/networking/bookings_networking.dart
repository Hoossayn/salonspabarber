import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/networking/exception_handling.dart';
import 'package:salonspabarber/networking/exceptions.dart';

class BookingsHelper {
  Future<dynamic> post({@required Map body}) async {
    var responseJson;
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': StringRes.FCM_API_SERVER_KEY
    };
    try {
      final response = await http
          .post(StringRes.FCM_API, body: json.encode(body), headers: headers)
          .timeout(Duration(seconds: 15));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  
}
