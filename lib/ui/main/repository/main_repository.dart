import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/ui/main/model/earning_balance.dart';
import 'package:salonspabarber/ui/main/model/wallet_balance.dart';
import 'package:salonspabarber/ui/main/networking/main_helper.dart';

final MainHelper _mainHelper = new MainHelper();

class MainRepository{

  Future<dynamic> getWalletBalance({@required String url, @required Map body}) async {
    final _response = await _mainHelper.post(url: url, body: body);
    return WalletBalance.fromJson(json.decode(json.encode(_response)));
  }

  Future<dynamic> getEarningBalance({@required String url, @required Map body}) async {
    final _response = await _mainHelper.post(url: url, body: body);
    return EarningBalance.fromJson(json.decode(json.encode(_response)));
  }
  
}