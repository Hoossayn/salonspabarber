import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/bookings/model/bookings.dart';
import 'package:salonspabarber/ui/bookings/repository/bookings_repository.dart';

final BookingsRepository _bookingsRepository = new BookingsRepository();

class BookingsState extends AppState {
  Future<Bookings> requestBooking({@required Map body}) async {
    return await _bookingsRepository.requestBookings(body: body);
  }
}
