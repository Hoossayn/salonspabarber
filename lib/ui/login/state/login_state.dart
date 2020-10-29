import 'package:flutter/cupertino.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/login/model/login_response.dart';
import 'package:salonspabarber/ui/login/repository/login_repository.dart';


class LoginState extends AppState{
   final LoginRepository _loginRepository = LoginRepository();
   Future<dynamic> loginUser({@required String url, @required Map body}) async {
     return await _loginRepository.loginUser(url: url, body: body);
   }
}