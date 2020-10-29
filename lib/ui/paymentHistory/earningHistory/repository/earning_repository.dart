import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/ui/paymentHistory/earningHistory/model/earning_history_response.dart';
import 'package:salonspabarber/ui/paymentHistory/earningHistory/networking/earning_networking.dart';

final EarningHistoryHelper _earningHistoryHelper = EarningHistoryHelper();
class EarningRepository{

  Future<EarningHistoryResponse> getEarningHistory({@required String url, @required Map body}) async {
    final _response = await _earningHistoryHelper.post(url: url, body: body);
    return EarningHistoryResponse.fromJson(json.decode(json.encode(_response)));
  }
}