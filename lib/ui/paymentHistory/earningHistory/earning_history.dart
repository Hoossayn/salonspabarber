import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:salonspabarber/helper/validation.dart';
import 'package:salonspabarber/ui/paymentHistory/earningHistory/model/earning_history_response.dart';

class EarningHistoryPage extends StatefulWidget {

  final List<EarnHistory> earningHistory;

  EarningHistoryPage({this.earningHistory});


  @override
  _EarningHistoryPageState createState() => _EarningHistoryPageState();
}

class _EarningHistoryPageState extends State<EarningHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: widget.earningHistory.map((e) => earningHistory(
            context,currency(context, int.parse(e.amount.toString())) , e.requestDate, e.status.toString())).toList(),
      ),
    );
  }
}
Widget earningHistory(BuildContext context,String amount,  String date, String status){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(amount, style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 5),
                Text(date == null ? "date": date)
              ],
            ),
            Text(status == null ?"Nothing": status.contains('1')  ? "Paid":"Pending",
              style: TextStyle(
                color: Colors.green
              ),),
          ],
        ),
      ),
    ),
  );
}