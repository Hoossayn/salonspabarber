class Bookings {
  String barberName;
  String clientLocation;
  dynamic clientName;
  dynamic clientNumber;
  dynamic dateAndTime;
  dynamic noOfChildrenInt;
  dynamic noOfMen;
  dynamic noOfWomen;
  dynamic paymentMethod;
  String paymentStatus;
  dynamic requestKey;
  dynamic requestStatus;
  dynamic serviceAmount;
  dynamic userId;
  dynamic messageId;

  Bookings.message({this.messageId});

  Bookings({
      this.barberName,
      this.clientLocation,
      this.clientName,
      this.clientNumber,
      this.dateAndTime,
      this.noOfChildrenInt,
      this.noOfMen,
      this.noOfWomen,
      this.paymentMethod,
      this.paymentStatus,
      this.requestKey,
      this.requestStatus,
      this.serviceAmount,
      this.userId});

  factory Bookings.fromJson(dynamic json) {
    return Bookings(
      barberName: json['barberName'],
      clientLocation: json['clientLocation'],
      clientName: json['clientName'],
      clientNumber: json['clientNumber'],
      dateAndTime: json['dateAndTime'],
      noOfChildrenInt: json['noOfChildrenInt'],
      noOfMen: json['noOfMen'],
      noOfWomen: json['noOfWomen'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      requestKey: json['requestKey'],
      requestStatus: json['requestStatus'],
      serviceAmount: json['serviceAmount'],
      userId: json['userId'],

    );
  }

  factory Bookings.fromMessageJson(Map<String, dynamic> json) {
    return Bookings.message(messageId: json['message_id']);
  }
}

class Payment {
  String message;
  String balance;

  Payment({this.message, this.balance});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(message: json['Message'], balance: json['balance']);
  }
}
