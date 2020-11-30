import 'dart:io';
import 'dart:math';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:salonspabarber/entity/User.dart';
import 'package:salonspabarber/helper/custom_widget.dart';
import 'package:salonspabarber/helper/pref_manager.dart';
import 'package:salonspabarber/ui/profile/state/prof_state.dart';
import 'package:salonspabarber/utilities/colors.dart';
import 'package:salonspabarber/utilities/custom_loader_indicator.dart';

class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProfSettingsState _state;
  String _imageUrl;
  final _prefManager = SharedPreferencesHelper();
  UserEntity _user;
  String _userAddress;
  CustomLoader _loader;
  final Logger _logger = Logger();
  File _image;
  final storage = FlutterSecureStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loader = CustomLoader(context);
    _state = Provider.of<ProfSettingsState>(context, listen: false);
    getImageUrlInStorage();
    _usersDetails();

  }

  void _usersDetails() {
    _prefManager.getUsersDetails().then((value) {
      setState(() => _user = value);
    });

    _prefManager.getAddress().then((value) {
      setState(() {
        _userAddress = value;

      });
    });
  }


  void updateProfileImageUrlInStorage(String imageUrl, String name, String phone) {
    final storage = FlutterSecureStorage();
    storage.write(key: "profileImageUrl", value: imageUrl);
    storage.write(key: "updatedName", value: name);
    storage.write(key: "updatedPhone", value: phone);
  }

  getImageUrlInStorage() async {
    var result = await storage.read(key: "profileImageUrl");
    var updatedName = await storage.read(key: "updatedName");
    setState(() {
      _imageUrl = result;
      _user.name = updatedName;

      _nameController.text = _user.name;
      _emailController.text = _user.email;
      _phoneController.text = _user.phone;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: salonPurple,
        title: Text('Profile'),
        leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context,true);}),

        iconTheme: new IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:15.0, right: 15.0),
        child: ListView(
          children: [
            SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  InkWell(
                    onTap:(){
                      _imgFromGallery();
                    },
                    child: CircleAvatar(
                        //backgroundImage: AssetImage('assets/default_user.jpg'),
                        radius: 50.0,
                      backgroundImage: _imageUrl  != null ? NetworkImage(_imageUrl) : AssetImage('assets/default_user.jpg'),

                    ),
                  ),
                  Positioned(
                    top: 80.0,
                    left: 50.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: Icon(
                          Icons.camera_alt
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: 'Email'
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                  labelText: 'Phone Number'
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50.0,
              child: Container(
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: salonPurple,
                  elevation: 7.0,
                  child: InkWell(
                    onTap: ()  {
                       _validateAndMakeRequest();
                    },
                    child: Center(
                      child: Text(
                        'Update',
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
            SizedBox(height: 60),
            Container(
              height: 50.0,
              child: Container(
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red,
                  elevation: 7.0,
                  child: InkWell(
                    onTap: ()  {
                      _showLogoutDialog();
                    },
                    child: Center(
                      child: Text(
                        'Logout',
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
    );
  }

  /// show arrival dialog
  void _showLogoutDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        child: Platform.isAndroid
            ? AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
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
                storage.deleteAll();
                _prefManager.logout(context);
                _firebaseMessaging.unsubscribeFromTopic("/topics/Enter_your_topic_name");

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
                  _firebaseMessaging.unsubscribeFromTopic("/topics/Enter_your_topic_name");
                  storage.deleteAll();
                  _prefManager.logout(context);
                },
                child: Text("YES")),
          ],
        ));
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;

      if(_image != null){
        _uploadImage(_image);
      }
    });
  }

  _uploadImage(File file) async {
    _loader.showLoader();
    final String fileName = Random().nextInt(10000).toString() + '.png';
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('BarbersProfile')
        .child(fileName);
    StorageUploadTask uploadTask = ref.putFile(file);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    setState(() {
      _imageUrl = downloadUrl.toString();
      print('image url : ${_imageUrl}');
    });
      _loader.hideLoader();
  }

  _validateAndMakeRequest() async {

    if (!await DataConnectionChecker().hasConnection) {
      _logger.d('No internet access!');
      return;
    }

    Map _body = Map<String, dynamic>();

    _body['id'] =  _user.id;
    _body['name'] =  _nameController.text;
    _body['phone'] =  _phoneController.text;
    _body['photo'] = _imageUrl.toString();


    _loader.showLoader();
    _state.updateProfile(path: 'updatebarber', body: _body).then((data) {

      _loader.hideLoader().then((value) {
        customSnackBar(_scaffoldKey, 'Profile picture Updated');
        setState(() {
          _user.name = data.user.name;
          _user.phone = data.user.phone;
          _user.imageUrl = data.user.photo.toString();
          _nameController.text = data.user.name.toString();
          _phoneController.text = data.user.phone.toString();

          updateProfileImageUrlInStorage(_imageUrl, _nameController.text.toString(), _phoneController.text.toString());

          //  Navigator.pop(context, _imageUrl.toString());

        });

      });
    }).catchError((err) {
      _loader.hideLoader();
      _logger.e('ErrorMessage: $err');
      customSnackBar(_scaffoldKey, err.toString());
    });
  }
}
