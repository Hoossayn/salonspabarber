/// notification : {"title":"null","body":"null"}
/// data : {"isRequesting":true,"barberId":"bghghgh","clientNumber":"08167997730","prefTools":"clipper","noOfChildren":"0","noOfWomen":"1","userId":"125","clientAddress":"1 Abubakar Usman, Utako, Abuja, Nigeria","barberName":"gsfsdf","clientPhoto":"dfgdfgd","barberNumber":"dadsds","requestKey":"-ML8Ore872dnROx-CkIt","title":"Requesting Barber","dateAndTime":"2020-11-02T15:41:02.193763","clientId":125,"paymentAmount":1500,"message":"onyemordi Daniel is requesting for a Barber","clientName":"onyemordi Daniel","paymentMethod":"Cash","hasArrived":false,"requestStatus":"REQUESTING","paymentStatus":"Not Paid","serviceAmount":"300","barberImageUrl":"khjhjhj","userLatitude":"9.06215181250576","noOfMen":"0","userLongitude":"7.425684258341789"}

class NotificationModel {
  Notification _notification;
  Data _data;

  Notification get notification => _notification;
  Data get data => _data;

  NotificationModel({
      Notification notification, 
      Data data}){
    _notification = notification;
    _data = data;
}

  NotificationModel.fromJson(dynamic json) {
    _notification = json["notification"] != null ? Notification.fromJson(json["notification"]) : null;
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_notification != null) {
      map["notification"] = _notification.toJson();
    }
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }

}

/// isRequesting : true
/// barberId : "bghghgh"
/// clientNumber : "08167997730"
/// prefTools : "clipper"
/// noOfChildren : "0"
/// noOfWomen : "1"
/// userId : "125"
/// clientAddress : "1 Abubakar Usman, Utako, Abuja, Nigeria"
/// barberName : "gsfsdf"
/// clientPhoto : "dfgdfgd"
/// barberNumber : "dadsds"
/// requestKey : "-ML8Ore872dnROx-CkIt"
/// title : "Requesting Barber"
/// dateAndTime : "2020-11-02T15:41:02.193763"
/// clientId : 125
/// paymentAmount : 1500
/// message : "onyemordi Daniel is requesting for a Barber"
/// clientName : "onyemordi Daniel"
/// paymentMethod : "Cash"
/// hasArrived : false
/// requestStatus : "REQUESTING"
/// paymentStatus : "Not Paid"
/// serviceAmount : "300"
/// barberImageUrl : "khjhjhj"
/// userLatitude : "9.06215181250576"
/// noOfMen : "0"
/// userLongitude : "7.425684258341789"

class Data {
  bool _isRequesting;
  String _barberId;
  String _clientNumber;
  String _prefTools;
  String _noOfChildren;
  String _noOfWomen;
  String _userId;
  String _clientAddress;
  String _barberName;
  String _clientPhoto;
  String _barberNumber;
  String _requestKey;
  String _title;
  String _dateAndTime;
  int _clientId;
  int _paymentAmount;
  String _message;
  String _clientName;
  String _paymentMethod;
  bool _hasArrived;
  String _requestStatus;
  String _paymentStatus;
  String _serviceAmount;
  String _barberImageUrl;
  String _userLatitude;
  String _noOfMen;
  String _userLongitude;

  bool get isRequesting => _isRequesting;
  String get barberId => _barberId;
  String get clientNumber => _clientNumber;
  String get prefTools => _prefTools;
  String get noOfChildren => _noOfChildren;
  String get noOfWomen => _noOfWomen;
  String get userId => _userId;
  String get clientAddress => _clientAddress;
  String get barberName => _barberName;
  String get clientPhoto => _clientPhoto;
  String get barberNumber => _barberNumber;
  String get requestKey => _requestKey;
  String get title => _title;
  String get dateAndTime => _dateAndTime;
  int get clientId => _clientId;
  int get paymentAmount => _paymentAmount;
  String get message => _message;
  String get clientName => _clientName;
  String get paymentMethod => _paymentMethod;
  bool get hasArrived => _hasArrived;
  String get requestStatus => _requestStatus;
  String get paymentStatus => _paymentStatus;
  String get serviceAmount => _serviceAmount;
  String get barberImageUrl => _barberImageUrl;
  String get userLatitude => _userLatitude;
  String get noOfMen => _noOfMen;
  String get userLongitude => _userLongitude;

