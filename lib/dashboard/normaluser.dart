import 'package:cab/components/transactionScreen.dart';
import 'package:cab/welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../components/rounded_button.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cab/components/splashscreens/splashlogin.dart';

class NormalUser extends StatefulWidget {
  NormalUser({@required this.userEmail, @required this.user});
  final String userEmail;
  final FirebaseUser user;
  @override
  _NormalUserState createState() => _NormalUserState();
}

class _NormalUserState extends State<NormalUser> {
  String _currentLocation = "";
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition = new Position();
  String _currentAddress;
  bool _modal = false;
  String _whereLocation = "";
  String latitude;
  String longitude;

  Geoflutterfire geo = new Geoflutterfire();
  Firestore _firestore = Firestore.instance;

  _getCurrentLocation() {

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      Alert(context: context,
          title: "Server Error",
          desc: "Please try again later.").show();
    });
  }

  Future _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
        _currentLocation = _currentAddress;
        _modal = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> onConfirm(
      double latitude, double longitude, String _whereLocation) async {
    try {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreenLogin()));
      GeoFirePoint myLocation =
          geo.point(latitude: latitude, longitude: longitude);
      String nome = "";
      String no = "";
      /*
      await _firestore.collection('UserInfo').document(widget.userEmail).get().then((value){
        nome = value.data['Name'];
        no = value.data['Phone Number'];
      } );

       */
      DocumentReference xyz =
          await _firestore.collection('UserLocationRequests').add({
        'name': widget.userEmail
            .substring(0, widget.userEmail.indexOf("@"))
              .toUpperCase(),
        //'number' : no,
        'From': myLocation.data,
        'To': _whereLocation,
        'fromAddress': _currentAddress,
        'status': "Pending"
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransactionScreen(
                    userID: xyz.documentID,
                  )));
    } catch (e) {
      Alert(
              context: context,
              title: "Server Error",
              desc: "Please try again later.")
          .show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: AppBar(
            leading: null,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    //Implement logout functionality

                    Navigator.push((context),
                        MaterialPageRoute(builder: (context) => WelcomeScreen()));
                  }),
            ],
            title: Text("Hello " +
                widget.userEmail
                    .substring(0, widget.userEmail.indexOf("@"))
                    .toUpperCase()),
            backgroundColor: Colors.amber[800],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0))),
          ),
        ),
        body:
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/tracks.jpg'),fit: BoxFit.cover)
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GetLocationButton(
                      buttonTitle: "Get Current Location",
                      color: Colors.blueGrey,
                      onPressed: () {
                        setState(() {
                          _modal = true;
                          _getCurrentLocation();
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      color:  Colors.white,
                      shadowColor: Colors.orangeAccent,elevation: 2.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  'From Location:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,fontFamily: 'DMSans'),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child:ModalProgressHUD(
                                  inAsyncCall: _modal,
                                  child: Center(
                                      child: Text(
                                        _currentLocation,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18,fontFamily: 'DMSans'),
                                      )),
                                ),
                              ),
                            ), //Gender
                          ],
                          ),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    TextField(
                      //Where to TextBar
                      onChanged: (value) {
                        setState(() {
                          _whereLocation = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,color: Colors.orangeAccent,),
                          hintText: 'Where To?',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          focusedBorder: OutlineInputBorder
                            (borderSide: BorderSide(color: Colors.orangeAccent,width: 1.5),
                              borderRadius: BorderRadius.circular(10.0)),

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey,width: 1.5),
                            borderRadius: BorderRadius.circular(10.0)
                          )),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),

                    Card(
                      color:  Colors.white,
                      shadowColor: Colors.orangeAccent,elevation: 2.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                  'To Location:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,fontFamily: 'DMSans'),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                  child: Center(
                                      child: Text(
                                        _whereLocation,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18,fontFamily: 'DMSans'),
                                      )),

                              ),
                            ), //Gender
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 40,
                    ),

                    RoundedButton(
                        buttonTitle: 'Confirm',
                        color: Colors.brown[400],
                        onPressed: () async {
                          setState(() {
                            onConfirm(_currentPosition.latitude,
                                _currentPosition.longitude, _whereLocation);
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit'),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen())),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
    );
  }
}

class GetLocationButton extends StatelessWidget {
  final Color color;
  final String buttonTitle;
  final Function onPressed;

  GetLocationButton({this.color, this.buttonTitle, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 10.0,
        color: color,
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 400.0,
          height: 42.0,
          child: Text(
            buttonTitle,
            style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: 'DMSans'),
          ),
        ),
      ),
    );
  }
}