import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/helper/validation.dart';
import 'package:salonspabarber/ui/login/state/login_state.dart';
import 'package:salonspabarber/ui/main/main_page.dart';
import 'package:salonspabarber/utilities/colors.dart';
import 'package:salonspabarber/utilities/custom_loader_indicator.dart';
import 'package:salonspabarber/utilities/image_loader.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  CustomLoader _loader;
  final _preManager = SharedPreferencesHelper();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Logger _logger = Logger();
  LoginState _state;

  @override
  void initState() {
    _loader = CustomLoader(context);
    _state = Provider.of<LoginState>(context, listen: false);
    super.initState();
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  TextStyle style = TextStyle(
    color: Colors.black,
    fontFamily: 'Varela',
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage(StringRes.barbing)),
          color: salonPurple,

        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              SizedBox(height: 80),
              _emailField(),
              SizedBox(height: 30),
              _passwordField(),
              SizedBox(height: 25),
              Container(
                height: 50.0,
                child: Container(
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.deepPurple,
                    elevation: 7.0,
                    child: InkWell(
                      onTap: ()  {
                        _validateAndMakeRequest(context);

                      },
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Varela',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextFormField(
        key: Key("Phone Number"),
        keyboardType: TextInputType.text,
        style: style,
        controller: _emailController,
        cursorColor: Colors.white,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          labelText: "Phone Number",
          labelStyle: TextStyle(color: Colors.grey,fontFamily: 'Varela',
          ),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                  color: Colors.grey, width: 2.0, style: BorderStyle.solid)),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextFormField(
        key: Key("Password"),
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        style: style,

        controller: _passwordController,
        cursorColor: Colors.white,
        decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          labelText: "Password",
          labelStyle: TextStyle(color: Colors.grey,fontFamily: 'Varela',),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                  color: Colors.grey, width: 2.0, style: BorderStyle.solid)),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        ),
      ),
    );
  }

  _validateAndMakeRequest(BuildContext context) async {
    if (!validateSignInCredentials(
        scaffoldKey: _scaffoldKey,
        email: _emailController.text,
        password: _passwordController.text,)) {
      return;
    }

    if (!await DataConnectionChecker().hasConnection) {
      _logger.d('No internet access!');
      return;
    }

    Map _body = Map<String, dynamic>();
    _body['phone'] = _emailController.text;
    _body['password'] = _passwordController.text;

    _loader.showLoader();
    _state.loginUser(url: 'barberlogin', body: _body).then((register) {
      _loader.hideLoader().then((value){
        _logger.d('body: ${register.user.isVerifiedAsBarber}');

//        _preManager.setEmail(register.email);

       /* Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => OtpVerify()));*/

                Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => MainPage()));

      });

    }).catchError((err) {
      _loader.hideLoader();
      _logger.e('ErrorMessage: $err');
    });
  }
}
