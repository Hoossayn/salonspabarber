import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/networking/exception_handling.dart';
import 'package:salonspabarber/networking/exceptions.dart';

class ProfSettingsHelper {
  Future<dynamic> post({@required String url, @required Map body}) async {
    var responseJson;
    String _url = '${StringRes.BASE_URL}$url';
    try {
      final response = await http
          .post(
        _url,
        body: body,
      )
          .timeout(Duration(seconds: 15));
      responseJson = returnResponse(response);
      print('Body: ${response.body}');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
}