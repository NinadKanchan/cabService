import 'package:cab/login/loginscreen.dart';
import 'package:cab/login/registrationscreenbusiness.dart';
import 'package:cab/login/registrationscreennormal.dart';
import 'package:flutter/material.dart';
import 'package:cab/components/rounded_button.dart';
import 'package:flutter/gestures.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Image(
                height: 90.0,
                image: AssetImage('images/taxi1.png'),
              ),

              Container(
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'CAB',
                        style: TextStyle(
                              color: Colors.amber[800],
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' SERVICE',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),)
                        ]),
                  ),
                ),
              ),

              SizedBox(
                height: 48.0,
              ),

              RoundedButton(
                  buttonTitle: 'New User',
                  color: Colors.brown,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreenNormal()));
                  }),

              RoundedButton(
                  buttonTitle: 'Cab Operator',
                  color: Colors.brown,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreenBusiness()));
                  }),


              Container(
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Already Registered?',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Log In',
                              style: TextStyle(color: Colors.amber, fontSize: 16,fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                }),
                        ]),
                  ),
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
