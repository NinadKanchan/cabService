import 'package:cab/dashboard/business_user.dart';
import 'package:flutter/material.dart';
import 'package:cab/components/constants.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cab/components/rounded_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cab/components/splashscreens/splashlogin.dart';

class RegistrationScreenBusiness extends StatefulWidget {
  @override
  _RegistrationScreenBusinessState createState() => _RegistrationScreenBusinessState();
}

class _RegistrationScreenBusinessState extends State<RegistrationScreenBusiness> {
  Firestore _firestore = Firestore.instance;
  String _phoneNumber,
      _name,
      selectedDocumentName = "",
      _documentNumber,
      _picked = "MALE",
      _email,
      _password;
  int selectedRadio, documentnumberLength = 12;
  TextInputType keyboardType;
  bool check = false;
  String uniqueIdentificationNumber;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (val == 1) {
        selectedDocumentName = "Aadhar Card";
        keyboardType = TextInputType.number;
        documentnumberLength = 12;
      } else if (val == 2) {
        selectedDocumentName = "Pan Card";
        keyboardType = TextInputType.text;
        documentnumberLength = 10;
      } else if (val == 3) {
        selectedDocumentName = "Driving License";
        keyboardType = TextInputType.text;
        documentnumberLength = 15;
      }
    });
  }

  void initState() {
    super.initState();
    selectedRadio = 0;
    uniqueIdentificationNumber = generateUniqueId();
  }

  String generateUniqueId() {
    Random random = new Random();
    int uid = random.nextInt(899999999) + 100000000;
    return uid.toString();
  }

//dialog box after incomplete entries
  Future<void> signUpBusiness(String _email, String _password) async {
    if (_phoneNumber == null ||
        _name == null ||
        _email == null ||
        _password == null ||
        _email.contains("@") == false ||
        _email.length < 5 ||
        _documentNumber == null ||
        documentnumberLength != _documentNumber.length) {
      Alert(
              context: context,
              title: "Incomplete Details",
              desc: "Fill all the details correctly.").show();
    }
    else {
      try {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreenLogin()));
        AuthResult _authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = _authResult.user;

        await _firestore.collection('OperatorInfo').document(_email).setData({
          'Name': _name,
          'Email': _email,
          'Phone Number': _phoneNumber,
          'Gender': _picked,
          'Document Name': selectedDocumentName,
          'Document Number': _documentNumber,
          'UID Number' : uniqueIdentificationNumber,
        });

        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => BusinessUser(
                      userEmail: user.email,
                      user: user,
                    )));
      } catch (e) {
        print(e);Alert(
                context: context,
                title: "Server Down",
                desc: "Please try again later.").show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          title: Text(
            "SIGN UP",
            textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.0, ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0))
          ),
          backgroundColor: Colors.orange[500],
        ),
      ),


      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //LOGO
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
                            _name = value;
                          });
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter Your name",
                        ),
                      ),
                    ),
                  ),
                ],
              ), //Enter Phone Number
              SizedBox(
                height: 8,
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
                          labelText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ],
              ), //Enter Name
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
                          hintText: "Enter Your Passsword",
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
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            _phoneNumber = value;
                          });
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Enter Your Phone No.",
                          labelText: 'Phone Number',
                        ),
                      ),
                    ),
                  ),
                ],
              ), //Create Password
              Card(
                color: Colors.white,
                  shadowColor: Colors.orangeAccent,elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Text(
                  'Select Any One Document',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RadioListTile(
                    activeColor: Colors.brown,
                    title: Text("Aadhar Card"),
                    value: 1,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val);
                    },
                  ), //AADHAR
                  RadioListTile(
                    activeColor: Colors.brown,
                    title: Text("Pan Card"),
                    value: 2,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val);
                    },
                  ), //PAN
                  RadioListTile(
                    activeColor: Colors.brown,
                    title: Text("Driving License"),
                    value: 3,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val);
                    },
                  ), //DRIVING
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                maxLength: documentnumberLength,
                maxLengthEnforced: true,
                keyboardType: keyboardType,
                textAlign: TextAlign.center,
                obscureText: false,
                onChanged: (value) {
                  setState(() {
                    if (value == "") {
                      check = false;
                    } else {
                      check = true;
                      _documentNumber = value;
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter $selectedDocumentName Number Here',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
              SizedBox(height: 6.0),
              Divider(thickness: 0.5, color: Colors.grey,indent: 60, endIndent: 60,),

              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                        child:
                            Text("This is your Unique Identification Number")),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        "Please note it down",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        uniqueIdentificationNumber,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              RoundedButton(
                  color: Colors.brown,
                  buttonTitle: 'Register',
                  onPressed: () {
                    //TODO:Function
                    signUpBusiness(_email, _password);
                  }),
              SizedBox(
                height: 8.0,
              ),
              //Register Business User
            ],
          ),
        ]),
      ),
    );
  }
}
