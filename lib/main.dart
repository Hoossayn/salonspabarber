import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:salonspabarber/state/app_state.dart';
import 'package:salonspabarber/ui/login/login_page.dart';
import 'package:salonspabarber/ui/login/state/login_state.dart';
import 'package:salonspabarber/ui/main/funding/state/funding_state.dart';
import 'package:salonspabarber/ui/main/state/main_state.dart';
import 'package:salonspabarber/ui/main/withdrawal/state/withdraw_state.dart';
import 'package:salonspabarber/ui/paymentHistory/earningHistory/state/earning_state.dart';
import 'package:salonspabarber/ui/paymentHistory/walletHistory/state/wallet_state.dart';
import 'package:salonspabarber/ui/profile/state/prof_state.dart';
import 'package:salonspabarber/ui/splash.dart';
import 'package:salonspabarber/utilities/colors.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: salonPurple));
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<LoginState>(create: (_) => LoginState()),
        ChangeNotifierProvider<MainState>(create: (_) => MainState()),
        ChangeNotifierProvider<EarningState>(create: (_) => EarningState()),
        ChangeNotifierProvider<WalletState>(create: (_) => WalletState()),
        ChangeNotifierProvider<FundingWalletState>(create: (_) => FundingWalletState()),
        ChangeNotifierProvider<WithdrawState>(create: (_) => WithdrawState()),
        ChangeNotifierProvider<ProfSettingsState>(create: (_) => ProfSettingsState()),


      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenPage(),
      ),
    );
  }
}