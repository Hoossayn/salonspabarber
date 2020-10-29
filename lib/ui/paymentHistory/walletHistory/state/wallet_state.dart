import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/paymentHistory/walletHistory/model/wallet_history_response.dart';
import 'package:salonspabarber/ui/paymentHistory/walletHistory/repository/wallet_history_repository.dart';

class WalletState extends AppState{

  final WalletRepository _walletRepository = WalletRepository();
  Future<WalletHistoryResponse> getWalletHistory({@required String url, @required Map body}) async {
    return await _walletRepository.getWalletHistory(url: url, body: body);
  }
}
