import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/ui/paymentHistory/walletHistory/networking/wallet_history_networking.dart';
import '../model/wallet_history_response.dart';

final WalletHistoryHelper _walletHistoryHelper = WalletHistoryHelper();
class WalletRepository{

  Future<WalletHistoryResponse> getWalletHistory({@required String url, @required Map body}) async {
    final _response = await _walletHistoryHelper.post(url: url, body: body);

    return WalletHistoryResponse.fromJson(json.decode(json.encode(_response)));
  }
}