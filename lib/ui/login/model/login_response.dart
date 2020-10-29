/// Message : "Loggedin Success!"
/// User : {"image_url":"https://www.cornwallbusinessawards.co.uk/wp-content/uploads/2017/11/dummy450x450.jpg","token":null,"name":"Davidd","email":"ab@gmail.com","is_verified_as_barber":"salonandspa","phone":"09058052267","id":70,"jwt":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcHAub3JnIiwiYXVkIjoiaHR0cDpcL1wvYXBwLmNvbSIsImlhdCI6MTM1Njk5OTUyNCwiaWQiOjcwLCJuYmYiOjEzNTcwMDAwMDB9.GKz3D-Ty_T34c7aYnIPzS_EctCWrJnASsgoowl3GmEI"}

class LoginResponse {
  String _message;
  User _user;

  String get message => _message;
  User get user => _user;

  LoginResponse({
      String message, 
      User user}){
    _message = message;
    _user = user;
}

  LoginResponse.fromJson(dynamic json) {
    _message = json["Message"];
    _user = json["User"] != null ? User.fromJson(json["User"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Message"] = _message;
    if (_user != null) {
      map["User"] = _user.toJson();
    }
    return map;
  }

}

/// image_url : "https://www.cornwallbusinessawards.co.uk/wp-content/uploads/2017/11/dummy450x450.jpg"
/// token : null
/// name : "Davidd"
/// email : "ab@gmail.com"
/// is_verified_as_barber : "salonandspa"
/// phone : "09058052267"
/// id : 70
/// jwt : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcHAub3JnIiwiYXVkIjoiaHR0cDpcL1wvYXBwLmNvbSIsImlhdCI6MTM1Njk5OTUyNCwiaWQiOjcwLCJuYmYiOjEzNTcwMDAwMDB9.GKz3D-Ty_T34c7aYnIPzS_EctCWrJnASsgoowl3GmEI"

class User {
  String _imageUrl;
  dynamic _token;
  String _name;
  String _email;
  String _isVerifiedAsBarber;
  String _phone;
  int _id;
  String _jwt;

  String get imageUrl => _imageUrl;
  dynamic get token => _token;
  String get name => _name;
  String get email => _email;
  String get isVerifiedAsBarber => _isVerifiedAsBarber;
  String get phone => _phone;
  int get id => _id;
  String get jwt => _jwt;

  User({
      String imageUrl, 
      dynamic token, 
      String name, 
      String email, 
      String isVerifiedAsBarber, 
      String phone, 
      int id, 
      String jwt}){
    _imageUrl = imageUrl;
    _token = token;
    _name = name;
    _email = email;
    _isVerifiedAsBarber = isVerifiedAsBarber;
    _phone = phone;
    _id = id;
    _jwt = jwt;
}

  User.fromJson(dynamic json) {
    _imageUrl = json["imageUrl"];
    _token = json["token"];
    _name = json["name"];
    _email = json["email"];
    _isVerifiedAsBarber = json["is_verified_as_barber"];
    _phone = json["phone"];
    _id = json["id"];
    _jwt = json["jwt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["imageUrl"] = _imageUrl;
    map["token"] = _token;
    map["name"] = _name;
    map["email"] = _email;
    map["is_verified_as_barber"] = _isVerifiedAsBarber;
    map["phone"] = _phone;
    map["id"] = _id;
    map["jwt"] = _jwt;
    return map;
  }

}