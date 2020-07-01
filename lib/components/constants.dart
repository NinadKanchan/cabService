import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.orangeAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter Value Here',
  labelText: 'Username',
  labelStyle: TextStyle(
    color: Colors.black,
  ),
  contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.5),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.orangeAccent, width: 1.5),
  ),
);

enum genderType {
  Male,
  Female,
}

genderType gender;
void selectGender(String select) {
  if (select == "MALE")
    gender = genderType.Male;
  else
    gender = genderType.Female;
}
