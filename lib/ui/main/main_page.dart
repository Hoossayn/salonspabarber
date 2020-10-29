import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rave_flutter/rave_flutter.dart';
import 'package:salonspabarber/entity/User.dart';
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/helper/validation.dart';
import 'package:salonspabarber/ui/bookings/bookings_page.dart';
import 'package:salonspabarber/ui/main/funding/model/funding.dart';
import 'package:salonspabarber/ui/main/state/main_state.dart';
import 'package:salonspabarber/ui/paymentHistory/paymentHistoryPage.dart';
import 'package:salonspabarber/ui/profile/profile_page.dart';
import 'package:salonspabarber/utilities/custom_loader_indicator.dart';

import 'funding/state/funding_state.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _prefManager = SharedPreferencesHelper();
  UserEntity _user;
  CustomLoader _loader;
  final Logger _logger = Logger();
  MainState _mainState;
  var walletBalance ;
  var earningBalance;
  double _latitude = 0.0, _longitude = 0.0;
  bool _isMapLoading = true;
  Position currentLocation;
  LatLng currentPostion ;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String publicKey = "FLWPUBK_TEST-ae4457f1ce3ba0593121ece7eaf9aac2-X";
  String encryptionKey = "FLWSECK_TESTe95e6d817dfc";
  String txRef = 'rave_flutter-${DateTime.now().toString()}';
  String orderRef = 'rave_flutter-${DateTime.now().toString()}';
  FundingWalletState _fundingWalletState;


  static const LatLng _center = const LatLng(45.521563, -122.677433);
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setState(() {
      _isMapLoading = false;
    });
  }

  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('/topics/Enter_your_topic_name');
    _firebaseMessaging.getToken().then((token) => print(token));
  }


  @override
  void initState() {
    // TODO: implement initState
    _mainState = Provider.of<MainState>(context, listen:false);
    _fundingWalletState = Provider.of<FundingWalletState>(context, listen: false);
    _loader = CustomLoader(context);
    _getUserDetail();
    _getUserLocation();
    _registerOnFirebase();
    getMessage();
    super.initState();

  }

  void _getUserDetail(){
    _prefManager.getUsersDetails().then((value) {
      setState(() {
        _user = value;
        _getBalance();
      });
      print('Homename: ${_user.id}');
    });
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('received message');
         // setState(() => _message = message["notification"]["body"]);
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
     // setState(() => _message = message["notification"]["body"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
     // setState(() => _message = message["notification"]["body"]);
    });
  }

  void _getBalance(){

    Map _walletBody = Map<String, dynamic>();
    _walletBody['barberid'] = _user.id;

    Map _earningBody = Map<String, dynamic>();
    _earningBody['id'] = _user.id;

    _loader.showLoader();
    _mainState.getWalletBalance(url: 'getbarberfirstbal', body: _walletBody).then((walletBal){

      setState(() => walletBalance = walletBal.balance);
      print('balance ${walletBal.balance}');
      //_loader.hideLoader();
    });

    _mainState.getEarningBalance(url: 'barberbal', body: _earningBody).then((earningBal) {

      setState(() => earningBalance = earningBal.balance);
      _loader.hideLoader();

    })   .catchError((error) {
      _logger.e('Error: $error');
      _loader.hideLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Expanded(
                flex: 3,
                  child: Container(
                color: Colors.deepPurple,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => ProfilePage()));
                                },
                                child: CircleAvatar(
                                    backgroundImage:  AssetImage('assets/default_user.jpg'),
                                    radius: 20.0
                                ),
                              ),
                          ],
                          ),
                        ),
                        Text(
                          'Hi, hossayn',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Varela',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left:15.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                color: Colors.white,
                                height:105,
                                width: 180,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Text(
                                        'Wallet Balance',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Varela',
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        currency(context, int.parse(walletBalance.toString())),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Varela',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 30.0,
                                            child: Container(
                                              child: Material(
                                                borderRadius: BorderRadius.circular(5.0),
                                                color: Colors.deepPurple,
                                                elevation: 7.0,
                                                child: InkWell(
                                                  onTap: ()  {
                                                    // _validateAndMakeRequest();
                                                    _fundWallet(context);
                                                    /*Navigator.of(context)
                                                        .push(MaterialPageRoute(builder: (context) => MainPage()));*/

                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      'Fund Wallet',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Varela',
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                color: Colors.white,
                                height:105,
                                width: 180,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Text(
                                        'Weekly Balance',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Varela',
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                          currency(context, int.parse(earningBalance.toString())),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Varela',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 30.0,
                                            child: Container(
                                              child: Material(
                                                borderRadius: BorderRadius.circular(5.0),
                                                color: Colors.deepPurple,
                                                elevation: 7.0,
                                                child: InkWell(
                                                  onTap: ()  {
                                                    // _validateAndMakeRequest();
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(builder: (context) => MainPage()));

                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      'Withdraw',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Varela',
                                                          fontWeight: FontWeight.normal
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left:15.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => paymentHistoryPage()));
                                },
                                child: Container(
                                  height: 40.0,
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                        ),
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text('View History',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => MyBookingsPage()));
                                },
                                child: Container(
                                  height: 40.0,
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                        ),
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text('View Bookings',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
              ),
              ),
              Expanded(
                flex: 4,
                  child: Container(
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: currentPostion,
                          zoom: 11.0,

                        )),
                  ))
            ],
          )
        ),
      ),
    );
  }

  _fundWallet(BuildContext context) async {
    final _user = await _prefManager.getUsersDetails();
    var initializer = RavePayInitializer(
      amount: 0.0,
      publicKey: publicKey,
      companyName: Text(
        'Saloon & Spa',
        style: TextStyle(color: Colors.deepPurple),
      ),
      //companyLogo: CircleImage(path: StringRes.ASSET_DEFAULT_AVATAR),
      encryptionKey: encryptionKey,
    )
      ..country = "NG"
      ..currency = "NGN"
      ..email = _user.name
      ..fName = _user.name
      ..txRef = txRef
      ..orderRef = orderRef
      ..acceptAccountPayments = true
      ..acceptCardPayments = true
      ..displayEmail = true
      ..displayAmount = true
      ..displayFee = true;

    await RavePayManager()
        .prompt(context: context, initializer: initializer)
        .then((value) {
      //_sendToBackEnd(value);
    });
  }

  void _sendToBackEnd(RaveResult value) {
    FundedWallet _f =
    FundedWallet.fromJson(json.decode(json.encode(value.rawResponse)));

    var _map = Map<String, dynamic>();
    _map['userid'] = _user.id.toString();
    _map['amount'] = _f.data.amount.toString();
    _map['reference'] = _f.data.raveRef;

    _loader.showLoader();
    _fundingWalletState
        .getWalletFunding(path: 'storepay', map: _map)
        .then((value) {
      _loader.hideLoader();
      _logger.d('Success:');
      //_usersDetails();
    }).catchError((err) {
      _loader.hideLoader();
      _logger.d('Error: $err');
    });
  }
}
