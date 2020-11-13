import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/helper/theme.dart';
import 'package:salonspabarber/helper/validation.dart';
import 'package:salonspabarber/utilities/image_loader.dart';

import 'model/bookings.dart';

class MyBookingDetails extends StatefulWidget {
  MyBookingDetails({this.bookings});

  final Bookings bookings;

  @override
  _MyBookingDetailsState createState() =>
      _MyBookingDetailsState(bookings: bookings);
}

class _MyBookingDetailsState extends State<MyBookingDetails> {
  _MyBookingDetailsState({this.bookings});

  final Bookings bookings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        centerTitle: true,
        title: Text(
          'Booking Details',
          style: GoogleFonts.roboto(
              fontSize: 18, fontStyle: FontStyle.normal, color: AppColor.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 32,
              ),
              Flexible(
                child: CircleImage(
                  path: StringRes.ASSET_DEFAULT_AVATAR,
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              Flexible(
                child: ListTile(
                  title: Text('Barbers Name',
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          color: AppColor.darkgrey)),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: AppColor.buttonDarkWhite,
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        bookings != null && bookings.clientName.isNotEmpty
                            ? bookings.clientName
                            : '',
                        style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            color: AppColor.textColorPurple),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 32,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            title: Text('Address',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    color: AppColor.darkgrey)),
            isThreeLine: true,
            subtitle: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: AppColor.buttonDarkWhite,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  bookings != null &&
                      bookings.clientLocation != null &&
                      bookings.clientLocation.isNotEmpty
                      ? bookings.clientLocation
                      : '',
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: AppColor.textColorPurple),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 23,
          ),
          ListTile(
            title: Text('Payment',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    color: AppColor.darkgrey)),
            isThreeLine: true,
            subtitle: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: AppColor.buttonDarkWhite,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Cash',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: AppColor.textColorPurple),
                        ),
                        Text(
                          bookings != null &&
                              bookings.serviceAmount.toString().isNotEmpty
                              ? '${currency(context, _convertStringCurrencyToInt(bookings.serviceAmount.toString()))}'
                              : '${currency(context, 0)}',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: AppColor.textColorPurple),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Payment Status',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: AppColor.textColorPurple),
                        ),
                        Text(
                          bookings != null && bookings.paymentStatus.isNotEmpty
                              ? bookings.paymentStatus
                              : '',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: AppColor.textColorPurple),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 23,
          ),
          ListTile(
            title: Text('Preferred Tools',
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    color: AppColor.darkgrey)),
            isThreeLine: true,
            subtitle: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: AppColor.buttonDarkWhite,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '',
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: AppColor.textColorPurple),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 23,
          ),
          Container(
            margin: EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
                color: AppColor.buttonDarkWhite,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    bookings != null &&
                        bookings.noOfMen.toString().isNotEmpty &&
                        !bookings.noOfMen.toString().contains('null')
                        ? 'Men: ${bookings.noOfMen}'
                        : 'Men: ',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        color: AppColor.textColorPurple),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    bookings != null &&
                        bookings.noOfWomen.toString().isNotEmpty &&
                        !bookings.noOfWomen.toString().contains('null')
                        ? 'Women: ${bookings.noOfWomen}'
                        : 'Women: ',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        color: AppColor.textColorPurple),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    bookings != null &&
                        bookings.noOfChildrenInt.toString().isNotEmpty &&
                        !bookings.noOfChildrenInt
                            .toString()
                            .contains('null')
                        ? 'Children: ${bookings.noOfChildrenInt}'
                        : 'Children: ',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        color: AppColor.textColorPurple),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int _convertStringCurrencyToInt(String serviceAmount) {
    int _money = int.parse(serviceAmount);
    return _money;
  }
}

