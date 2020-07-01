import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cab/components/constants.dart';
import 'package:cab/components/rounded_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cab/dashboard/normaluser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cab/components/splashscreens/splashlogin.dart';




class RegistrationScreenNormal extends StatefulWidget {
  @override
  _RegistrationScreenNormalState createState() => _RegistrationScreenNormalState();
}

class _RegistrationScreenNormalState extends State<RegistrationScreenNormal> {

  String _picked = "MALE";
  final controller = new TextEditingController();
  String _email, _password, _fName, phoneNum, _lName;
  Firestore _firestore = Firestore.instance;

  Future<void> signUpNormal(String _email,String _password) async{
    if(phoneNum==null || _fName==null || _lName == null || _email == null || _password==null || _email.contains("@")==false || _email.length<5){
      Alert(context: context, title: "Incomplete Details", desc: "Fill all the details correctly.").show();
    }else{
      try{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreenLogin()));
        AuthResult _authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = _authResult.user;
        await _firestore.collection('UserInfo').document(_email).setData({
          'Name': _fName,
          'Email': _email,
          'Phone Number': phoneNum,
          'Gender': _picked,

        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NormalUser(userEmail: user.email,user: user,)));
      }catch(e){
        print(e);
        Alert(context: context, title: "Server Down", desc: "Please try again later.").show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.amber[800],
          title: Text(
            "SIGN UP",
            textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.0, ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0))
          ),
        ),
      ),


      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            _fName = value;
                          });
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter Your First name",
                          labelText: 'First Name',
                        ),
                      ),
                    ),
                  ),
                ],
              ),//Enter Phone Number
              SizedBox(
                height: 8,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            _lName = value;
                          });
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter Your last Name",
                          labelText: 'Last Name',
                        ),
                      ),
                    ),
                  ),
                ],
              ), //Enter First Name
              SizedBox(
                height: 8.0,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter Your Email Id",
                          labelText: 'Email'
                        ),
                      ),
                    ),
                  ),
                ],
              ),//Enter Last Name
              SizedBox(
                height: 8.0,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter Your Password",
                          labelText: 'Password',
                        ),
                      ),
                    ),
                  ),
                ],
              ), //Enter Email ID
              SizedBox(
                height: 8.0,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            phoneNum = value;
                          });
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter Your Phone number",
                          labelText: 'Phone number',
                        ),
                      ),
                    ),
                  ),
                ],
              ), //Create Password
              SizedBox(
                height: 8.0,
              ),
              Card(
                color: Colors.white,
                shadowColor: Colors.orangeAccent,elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            'Gender:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ), //Gender
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: RadioButtonGroup(
                            activeColor: Colors.brown,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            onSelected: (String selected) {
                              selectGender(selected);
                              setState(() {
                                _picked = selected;
                              });
                            },
                            picked: _picked,
                            labels: <String>[
                              "MALE",
                              "FEMALE",
                            ],
                          ),
                        ),
                      ), //Gender Radio
                    ],
                  ),
                ),
              ), //Gender

              SizedBox(height: 8.0,),

              RoundedButton(
                  color: Colors.brown,
                  buttonTitle: 'Register',
                  onPressed: () {
                    //TODO:Function
                    signUpNormal(_email, _password);
                  }),

              SizedBox(
                height: 8.0,
              ),
                   //Register Normal User
            ],
          ),
        ]),
      ),
    );
  }
}




