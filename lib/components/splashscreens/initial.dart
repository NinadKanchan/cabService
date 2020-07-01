import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'dart:async';
import 'package:cab/welcomescreen.dart';

class SplashScreenI extends StatefulWidget {
  @override
  _SplashScreenIState createState() => _SplashScreenIState();
}

class _SplashScreenIState extends State<SplashScreenI> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GFLoader(
        type: GFLoaderType.custom,
        loaderIconOne   : Text('🛺',style: TextStyle(fontSize: 40),),
        loaderIconTwo   : Text('🛺',style: TextStyle(fontSize: 40),),
        loaderIconThree : Text('🛺',style: TextStyle(fontSize: 40),),
      ),
    );
  }
}
