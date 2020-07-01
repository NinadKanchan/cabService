import 'package:cab/dashboard/business_user.dart';
import 'package:cab/dashboard/normaluser.dart';
import 'package:flutter/material.dart';
import 'package:cab/components/constants.dart';
import 'package:cab/components/rounded_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cab/components/splashscreens/splashlogin.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password,uid = "";

  Future<void> signIn(String email,String password) async{
    if(email==null || password==null){
      Alert(context: context, title: "Incomplete Details", desc: "Fill all the details properly.").show();
    }else if(email!=null && password!=null && uid==""){
      try{
        //TODO
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreenLogin()));
        AuthResult _authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = _authResult.user;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NormalUser(userEmail: user.email,user: user,)));
      }catch(e){
        Alert(context: context, title: "Incorrect Details or Connection Lost", desc: "Please try again.").show();
      }
    }else if(email!=null && password!=null && uid.length==9){
      try{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreenLogin()));
        AuthResult _authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = _authResult.user;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BusinessUser(userEmail: user.email,user: user,)));
      }catch(e){
        Alert(context: context, title: "Incorrect Details or Connection Lost", desc: "Please try again.").show();
      }
    }else if(email!=null && password!=null && uid.length!=9){
      Alert(context: context, title: "Incorrect Details", desc: "Please try again.").show();
    }else{
      Alert(context: context, title: "Server Down", desc: "Please try again later.").show();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: AppBar(
        title: Text(
          "LOGIN",
          textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.0, ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0))
        ),
        backgroundColor: Colors.amber[800],
      ),
    ),


      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                setState(() {
                  email = value;
                });

              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter email here',labelText: 'Email'),
            ),

            SizedBox(
              height: 15.0,
            ),

            TextField(
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                //Do something with the user input.
                setState(() {
                  password = value;
                });

              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password',
                labelText: 'Password'
              ),
            ),

            SizedBox(
              height: 24.0,
            ),

            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                //Do something with the user input.
                setState(() {
                  uid = value;
                });

              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your UID if you are operator',
                labelText: 'UID Number'
              ),
            ),

            SizedBox(
              height: 24.0,
            ),

            RoundedButton(
                color: Colors.brown,
                buttonTitle: 'Log In',
                onPressed: () {
                  signIn(email, password);
                }),
          ],
        ),
      ),
    );
  }
}
