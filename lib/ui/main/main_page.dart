import 'dart:async';
import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rave_flutter/rave_flutter.dart';
import 'package:salonspabarber/entity/User.dart';
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/helper/custom_widget.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/helper/theme.dart';
import 'package:salonspabarber/helper/validation.dart';
import 'package:salonspabarber/ui/acceptRequest/accept_request.dart';
import 'package:salonspabarber/ui/bookings/bookings_page.dart';
import 'package:salonspabarber/ui/main/custom_dialog.dart';
import 'package:salonspabarber/ui/main/funding/model/funding.dart';
import 'package:salonspabarber/ui/main/model/notification_model.dart';
import 'package:salonspabarber/ui/main/state/main_state.dart';
import 'package:salonspabarber/ui/main/withdrawal/state/withdraw_state.dart';
import 'package:salonspabarber/ui/paymentHistory/paymentHistoryPage.dart';
import 'package:salonspabarber/ui/profile/profile_page.dart';
import 'package:salonspabarber/utilities/custom_loader_indicator.dart';
import 'package:salonspabarber/utilities/image_loader.dart';
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
  var walletBalance = '';
  var earningBalance = '';
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
  WithdrawState _withdrawState;
  TextEditingController _amountController = TextEditingController();
  NotificationData notificationModel;
  final _preManager = SharedPreferencesHelper();
  DatabaseReference _database = FirebaseDatabase.instance.reference();
  //AnimationController _controller;
  String clientId;
  String requestKey;




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
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _mainState = Provider.of<MainState>(context, listen:false);
    _fundingWalletState = Provider.of<FundingWalletState>(context, listen: false);
    _withdrawState = Provider.of<WithdrawState>(context, listen:false);

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
          print('received message $message');


          setState(() {
           // CustomDialogBox(context: context, title: message["data"]["clientName"], descriptions: message["data"]["clientName"], text: message["data"]["clientName"]);
            contentBox(context, message["data"]["clientName"],
                message["data"]["clientAddress"],
                message["data"]["paymentAmount"], message["data"]["paymentStatus"],
                message["data"]["noOfMen"], message["data"]["noOfWomen"], message["data"]["noOfChildren"]);

            clientId = message["data"]["clientId"];
            requestKey = message["data"]["requestKey"];

            _prefManager.setClientId(clientId);
            _prefManager.setRequestKey(requestKey);

            print('sharedPreference ${clientId}  ${requestKey}');

            notificationModel = NotificationData.checkBeforeSendingToServer(
              clientName: '${message["data"]["clientName"]}',
              clientAddress: '${message["data"]["clientAddress"]}',
              requestKey: '${message["data"]["requestStatus"]}',
              barberId: '${message["data"]["barberId"]}',
              barberImageUrl: '${message["data"]["barberImageUrl"]}',
              barberName: '${message["data"]["barberName"]}',
              barberNumber: '${message["data"]["barberNumber"]}',
              requestStatus: '${message["data"]["requestStatus"]}',

            );

          });
        }, onResume: (Map<String, dynamic> message) async {
      contentBox(context, message["data"]["clientName"],
          message["data"]["clientAddress"],
          message["data"]["paymentAmount"], message["data"]["paymentStatus"],
          message["data"]["noOfMen"], message["data"]["noOfWomen"], message["data"]["noOfChildren"]);


         // CustomDialogBox(title: message["data"]["clientName"], descriptions: message["data"]["clientName"], text: message["data"]["clientName"]);
      print('on resume $message');
      setState(() {
        contentBox(context, message["data"]["clientName"],
            message["data"]["clientAddress"],
            message["data"]["paymentAmount"], message["data"]["paymentStatus"],
            message["data"]["noOfMen"], message["data"]["noOfWomen"], message["data"]["noOfChildren"]);

        clientId = message["data"]["clientId"];
        requestKey = message["data"]["requestKey"];

        _prefManager.setClientId(clientId);
        _prefManager.setRequestKey(requestKey);

        print('sharedPreference ${clientId}  ${requestKey}');

        notificationModel = NotificationData.checkBeforeSendingToServer(
          clientName: '${message["data"]["clientName"]}',
          clientAddress: '${message["data"]["clientAddress"]}',
          requestKey: '${message["data"]["requestStatus"]}',
          barberId: '${message["data"]["barberId"]}',
          barberImageUrl: '${message["data"]["barberImageUrl"]}',
          barberName: '${message["data"]["barberName"]}',
          barberNumber: '${message["data"]["barberNumber"]}',
          requestStatus: '${message["data"]["requestStatus"]}',

        );

      });
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() {
        clientId = message["data"]["clientId"];
        requestKey = message["data"]["requestKey"];

        _prefManager.setClientId(clientId);
        _prefManager.setRequestKey(requestKey);

        print('sharedPreference ${clientId}  ${requestKey}');

        notificationModel = NotificationData.checkBeforeSendingToServer(
          clientName: '${message["data"]["clientName"]}',
          clientAddress: '${message["data"]["clientAddress"]}',
          requestKey: '${message["data"]["requestStatus"]}',
          barberId: '${message["data"]["barberId"]}',
          barberImageUrl: '${message["data"]["barberImageUrl"]}',
          barberName: '${message["data"]["barberName"]}',
          barberNumber: '${message["data"]["barberNumber"]}',
          requestStatus: '${message["data"]["requestStatus"]}',

        );

      });
    },
      onBackgroundMessage: myBackgroundMessageHandler);
  }


  contentBox(BuildContext context, String barberName, String address, String paymentMethod, String paymentStatus, String noOfMen, String noOfWomen, String noOfChildren){
    return showDialog(

      barrierDismissible: false,
      context: context,
      builder: (context){
        return Dialog(
          child: Scaffold(
            body: Container(
             // height:  400,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 32,
                      ),
                      Flexible(
                        child: ImageLoader(
                          path: StringRes.ASSET_DEFAULT_AVATAR,
                          width: 100.0,
                          height: 100.0,
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title: Text('Client Name',
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  color: AppColor.darkgrey)),
                          subtitle: Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: AppColor.buttonDarkWhite,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                barberName,
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    color: AppColor.textColorPurple),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    title: Text('Address',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: AppColor.darkgrey)),
                    isThreeLine: true,
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: AppColor.buttonDarkWhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: AppColor.textColorPurple),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  ListTile(
                    title: Text('Payment',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: AppColor.darkgrey)),
                    isThreeLine: true,
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: AppColor.buttonDarkWhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Cash',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      color: AppColor.textColorPurple),
                                ),
                                Text(paymentMethod
                                  /*bookings != null &&
                                    bookings.serviceAmount.toString().isNotEmpty
                                    ? '${currency(context, _convertStringCurrencyToInt(bookings.serviceAmount.toString()))}'
                                    : '${currency(context, 0)}'*/,
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      color: AppColor.textColorPurple),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 23,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Payment Status',
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      color: AppColor.textColorPurple),
                                ),
                                Text(
                                  paymentStatus
                                  /*bookings != null && bookings.paymentStatus.isNotEmpty
                                    ? bookings.paymentStatus
                                    : ''*/,
                                  style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      color: AppColor.textColorPurple),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  ListTile(
                    title: Text('Preferred Tools',
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            color: AppColor.darkgrey)),
                    isThreeLine: true,
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: AppColor.buttonDarkWhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '',
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: AppColor.textColorPurple),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                        color: AppColor.buttonDarkWhite,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Men: $noOfMen'
                            /* bookings != null &&
                              bookings.noOfMen.toString().isNotEmpty &&
                              !bookings.noOfMen.toString().contains('null')
                              ? 'Men: ${bookings.noOfMen}'
                              : 'Men: '*/,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                color: AppColor.textColorPurple),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Women: $noOfWomen'
                            /*  bookings != null &&
                              bookings.noOfWomen.toString().isNotEmpty &&
                              !bookings.noOfWomen.toString().contains('null')
                              ? 'Women: ${bookings.noOfWomen}'
                              : 'Women: '*/,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                color: AppColor.textColorPurple),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Children: $noOfChildren'
                            /*bookings != null &&
                              bookings.noOfChildrenInt.toString().isNotEmpty &&
                              !bookings.noOfChildrenInt
                                  .toString()
                                  .contains('null')
                              ? 'Children: ${bookings.noOfChildrenInt}'
                              : 'Children: '*/,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                color: AppColor.textColorPurple),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap:(){
                            _acceptRequest();
                          },
                          child: Container(
                            height: 40.0,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
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
                                      child: Text('Accept',
                                        style: TextStyle(
                                          color: Colors.green,
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
                          onTap: (){Navigator.pop(context);},
                          child: Container(
                            height: 40.0,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
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
                                      child: Text('Cancel',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.normal,
                                        ),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],),
                  )
                ],
              ),
            ),
          ),
        );
      },
     // child: ,
    );
  }


  Future<void> _acceptRequest() {

    _database.reference().child("Requests").child(clientId).child(requestKey).child('requestStatus').once().then((DataSnapshot snapshot) {
      print('request value => ${snapshot.value.toString()}');
      if(snapshot.value == "REQUESTING"){
        print('request value => ${snapshot.value.toString()}');
        return _database
            .reference()
            .child("Requests")
            .child(clientId)
            .child(requestKey)
            .update(<String, dynamic>{
          'barberId': _user.id,
          'barberImageUrl': _user.imageUrl,
          'barberName': _user.name,
          'barberNumber': _user.phone,
          'requestStatus': "ACCEPTED",
        }).whenComplete(() {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AcceptRequest(notificationModel)));
          //_controller.stop();
        }).catchError((onError) => _logger.e('Error: $onError'));
      }else{
        print('reaches snackbar');
        Fluttertoast.showToast(
            msg: "Oops, Request have been accepted by someone else",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pop(context);
       // customSnackBar(scaffoldKey, 'Oops, Request have been accepted by someone else');
      }
    }).catchError((onError) => customSnackBar(scaffoldKey, 'Oops, Request have been accepted by someone else'));

  }

  void _getBalance(){

    Map _walletBody = Map<String, dynamic>();
    _walletBody['barberid'] = _user.id;

    Map _earningBody = Map<String, dynamic>();
    _earningBody['id'] = _user.id;

    _loader.showLoader();
    _mainState.getWalletBalance(url: 'getbarberfirstbal', body: _walletBody).then((walletBal){

      setState(() => walletBalance = walletBal.balance == null? '0': walletBal.balance);
      print('balance ${walletBal.balance}');
      //_loader.hideLoader();
    });

    _mainState.getEarningBalance(url: 'barberbal', body: _earningBody).then((earningBal) {

      setState(() => earningBalance = earningBal.balance == null ? '0': earningBal.balance);
      _loader.hideLoader();

    })   .catchError((error) {
      _logger.e('Error: $error');
      _loader.hideLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                                      Text('',
                                        //currency(context, int.parse(walletBalance.toString())),
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
                                      Text('',
                                          //currency(context, int.parse(earningBalance.toString())),
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
                                                    _showDialog();
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

   _withdraw(BuildContext context) async{

     if (!await DataConnectionChecker().hasConnection) {
       _logger.d('No internet access!');
       return;
     }

    var _map = Map<String, dynamic>();
    _map['id'] = _user.id.toString();
    _map['amount'] = _amountController.text.toString();

    _loader.showLoader();
    _withdrawState.withdraw(url: null, body: _map).then((value) {
      _loader.hideLoader();

    }).catchError((err) {
      _loader.hideLoader();
      _logger.d('Error: $err');
    });

  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Enter amount you want to withdraw"),
          content: new TextFormField(
            decoration: InputDecoration(
                labelText: 'Enter Amount'
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Withdraw",style: TextStyle(color: Colors.green),),
              onPressed: () {
                _withdraw(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async{
    print('on background $message');
    return Future<void>.value();

  }
}
