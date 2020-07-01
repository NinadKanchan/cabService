import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'dart:async';


class DisplayRequestList extends StatefulWidget {
  DisplayRequestList({@required this.requestList,@required this.busID});
  final List<Widget> requestList;
  final DocumentReference busID;
  @override
  _DisplayRequestListState createState() => _DisplayRequestListState();
}

class _DisplayRequestListState extends State<DisplayRequestList> {
  @override
  Firestore firestore = Firestore.instance;
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 60),(){
      var doc = firestore.collection("BusinessLocation").document(widget.busID.documentID);
      doc.get().then((doc) {
        if (doc.exists) {
          firestore.collection("BusinessLocation").document(widget.busID.documentID).delete();
        }
      });
      Navigator.pop(context);
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Requests!"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber[800],
        ),
        body: ListView(
          children: widget.requestList,
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
              onPressed: () => Navigator.pop(context),
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

