import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/helper/validation.dart';
import 'package:salonspabarber/ui/login/login_page.dart';
import 'package:salonspabarber/ui/main/main_page.dart';
import 'package:salonspabarber/utilities/image_loader.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();

  @override
  void initState() {
    _delay();
    super.initState();
  }

  _delay() async {
    Future.delayed(const Duration(seconds: 1), () async {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));

      await _preferencesHelper.getUsersDetails().then((value) {
        if (value != null) {
          print("MyValue is $value");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
        } else {
          print("MyValue is No value oooo");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage()))
              .catchError((e) =>
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage())));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: CircleImage(
          path: StringRes.ASSET_DEFAULT_LOGO,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
