import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salonspabarber/helper/validation.dart';
import 'package:salonspabarber/ui/paymentHistory/walletHistory/wallet_history_detail.dart';
import 'model/wallet_history_response.dart';

class WalletHistoryPage extends StatefulWidget {

  final List<WalletHistory> walletHistory;

  WalletHistoryPage({this.walletHistory});

  @override
  _WalletHistoryPageState createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: widget.walletHistory.map((e) => walletHistory(context, e.paidAt,
            currency(context, int.parse(e.amount.toString())), e.reference)).toList()
      ),
    );
  }
}

Widget walletHistory(BuildContext context, String date, String amount, String reference){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => WalletHistoryDetail(amount: amount, time: date, reference: reference,)));
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deposit', style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 10),
                  Text(date)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(icon: new Icon(Icons.arrow_forward_ios)),
                  SizedBox(height: 10),
                  Text(amount)
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

