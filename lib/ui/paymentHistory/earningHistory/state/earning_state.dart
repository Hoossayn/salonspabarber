
import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/paymentHistory/earningHistory/model/earning_history_response.dart';
import 'package:salonspabarber/ui/paymentHistory/earningHistory/repository/earning_repository.dart';

class EarningState extends AppState{
  final EarningRepository _earningRepository = EarningRepository();
  Future<EarningHistoryResponse> getEarningHistory({@required String url, @required Map body}) async {
    return await _earningRepository.getEarningHistory(url: url, body: body);
  }
}
