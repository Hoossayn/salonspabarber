/// Message : "Update Went Success!"
/// user : {"name":"daveed","phone":"08181185132","photo":"https://images.app.goo.gl/52GWxFioYAvKKUD57"}

class ProfileResponse {
  String _message;
  User _user;

  String get message => _message;
  User get user => _user;

  ProfileResponse({
      String message, 
      User user}){
    _message = message;
    _user = user;
}

  ProfileResponse.fromJson(dynamic json) {
    _message = json["Message"];
    _user = json["user"] != null ? User.fromJson(json["user"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Message"] = _message;
    if (_user != null) {
      map["user"] = _user.toJson();
    }
    return map;
  }

}

/// name : "daveed"
/// phone : "08181185132"
/// photo : "https://images.app.goo.gl/52GWxFioYAvKKUD57"

class User {
  String _name;
  String _phone;
  String _photo;

  String get name => _name;
  String get phone => _phone;
  String get photo => _photo;

  User({
      String name, 
      String phone, 
      String photo}){
    _name = name;
    _phone = phone;
    _photo = photo;
}

  User.fromJson(dynamic json) {
    _name = json["name"];
    _phone = json["phone"];
    _photo = json["photo"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["phone"] = _phone;
    map["photo"] = _photo;
    return map;
  }

}