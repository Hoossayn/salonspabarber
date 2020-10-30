import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/main/withdrawal/repository/withdraw_repository.dart';

class WithdrawState extends AppState{

  final WithdrawRepository _withdrawRepository = WithdrawRepository();
  Future<dynamic> withdraw({@required String url, @required Map body}) async {
    return await _withdrawRepository.withdraw(url: url, body: body);
  }
}