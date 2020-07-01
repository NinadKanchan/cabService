import 'package:cab/welcomescreen.dart';
import 'package:flutter/material.dart';

class TransactionAccept extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("✔",style: TextStyle(fontSize: 70,color: Colors.green),)),
            ),
            Text("Request Accepted!",style: TextStyle(fontSize: 35),),
            Text("Your Cab will arrive shortly☺",style: TextStyle(fontSize: 30,fontFamily: 'DMSans'),),
            SizedBox(
              height: 5,
            ),

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




