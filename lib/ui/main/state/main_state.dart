import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/main/repository/main_repository.dart';

class MainState extends AppState{

  final MainRepository _mainRepository = MainRepository();
  Future<dynamic> getWalletBalance({@required String url, @required Map body}) async {
    return await _mainRepository.getWalletBalance(url: url, body: body);
  }

  Future<dynamic> getEarningBalance({@required String url, @required Map body}) async {
    return await _mainRepository.getEarningBalance(url: url, body: body);
  }

}