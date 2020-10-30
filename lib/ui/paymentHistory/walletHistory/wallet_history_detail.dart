import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletHistoryDetail extends StatefulWidget {

  var amount, time, status, reference;

  WalletHistoryDetail({this.amount, this.time, this.status, this.reference});


  @override
  _WalletHistoryDetailState createState() => _WalletHistoryDetailState();
}

class _WalletHistoryDetailState extends State<WalletHistoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details'), backgroundColor: Colors.deepPurple,),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: GoogleFonts.roboto(
                          color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      widget.amount,
                      style: GoogleFonts.roboto(
                          color: Colors.grey,
                          fontSize: 16,
                      fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      style: GoogleFonts.roboto(
                          color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      'Success',
                      style: GoogleFonts.roboto(
                          color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time',
                      style: GoogleFonts.roboto(
                          color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      widget.time,
                      style: GoogleFonts.roboto(
                          color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reference',
                      style: GoogleFonts.roboto(
                          color: Colors.black, fontSize: 16),
                    ),
                    Text(
                      widget.reference,
                      style: GoogleFonts.roboto(
                          color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'For Complaint, Call 0811223345',
                  style: GoogleFonts.roboto(
                      color: Colors.grey, fontSize: 16),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}
