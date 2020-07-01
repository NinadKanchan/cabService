import 'dart:ui';
import 'package:cab/components/splashscreens/splashlogin.dart';
import 'package:cab/welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cab/components/businesscard.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'requestsBusinessUserFinal.dart';
import 'dart:async';

class BusinessUser extends StatefulWidget {
  BusinessUser({@required this.userEmail, @required this.user});
  final String userEmail;
  final FirebaseUser user;
  @override
  _BusinessUserState createState() => _BusinessUserState();
}

class _BusinessUserState extends State<BusinessUser> {
  Position currentPosition;
  Geoflutterfire geo = new Geoflutterfire();
  Firestore firestore = Firestore.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  DocumentReference doc;
  Future<void> _getCurrentLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
    GeoFirePoint myLocation = geo.point(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude);
    doc = await firestore.collection('BusinessLocation').add({
      'name': widget.userEmail
          .substring(0, widget.userEmail.indexOf("@"))
          .toUpperCase(),
      'OperatorLocation': myLocation.data
    });
    print("LOCATION ADDED");
  }

  Future<void> onConfirm() async {

    try {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreenLogin()));
      await _getCurrentLocation();
      if (currentPosition != null) {
        GeoFirePoint center = geo.point(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude);
        var collectionReference = firestore.collection('UserLocationRequests');
        double radius = 2;
        String field = 'From';

        Stream<List<DocumentSnapshot>> stream = geo
            .collection(collectionRef: collectionReference)
            .within(center: center, radius: radius, field: field);
        stream.listen((List<DocumentSnapshot> documentList) async {
          // doSomething()
          setState(() {
            requestList = [];
          });
          for (int i = 0; i < documentList.length; i++) {
            setState(() {
              requestList.add(BusinessCard(
                fromLocation: documentList[i].data["fromAddress"],
                toLocation: documentList[i].data["To"],
                userName: documentList[i].data["name"],
                userID: documentList[i].documentID,
              ));
            });
          }
        });
        Timer(Duration(seconds: 2), () {
          if (requestList.isEmpty == false) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayRequestList(
                          requestList: requestList,
                          busID: doc,
                        )));
          } else {
            var docref = firestore
                .collection("BusinessLocation")
                .document(doc.documentID);
            docref.get().then((doc) {
              if (doc.exists) {
                firestore
                    .collection("BusinessLocation")
                    .document(doc.documentID)
                    .delete();
              }
            });
            Alert(
                    context: context,
                    title: "No Current Requests",
                    desc: "Please try again later.")
                .show();
          }
          print("Yeah, this line is printed after 3 seconds");
        });
      } else {
        Alert(
                context: context,
                title: "Location Not Found",
                desc: "Unable to detect your location.")
            .show();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BusinessUser(
                      userEmail: widget.userEmail,
                      user: widget.user,
                    )));
      }
    } catch (e) {
      print(e);
    }
  }

  List<Widget> requestList = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    //Implement logout functionality
                    Navigator.push(context,
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Drive Safe!',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Opacity(
                opacity: 0.6,
                child: Text(
                  'Always wear seatbelt while driving!',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Image(
                image: AssetImage('images/City driver-pana.png'),
              ),
              GetRequestsButton(
                color: Colors.blueGrey[300],
                buttonTitle: "GET REQUEST",
                onPressed: () {
                  setState(() {
                    onConfirm();
                  });
                },
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

class GetRequestsButton extends StatelessWidget {
  final Color color;
  final String buttonTitle;
  final Function onPressed;

  GetRequestsButton({this.color, this.buttonTitle, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 10.0,
        color: color,
        borderRadius: BorderRadius.circular(32.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 170.0,
          height: 50.0,
          child: Text(
            buttonTitle,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'DMSans',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}
