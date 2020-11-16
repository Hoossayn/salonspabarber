import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/helper/custom_widget.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/helper/validation.dart';
import 'package:salonspabarber/ui/main/main_page.dart';
import 'package:salonspabarber/ui/main/model/notification_model.dart';
import 'package:salonspabarber/utilities/image_loader.dart';
import 'package:salonspabarber/utilities/map_utils.dart';


const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);


class AcceptRequest extends StatefulWidget {

  NotificationData notificationData;
  AcceptRequest(this.notificationData);

  @override
  _AcceptRequestState createState() => _AcceptRequestState();
}

class _AcceptRequestState extends State<AcceptRequest> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Logger _logger = Logger();
  GoogleMapController mapController;
  double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  double _destLatitude = 6.849660, _destLongitude = 3.648190;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = StringRes.MAP_API_KEY;
  DatabaseReference _database = FirebaseDatabase.instance.reference();
  NotificationData _notificationModel;
  Timer _timer;
  int _start = 00;
  int _minute = 25;
  final _preManager = SharedPreferencesHelper();
  String clientId;
  String requestKey;


  @override
  void initState() {

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
    dosomething();
    super.initState();
  }

  dosomething () async{
    var varclientId = await _preManager.getClientId();
    var varrequestKey = await _preManager.getRequestKey();

    setState(() {
      clientId = varclientId;
      requestKey = varrequestKey;
      _listenToChanges();

      print('object client id ${clientId}, ${requestKey}');
    });
  }

  Future<void> _confirmArrival() {
    return _database
        .reference()
        .child("Requests")
        .child(clientId)
        .child(requestKey)
        .update(<String, dynamic>{
      'requestStatus': "BARBER_ARRIVED",
    }).whenComplete(() {
    }).catchError((onError) => _logger.e('Error: $onError'));
  }

  Future<void> _startService() {
    return _database
        .reference()
        .child("Requests")
        .child(clientId)
        .child(requestKey)
        .update(<String, dynamic>{
      'requestStatus': "SERVICE_ONGOING",
    }).whenComplete(() {
    }).catchError((onError) => _logger.e('Error: $onError'));
  }

  Future<void> _serviceCompleted() {
    return _database
        .reference()
        .child("Requests")
        .child(clientId)
        .child(requestKey)
        .update(<String, dynamic>{
      'requestStatus': "AWAITING_COMPLETION",
    }).whenComplete(() {
    }).catchError((onError) => _logger.e('Error: $onError'));
  }

  void _listenToChanges() {

    print('clientId => ${clientId}, ${requestKey}');
    _database
        .child('Requests')
        .child(clientId)
        .child(requestKey)
        .onValue
        .listen((event) {
      _notificationModel = widget.notificationData.fromMap(event.snapshot.value);
      if (_notificationModel.requestStatus == 'ACCEPTED') {
       // _timer2.cancel();
        return;
      }

      if (_notificationModel.requestStatus == 'SERVICE_ONGOING') {
        _startTimer(24);
        return;
      }

      if (_notificationModel.requestStatus == 'AWAITING_COMPLETION') {
        _timer.cancel();
        return;
      }

      if(_notificationModel.requestStatus == 'COMPLETED'){

        Navigator.of(context).popUntil((route) => route.isFirst);

      }

      if(_notificationModel.requestStatus == 'CANCELLED'){

        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MainPage()));

      }
    });
  }

  void _startTimer(int timeLimit) async {
    setState(() {
      _minute = timeLimit;
    });
    const oneSec = const Duration(seconds: 1);
    setState(() => _start = 60);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (mounted) {
        setState(
              () {
            if (_start == 0) {
              if (_minute <= 25 && _minute > 0) {
                _minute = _minute - 1;
                _startTimer(_minute);
              } else {
                /// do something here
              }
              timer.cancel();
            } else {
              _start = _start - 1;
            }
          },
        );
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(_originLatitude, _originLongitude), zoom: 15),
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
              ),
              
              StreamBuilder(
                  stream: _database
                  .child('Requests')
                  .child(clientId)
                  .child(requestKey)
                  .onValue,
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Container();
                    }

                    print('notification stattus => ${widget.notificationData.requestStatus}');
                    if(snapshot.hasData && !snapshot.hasError &&
                    snapshot.data.snapshot.value != null){
                      _notificationModel = widget.notificationData.fromMap(snapshot.data.snapshot.value);

                      if(_notificationModel.requestStatus == "ACCEPTED"){
                        return _acceptedRequestWidget(_notificationModel,
                            showArrivalButton: false);
                      }

                      if(_notificationModel.requestStatus == "BARBER_ARRIVED"){
                        return _barberArrivedWidget(_notificationModel, showStartService: false);
                      }

                      if(_notificationModel.requestStatus == "SERVICE_ONGOING"){
                        //_startTimer(24);
                        return _serviceCompletedWidget(_notificationModel);
                      }

                      if(_notificationModel.requestStatus == "AWAITING_COMPLETION"){
                        return _serviceCompletedWidget(_notificationModel);

                        //_timer.cancel();
                        //customSnackBar(_scaffoldKey, "Waiting for client to confirm");
                      }

                      if(_notificationModel.requestStatus == "CANCELLED"){
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => MainPage()));
                      }
                    }
                    return Container();
              })
            ],
          )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        StringRes.MAP_API_KEY,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  Widget _acceptedRequestWidget(NotificationData _confirm,
      {bool serviceOnGoing = false, bool showArrivalButton = false}) {
    print("My arrival status is $showArrivalButton");

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.7,
        margin: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: Color(0xffECE7F5),
          borderRadius: BorderRadius.only(),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 15, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleImage(
                          path: _confirm != null &&
                              _confirm.barberImageUrl != null &&
                              _confirm.barberImageUrl.isNotEmpty
                              ? _confirm.barberImageUrl
                              : StringRes.ASSET_DEFAULT_AVATAR,
                          width: 60.0,
                          height: 60.0,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _confirm.barberName,
                          style: TextStyle(fontSize: 16, color: Colors.black26),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Awaiting Time',
                      style: TextStyle(fontSize: 14, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '$_minute : $_start',
                      style: TextStyle(fontSize: 18, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'this time starts immediately you confirm Arrival',
                      style: TextStyle(fontSize: 14, color: Colors.black26),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  ImageLoader(
                    path: StringRes.CALL_ICON,
                    width: 40,
                    height: 40,
                   /* onTap: () async => await canLaunch(
                        'tel:${_confirm.barberNumber}')
                        ? await launch('tel:${_confirm.barberNumber}')
                        : print('Could not launch ${_confirm.barberNumber}'),*/
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('Call'),
                  SizedBox(
                    height: 16,
                  ),
                  ImageLoader(
                    path: StringRes.ERROR_ICON,
                    width: 40,
                    height: 40,
                    onTap: () => _showCancelDialog(),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('Cancel'),
                  SizedBox(
                    height: 16,
                  ),
                  Column(
                    children: [
                       InkWell(
                         onTap: () {
                           print('ontap clicked ');
                           _confirmArrival();
                         } ,
                       child: ImageLoader(
                           path: StringRes.ACCEPT_ICON,
                           width: 40.0,
                           height: 40.0,
                      ),
                       ),
                      SizedBox(
                        height: 3,
                      ),
                      Text('Confirm Arrival '),
                    ],
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: showArrivalButton,
                    child: ImageLoader(
                      path: StringRes.ACCEPT_ICON,
                      width: 40,
                      height: 40,
                     // onTap: () => _showArrivalDialog(),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Visibility(visible: showArrivalButton, child: Text('Arrival'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _barberArrivedWidget(NotificationData _confirm,
      {bool serviceOnGoing = true, bool showStartService = true}) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.7,
        margin: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: Color(0xffECE7F5),
          borderRadius: BorderRadius.only(),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 15, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleImage(
                          path: _confirm != null &&
                              _confirm.barberImageUrl != null &&
                              _confirm.barberImageUrl.isNotEmpty
                              ? _confirm.barberImageUrl
                              : StringRes.ASSET_DEFAULT_AVATAR,
                          width: 60.0,
                          height: 60.0,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _confirm.barberName,
                          style: TextStyle(fontSize: 16, color: Colors.black26),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Awaiting Time',
                      style: TextStyle(fontSize: 14, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '$_minute : $_start',
                      style: TextStyle(fontSize: 18, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'this time starts immediately you confirm Arrival',
                      style: TextStyle(fontSize: 14, color: Colors.black26),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  ImageLoader(
                    path: StringRes.CALL_ICON,
                    width: 40,
                    height: 40,
                    /* onTap: () async => await canLaunch(
                        'tel:${_confirm.barberNumber}')
                        ? await launch('tel:${_confirm.barberNumber}')
                        : print('Could not launch ${_confirm.barberNumber}'),*/
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('Call'),
                  SizedBox(
                    height: 16,
                  ),
                  ImageLoader(
                    path: StringRes.ERROR_ICON,
                    width: 40,
                    height: 40,
                    //onTap: () => _cancelRequestToServer(),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('Cancel'),
                  SizedBox(
                    height: 16,
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () => _startService(),

                      child: ImageLoader(
                          path: StringRes.ACCEPT_ICON,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text('Start Service'),
                    ],
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: showStartService,
                    child: ImageLoader(
                      path: StringRes.ASSET_DEFAULT_USER,
                      width: 40,
                      height: 40,
                      // onTap: () => _showArrivalDialog(),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Visibility(visible: showStartService, child: Text('Arrival'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceCompletedWidget(NotificationData _confirm,
      {bool serviceOnGoing = false, }) {

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.7,
        margin: EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: Color(0xffECE7F5),
          borderRadius: BorderRadius.only(),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 15, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleImage(
                          path: _confirm != null &&
                              _confirm.barberImageUrl != null &&
                              _confirm.barberImageUrl.isNotEmpty
                              ? _confirm.barberImageUrl
                              : StringRes.ASSET_DEFAULT_AVATAR,
                          width: 60.0,
                          height: 60.0,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          _confirm.barberName,
                          style: TextStyle(fontSize: 16, color: Colors.black26),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Awaiting Time',
                      style: TextStyle(fontSize: 14, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '$_minute : $_start',
                      style: TextStyle(fontSize: 18, color: Colors.black26),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'this time starts immediately you confirm Arrival',
                      style: TextStyle(fontSize: 14, color: Colors.black26),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Column(
                    children: [
                      InkWell(
                        onTap: () => _serviceCompleted(),
                        child: ImageLoader(
                          path: StringRes.ACCEPT_ICON,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text('Service Completed'),
                    ],
                  ),

                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// show arrival dialog
  void _showCancelDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        child: Platform.isAndroid
            ? AlertDialog(
          title: Text("Cancel Request"),
          content: Text("Cancelling request after accepting them attract charges!"),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                "NO",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("YES"),
              onPressed: () async {
                Navigator.of(context).pop();
                var _map = Map<String, dynamic>();
                //_map['hasArrived'] = true;
                _map['requestStatus'] = 'CANCELLED';
                await _database
                    .reference()
                    .child('Requests')
                    .child(clientId)
                    .child(requestKey)
                    .update(_map)
                    .whenComplete(() {
//                        _startTimer(24);
                });
              },
            ),
          ],
        )
            : CupertinoAlertDialog(
          title: Text("Cancel Request"),
          content: Text("Cancelling request after accepting them attract charges!"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                textStyle: TextStyle(color: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("NO")),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  var _map = Map<String, dynamic>();
                 // _map['hasArrived'] = true;
                  _map['requestStatus'] = 'CANCELLED';
                  await _database
                      .reference()
                      .child('Requests')
                      .child(clientId)
                      .child(requestKey)
                      .update(_map)
                      .whenComplete(() {
//                          _startTimer(24);
                  });
                },
                child: Text("YES")),
          ],
        ));
  }
}
