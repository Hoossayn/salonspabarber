import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salonspabarber/entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static const String _USERS_PREF_KEY = 'key';
  static const String _JWT_PREF_KEY = 'jwt';
  static const String _ADDRESS_PREF_KEY = 'address';
  static const String _CLIENT_ID = 'client_id';
  static const String _REQUEST_KEY = 'request_key';


  read() async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(_USERS_PREF_KEY));
  }

  saveUsersDetails(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_USERS_PREF_KEY, json.encode(value));
  }

  Future<UserEntity> getUsersDetails() async {
    return UserEntity.fromJson(json: await this.read());
  }

/*
  Future<CatEntity> getCatDetails() async {
    return CatEntity.fromJson(json: await this.read());
  }
*/


  logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_USERS_PREF_KEY);
    prefs.remove(_JWT_PREF_KEY);
    prefs.remove(_ADDRESS_PREF_KEY);

   /* Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));*/

  }

  Future<bool> setEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_email', value);
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  Future<bool> setJwt(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_JWT_PREF_KEY, value);
  }

  Future<String> getJwt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_JWT_PREF_KEY);
  }

  Future<bool> setAddress(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_ADDRESS_PREF_KEY, value);
  }

  Future<String> getAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ADDRESS_PREF_KEY);
  }

  Future<bool> setClientId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_CLIENT_ID, value);
  }

  Future<String> getClientId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_CLIENT_ID);
  }

  Future<bool> setRequestKey(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_REQUEST_KEY, value);
  }

  Future<String> getRequestKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_REQUEST_KEY);
  }
}
