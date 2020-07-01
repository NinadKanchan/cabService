import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'dart:async';
import 'package:cab/welcomescreen.dart';

class SplashScreenLogin extends StatefulWidget {
  @override
  _SplashScreenLoginState createState() => _SplashScreenLoginState();
}

class _SplashScreenLoginState extends State<SplashScreenLogin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
