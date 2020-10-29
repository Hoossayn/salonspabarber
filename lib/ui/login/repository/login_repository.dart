import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/entity/User.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/ui/login/model/login_response.dart';
import 'package:salonspabarber/ui/login/networking/login_networking.dart';


final LoginHelper _loginHelper = LoginHelper();
final _preManager = SharedPreferencesHelper();

class LoginRepository{

  Future<dynamic> loginUser({@required String url, @required Map body}) async {
    final _response = await _loginHelper.post(url: url, body: body);

    LoginResponse _user = LoginResponse.fromJson(json.decode(json.encode(_response)));
    if (_user.user != null) {
      _user = LoginResponse.fromJson(json.decode(json.encode(_response)));
      var _userEntity = UserEntity(
        imageUrl: _user.user.imageUrl,
        token: _user.user.token,
        name: _user.user.name,
        email: _user.user.email,
        isVerifiedAsBarber: _user.user.isVerifiedAsBarber,
        phone: _user.user.phone,
        id: _user.user.id.toString(),
        jwt: _user.user.jwt
      );
      _preManager.saveUsersDetails(UserEntity.toJson(_userEntity));
    } else {
      //_user = LoginResponse.failed(json.decode(json.encode(_response)));
    }

    return _user;
  }
}