  Data({
      bool isRequesting, 
      String barberId, 
      String clientNumber, 
      String prefTools, 
      String noOfChildren, 
      String noOfWomen, 
      String userId, 
      String clientAddress, 
      String barberName, 
      String clientPhoto, 
      String barberNumber, 
      String requestKey, 
      String title, 
      String dateAndTime, 
      int clientId, 
      int paymentAmount, 
      String message, 
      String clientName, 
      String paymentMethod, 
      bool hasArrived, 
      String requestStatus, 
      String paymentStatus, 
      String serviceAmount, 
      String barberImageUrl, 
      String userLatitude, 
      String noOfMen, 
      String userLongitude}){
    _isRequesting = isRequesting;
    _barberId = barberId;
    _clientNumber = clientNumber;
    _prefTools = prefTools;
    _noOfChildren = noOfChildren;
    _noOfWomen = noOfWomen;
    _userId = userId;
    _clientAddress = clientAddress;
    _barberName = barberName;
    _clientPhoto = clientPhoto;
    _barberNumber = barberNumber;
    _requestKey = requestKey;
    _title = title;
    _dateAndTime = dateAndTime;
    _clientId = clientId;
    _paymentAmount = paymentAmount;
    _message = message;
    _clientName = clientName;
    _paymentMethod = paymentMethod;
    _hasArrived = hasArrived;
    _requestStatus = requestStatus;
    _paymentStatus = paymentStatus;
    _serviceAmount = serviceAmount;
    _barberImageUrl = barberImageUrl;
    _userLatitude = userLatitude;
    _noOfMen = noOfMen;
    _userLongitude = userLongitude;
}

  Data.fromJson(dynamic json) {
    _isRequesting = json["isRequesting"];
    _barberId = json["barberId"];
    _clientNumber = json["clientNumber"];
    _prefTools = json["prefTools"];
    _noOfChildren = json["noOfChildren"];
    _noOfWomen = json["noOfWomen"];
    _userId = json["userId"];
    _clientAddress = json["clientAddress"];
    _barberName = json["barberName"];
    _clientPhoto = json["clientPhoto"];
    _barberNumber = json["barberNumber"];
    _requestKey = json["requestKey"];
    _title = json["title"];
    _dateAndTime = json["dateAndTime"];
    _clientId = json["clientId"];
    _paymentAmount = json["paymentAmount"];
    _message = json["message"];
    _clientName = json["clientName"];
    _paymentMethod = json["paymentMethod"];
    _hasArrived = json["hasArrived"];
    _requestStatus = json["requestStatus"];
    _paymentStatus = json["paymentStatus"];
    _serviceAmount = json["serviceAmount"];
    _barberImageUrl = json["barberImageUrl"];
    _userLatitude = json["userLatitude"];
    _noOfMen = json["noOfMen"];
    _userLongitude = json["userLongitude"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["isRequesting"] = _isRequesting;
    map["barberId"] = _barberId;
    map["clientNumber"] = _clientNumber;
    map["prefTools"] = _prefTools;
    map["noOfChildren"] = _noOfChildren;
    map["noOfWomen"] = _noOfWomen;
    map["userId"] = _userId;
    map["clientAddress"] = _clientAddress;
    map["barberName"] = _barberName;
    map["clientPhoto"] = _clientPhoto;
    map["barberNumber"] = _barberNumber;
    map["requestKey"] = _requestKey;
    map["title"] = _title;
    map["dateAndTime"] = _dateAndTime;
    map["clientId"] = _clientId;
    map["paymentAmount"] = _paymentAmount;
    map["message"] = _message;
    map["clientName"] = _clientName;
    map["paymentMethod"] = _paymentMethod;
    map["hasArrived"] = _hasArrived;
    map["requestStatus"] = _requestStatus;
    map["paymentStatus"] = _paymentStatus;
    map["serviceAmount"] = _serviceAmount;
    map["barberImageUrl"] = _barberImageUrl;
    map["userLatitude"] = _userLatitude;
    map["noOfMen"] = _noOfMen;
    map["userLongitude"] = _userLongitude;
    return map;
  }

}

/// title : "null"
/// body : "null"

class Notification {
  String _title;
  String _body;

  String get title => _title;
  String get body => _body;

  Notification({
      String title, 
      String body}){
    _title = title;
    _body = body;
}

  Notification.fromJson(dynamic json) {
    _title = json["title"];
    _body = json["body"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["body"] = _body;
    return map;
  }

}