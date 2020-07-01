import 'package:flutter/material.dart';
import 'rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BusinessCard extends StatefulWidget {
  BusinessCard({@required this.fromLocation,@required this.toLocation,@required this.userName, @required this.userID });
  final String userName;
  final String fromLocation;
  final String toLocation;
  final String userID;
  @override
  _BusinessCardState createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  @override
  Firestore firestore = Firestore.instance;
  
  Future<void> onPressedAccept(String userID)async{
    var doc = firestore.collection("UserLocationRequests").document(userID);
    await doc.setData({
      "status" : "Accept",
    },merge: true);

  }
  void onPressedReject(String userID)async{
    var doc = firestore.collection("UserLocationRequests").document(userID);
    await doc.setData({
      "status" : "Pending"
    },merge: true);

  }

  bool isEnable = true;
  Color color = Colors.lightBlueAccent;

  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.black54),
            ),

            onPressed: (isEnable)?((){}):null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("User:",style:
                            TextStyle(fontFamily: 'DMSans',fontWeight: FontWeight.w500,fontSize: 16),),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(child: Text(widget.userName, style: TextStyle(fontSize: 14,fontFamily: 'DMSans'),)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("From:",style:
                            TextStyle(fontFamily: 'DMSans',fontWeight: FontWeight.w500,fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(child: Text(widget.fromLocation, style: TextStyle(fontSize: 14,fontFamily: 'DMSans'),)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("To:",style:
                            TextStyle(fontFamily: 'DMSans',fontWeight: FontWeight.w500,fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(child: Text(widget.toLocation, style: TextStyle(fontSize: 14,fontFamily: 'DMSans'),)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("User ID:",style:
                            TextStyle(fontFamily: 'DMSans',fontWeight: FontWeight.w500,fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(child: Text(widget.userID, style: TextStyle(fontSize: 14,fontFamily: 'DMSans'),)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: RoundedButton(
                        onPressed: (isEnable)?((){
                          onPressedAccept(widget.userID);
                          setState(() {
                            isEnable = false;
                            color = Colors.grey;
                          });

                        }):null,
                        buttonTitle: "Accept",
                        color: Colors.green,

                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: RoundedButton(
                        onPressed: (isEnable)?((){
                          onPressedReject(widget.userID);
                          setState(() {
                            isEnable = false;
                            color = Colors.grey;
                          });
                        }):null,
                        buttonTitle: "Reject",
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

