import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

/// notification : {"title":"null","body":"null"}
/// data : {"isRequesting":true,"barberId":"bghghgh","clientNumber":"08167997730","prefTools":"clipper","noOfChildren":"0","noOfWomen":"1","userId":"125","clientAddress":"1 Abubakar Usman, Utako, Abuja, Nigeria","barberName":"gsfsdf","clientPhoto":"dfgdfgd","barberNumber":"dadsds","requestKey":"-ML8Ore872dnROx-CkIt","title":"Requesting Barber","dateAndTime":"2020-11-02T15:41:02.193763","clientId":125,"paymentAmount":1500,"message":"onyemordi Daniel is requesting for a Barber","clientName":"onyemordi Daniel","paymentMethod":"Cash","hasArrived":false,"requestStatus":"REQUESTING","paymentStatus":"Not Paid","serviceAmount":"300","barberImageUrl":"khjhjhj","userLatitude":"9.06215181250576","noOfMen":"0","userLongitude":"7.425684258341789"}

class NotificationModel {
  Notification _notification;
  NotificationData _data;

  Notification get notification => _notification;
  NotificationData get data => _data;

  NotificationModel({
      Notification notification, 
      NotificationData data}){
    _notification = notification;
    _data = data;
}

  NotificationModel.fromJson(dynamic json) {
    _notification = json["notification"] != null ? Notification.fromJson(json["notification"]) : null;
    _data = json["data"] != null ? NotificationData.fromJson(json["data"]) : null;
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

class NotificationData {
  bool isRequesting;
  dynamic barberId;
  dynamic clientNumber;
  dynamic prefTools;
  dynamic noOfChildren;
  dynamic noOfWomen;
  dynamic userId;
  dynamic clientAddress;
  dynamic barberName;
  dynamic clientPhoto;
  dynamic barberNumber;
  dynamic requestKey;
  dynamic title;
  dynamic dateAndTime;
  dynamic clientId;
  dynamic paymentAmount;
  dynamic message;
  dynamic clientName;
  dynamic paymentMethod;
  bool hasArrived;
  dynamic requestStatus;
  dynamic paymentStatus;
  dynamic serviceAmount;
  dynamic barberImageUrl;
  dynamic userLatitude;
  dynamic noOfMen;
  dynamic userLongitude;

/*  bool get isRequesting => isRequesting;
  String get barberId => barberId;
  String get clientNumber => clientNumber;
  String get prefTools => prefTools;
  String get noOfChildren => noOfChildren;
  String get noOfWomen => noOfWomen;
  String get userId => userId;
  String get clientAddress => clientAddress;
  String get barberName => barberName;
  String get clientPhoto => clientPhoto;
  String get barberNumber => barberNumber;
  String get requestKey => requestKey;
  String get title => title;
  String get dateAndTime => dateAndTime;
  int get clientId => clientId;
  int get paymentAmount => paymentAmount;
  String get message => message;
  String get clientName => clientName;
  String get paymentMethod => paymentMethod;
  bool get hasArrived => hasArrived;
  String get requestStatus => requestStatus;
  String get paymentStatus => paymentStatus;
  String get serviceAmount => serviceAmount;
  String get barberImageUrl => barberImageUrl;
  String get userLatitude => userLatitude;
  String get noOfMen => noOfMen;
  String get userLongitude => userLongitude;*/

 /* NotificationData({
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
    isRequesting = isRequesting;
    barberId = barberId;
    clientNumber = clientNumber;
    prefTools = prefTools;
    noOfChildren = noOfChildren;
    noOfWomen = noOfWomen;
    userId = userId;
    clientAddress = clientAddress;
    barberName = barberName;
    clientPhoto = clientPhoto;
    barberNumber = barberNumber;
    requestKey = requestKey;
    title = title;
    dateAndTime = dateAndTime;
    clientId = clientId;
    paymentAmount = paymentAmount;
    message = message;
    clientName = clientName;
    paymentMethod = paymentMethod;
    hasArrived = hasArrived;
    requestStatus = requestStatus;
    paymentStatus = paymentStatus;
    serviceAmount = serviceAmount;
    barberImageUrl = barberImageUrl;
    userLatitude = userLatitude;
    noOfMen = noOfMen;
    userLongitude = userLongitude;*/

  NotificationData.checkBeforeSendingToServer({
    @required this.isRequesting,
    @required this.barberId,
    @required this.clientNumber,
    @required this.prefTools,
    @required this.noOfChildren,
    @required this.noOfWomen,
    @required this.userId,
    @required this.clientAddress,
    @required this.barberName,
    @required this.clientPhoto,
    @required this.barberNumber,
    @required this.requestKey,
    @required this.title,
    @required this.dateAndTime,
    @required this.clientId,
    @required this.paymentAmount,
    @required this.message,
    @required this.clientName,
    @required this.paymentMethod,
    @required this.hasArrived,
    @required this.requestStatus,
    @required this.paymentStatus,
    @required this.serviceAmount,
    @required this.barberImageUrl,
    @required this.userLatitude,
    @required this.noOfMen,
    @required this.userLongitude
  });
  fromMap(Map<dynamic,dynamic> json){
    return NotificationData.checkBeforeSendingToServer(
        isRequesting: json["isRequesting"] ?? null,
        barberId: json["barberId"] ?? null,
        clientNumber: json["clientNumber"] ?? null,
        prefTools: json["prefTools"] ?? null,
        noOfChildren: json["noOfChildren"] ?? null,
        noOfWomen: json["noOfWomen"] ?? null,
        userId: json["userId"] ?? null,
        clientAddress: json["clientAddress"] ?? null,
        barberName: json["barberName"] ?? null,
        clientPhoto: json["clientPhoto"] ?? null,
        barberNumber: json["barberNumber"] ?? null,
        requestKey: json["requestKey"] ?? null,
        title: json["title"] ?? null,
        dateAndTime: json["dateAndTime"] ?? null,
        clientId: json["clientId"] ?? null,
        paymentAmount: json["paymentAmount"] ?? null,
        message: json["message"] ?? null,
        clientName: json["clientName"] ?? null,
        paymentMethod: json["paymentMethod"] ?? null,
        hasArrived: json["hasArrived"] ?? null,
        requestStatus: json["requestStatus"] ?? null,
        paymentStatus: json["paymentStatus"] ?? null,
        serviceAmount: json["serviceAmount"] ?? null,
        barberImageUrl: json["barberImageUrl"] ?? null,
        userLatitude: json["userLatitude"] ?? null,
        noOfMen: json["noOfMen"] ?? null,
        userLongitude: json["userLongitude"] ?? null);

  }

  NotificationData.fromJson(dynamic json) {
    isRequesting = json["isRequesting"];
    barberId = json["barberId"];
    clientNumber = json["clientNumber"];
    prefTools = json["prefTools"];
    noOfChildren = json["noOfChildren"];
    noOfWomen = json["noOfWomen"];
    userId = json["userId"];
    clientAddress = json["clientAddress"];
    barberName = json["barberName"];
    clientPhoto = json["clientPhoto"];
    barberNumber = json["barberNumber"];
    requestKey = json["requestKey"];
    title = json["title"];
    dateAndTime = json["dateAndTime"];
    clientId = json["clientId"];
    paymentAmount = json["paymentAmount"];
    message = json["message"];
    clientName = json["clientName"];
    paymentMethod = json["paymentMethod"];
    hasArrived = json["hasArrived"];
    requestStatus = json["requestStatus"];
    paymentStatus = json["paymentStatus"];
    serviceAmount = json["serviceAmount"];
    barberImageUrl = json["barberImageUrl"];
    userLatitude = json["userLatitude"];
    noOfMen = json["noOfMen"];
    userLongitude = json["userLongitude"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["isRequesting"] = isRequesting;
    map["barberId"] = barberId;
    map["clientNumber"] = clientNumber;
    map["prefTools"] = prefTools;
    map["noOfChildren"] = noOfChildren;
    map["noOfWomen"] = noOfWomen;
    map["userId"] = userId;
    map["clientAddress"] = clientAddress;
    map["barberName"] = barberName;
    map["clientPhoto"] = clientPhoto;
    map["barberNumber"] = barberNumber;
    map["requestKey"] = requestKey;
    map["title"] = title;
    map["dateAndTime"] = dateAndTime;
    map["clientId"] = clientId;
    map["paymentAmount"] = paymentAmount;
    map["message"] = message;
    map["clientName"] = clientName;
    map["paymentMethod"] = paymentMethod;
    map["hasArrived"] = hasArrived;
    map["requestStatus"] = requestStatus;
    map["paymentStatus"] = paymentStatus;
    map["serviceAmount"] = serviceAmount;
    map["barberImageUrl"] = barberImageUrl;
    map["userLatitude"] = userLatitude;
    map["noOfMen"] = noOfMen;
    map["userLongitude"] = userLongitude;
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