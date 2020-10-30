
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/ui/main/withdrawal/model/withdraw_response.dart';
import 'package:salonspabarber/ui/main/withdrawal/netowrking/withdraw_helper.dart';
import 'package:salonspabarber/ui/paymentHistory/walletHistory/networking/wallet_history_networking.dart';

WithdrawHelper _withdrawHelper = new WithdrawHelper();
class WithdrawRepository{

  Future<dynamic> withdraw({@required String url, @required Map body}) async {
    final _response = await _withdrawHelper.post(url: url, body: body);
    return WithdrawResponse.fromJson(json.decode(json.encode(_response)));
  }
}