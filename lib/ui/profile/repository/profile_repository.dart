import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/ui/profile/model/profile_response.dart';
import 'package:salonspabarber/ui/profile/networking/profile_networking.dart';


final ProfSettingsHelper _profSettingsHelper = ProfSettingsHelper();

class ProfSettingsRepository {
  Future<ProfileResponse> updateProf({@required String url, @required Map body}) async {
    final _response = await _profSettingsHelper.post(url: url, body: body);
    final _user = ProfileResponse.fromJson(json.decode(json.encode(_response)));
    return _user;
  }
}
