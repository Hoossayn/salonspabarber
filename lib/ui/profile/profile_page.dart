import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Profile'),
        leading: IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context,);}),

        iconTheme: new IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:15.0, right: 15.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Center(
              child: Stack(
                children: [
                  InkWell(
                    onTap:(){
                     // chooseFile();
                    },
                    child: CircleAvatar(
                        backgroundImage: AssetImage('assets/default_user.jpg'),
                        radius: 50.0
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
              decoration: InputDecoration(
                labelText: 'Name'
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Email'
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
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
                  color: Colors.deepPurple,
                  elevation: 7.0,
                  child: InkWell(
                    onTap: ()  {
                      // _validateAndMakeRequest();
                      /*Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MainPage()));*/

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
                      // _validateAndMakeRequest();
                  /*    Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MainPage()));*/

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
}
