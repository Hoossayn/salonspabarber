import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/ui/main/funding/model/funding.dart';
import 'package:salonspabarber/ui/main/funding/networking/funding_networking.dart';

final FundingHelper _fundingHelper = FundingHelper();

class FundingRepository {
  Future<FundedWalletInServer> wallet({@required String url, @required Map map}) async {
    final _response = await _fundingHelper.post(url: url, map: map);
    return FundedWalletInServer.fromJson(json.decode(json.encode(_response)));
  }
}
