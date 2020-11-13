import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salonspabarber/helper/base_url.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/helper/validation.dart';
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
    super.initState();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
    dosomething();

  }

  dosomething () async{
    var varclientId = await _preManager.getClientId();
    var varrequestKey = await _preManager.getRequestKey();

    setState(() {
      clientId = varclientId;
      requestKey = varrequestKey;

      print('object client id ${clientId}, ${requestKey}');
    });



  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      print('notificationModel ${_notificationModel}');
                      if(_notificationModel.requestStatus == "ACCEPTED"){
                        return _acceptedRequestWidget(_notificationModel,
                            showArrivalButton: false);
                      };
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
                    //onTap: () => _cancelRequestToServer(),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('Cancel'),
                  Column(
                    children: [
                      ImageLoader(
                        path: StringRes.ERROR_ICON,
                        width: 40,
                        height: 40,
                        //onTap: () => _cancelRequestToServer(),
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
}
