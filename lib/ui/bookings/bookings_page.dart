import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salonspabarber/entity/User.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'bookings_detail_page.dart';
import 'model/bookings.dart';

class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {

  var _firebaseRef = FirebaseDatabase().reference();
  final _prefManager = SharedPreferencesHelper();
  UserEntity _user;

  @override
  void initState() {
    _usersDetails();
    super.initState();
  }

  void _usersDetails() {
    _prefManager.getUsersDetails().then((value) {
      setState(() => _user = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? Container()
        : Scaffold(
        body: StreamBuilder(
          stream: _firebaseRef
              .child('BarbersBookings')
              .child(_user.id.toString()).child('Bookings')
              .onValue,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.deepPurple,
                  ));

            if (snap.hasError) {
              return Center(
                  child: Text(
                    snap.error,
                    style: GoogleFonts.roboto(
                        color: Colors.grey, fontSize: 16),
                  ));
            }
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              List<Bookings> item = [];

              data.forEach(
                      (index, data) => item.add(new Bookings.fromJson(data)));

              return item.isEmpty
                  ? Center(
                  child: Text(
                    "You have not made any bookings",
                    style: GoogleFonts.roboto(
                        color: Colors.grey, fontSize: 16),
                  ))
                  : ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                  Bookings _bookings = item[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                     onTap: () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyBookingDetails(bookings: _bookings)));

                     },
                        isThreeLine: true,
                        title: Text(
                          _bookings != null && _bookings.clientName != null
                              ? _bookings.clientName
                              : '',
                          style: GoogleFonts.roboto(fontSize: 20),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                              text: '',
                              style: GoogleFonts.roboto(
                                  color: Colors.black54, fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                  text: _bookings != null &&
                                      _bookings.requestStatus != null
                                      ? '\n${_bookings.requestStatus}'
                                      : '',
                                  style: GoogleFonts.roboto(
                                      color: Colors.green, fontSize: 12),
                                )
                              ]),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: Text(
                'Your Bookings is Empty',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          },
        ));
  }
}
