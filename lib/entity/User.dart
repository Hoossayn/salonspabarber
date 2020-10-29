class UserEntity {
  String imageUrl;
  dynamic token;
  String name;
  String email;
  String isVerifiedAsBarber;
  String phone;
  String id;
  String jwt;


  UserEntity({this.imageUrl, this.token, this.name, this.email,
    this.isVerifiedAsBarber, this.phone, this.id, this.jwt});

  static Map<String, dynamic> toJson(UserEntity user) {
    Map<String, dynamic> map = Map();
    map['image_url'] = user.imageUrl;
    map['token'] = user.token;
    map['name'] = user.name;
    map['email'] = user.email;
    map['is_verified_as_barber'] = user.isVerifiedAsBarber;
    map['phone'] = user.phone;
    map['id'] = user.id;
    map['jwt'] = user.jwt;
    return map;
  }

  UserEntity.fromJson({Map<String, dynamic> json})
      : imageUrl = json['image_url'],
        token = json['token'],
        name = json['name'],
        email = json['email'],
        isVerifiedAsBarber = json['is_verified_as_barber'],
        phone = json['phone'],
        id = json['id'],
        jwt = json['jwt'];
}
