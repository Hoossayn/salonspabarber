import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/main/funding/model/funding.dart';
import 'package:salonspabarber/ui/main/funding/repository/funding_repository.dart';

class FundingWalletState extends AppState {
  final FundingRepository _fundingRepository = FundingRepository();

  Future<FundedWalletInServer> getWalletFunding(
      {@required String path, @required Map map}) async {
    return await _fundingRepository.wallet(url: path, map: map);
  }
}
