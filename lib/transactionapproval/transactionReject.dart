import 'package:flutter/material.dart';
import 'package:cab/welcomescreen.dart';

class TransactionReject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("❌",style: TextStyle(fontSize: 70),)),
            ),
            SizedBox(
              height: 4,
            ),
            Text("Request Declined!",style: TextStyle(fontSize: 35,fontFamily: 'DMSans')),
            Text("Please Try Again☹",style: TextStyle(fontSize: 30,fontFamily: 'DMSans'),),
          ],
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
