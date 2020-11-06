
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/helper/theme.dart';
import 'package:salonspabarber/helper/validation.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;
  final BuildContext context;

  const CustomDialogBox({Key key, this.context, this.title, this.descriptions, this.text, this.img}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
    /*  shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: contentBox(context),*/
      child: contentBox(context),
    );
  }
  contentBox(context){
    return showDialog(
      barrierDismissible: false,
      context: context,
      child: Container(
        child: ListView(
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
                          widget.title,
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
                    widget.title,
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
                          Text(widget.title
                            /*bookings != null &&
                                  bookings.serviceAmount.toString().isNotEmpty
                                  ? '${currency(context, _convertStringCurrencyToInt(bookings.serviceAmount.toString()))}'
                                  : '${currency(context, 0)}'*/,
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
                            widget.title
                            /*bookings != null && bookings.paymentStatus.isNotEmpty
                                  ? bookings.paymentStatus
                                  : ''*/,
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
                    child: Text(widget.title
                      /* bookings != null &&
                            bookings.noOfMen.toString().isNotEmpty &&
                            !bookings.noOfMen.toString().contains('null')
                            ? 'Men: ${bookings.noOfMen}'
                            : 'Men: '*/,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          color: AppColor.textColorPurple),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.title
                      /*  bookings != null &&
                            bookings.noOfWomen.toString().isNotEmpty &&
                            !bookings.noOfWomen.toString().contains('null')
                            ? 'Women: ${bookings.noOfWomen}'
                            : 'Women: '*/,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          color: AppColor.textColorPurple),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.title
                      /*bookings != null &&
                            bookings.noOfChildrenInt.toString().isNotEmpty &&
                            !bookings.noOfChildrenInt
                                .toString()
                                .contains('null')
                            ? 'Children: ${bookings.noOfChildrenInt}'
                            : 'Children: '*/,
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
      ),
    );
  }
}

