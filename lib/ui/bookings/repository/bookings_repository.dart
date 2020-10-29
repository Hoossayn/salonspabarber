import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/ui/bookings/model/bookings.dart';
import 'package:salonspabarber/ui/bookings/networking/bookings_networking.dart';

final BookingsHelper _bookingsHelper = new BookingsHelper();

class BookingsRepository{
  Future<Bookings> requestBookings({@required Map body}) async {
    final _response = await _bookingsHelper.post(body: body);
    return Bookings.fromMessageJson(json.decode(json.encode(_response)));
  }
}