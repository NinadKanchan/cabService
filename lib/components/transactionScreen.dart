import 'package:cab/transactionapproval/transactionAccept.dart';
import 'package:cab/transactionapproval/transactionReject.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';



class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
  TransactionScreen({@required this.userID});
  final userID;
}

class _TransactionScreenState extends State<TransactionScreen>
    with TickerProviderStateMixin {
  AnimationController controller;

  Firestore firestore = Firestore.instance;
  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String get statusString{
    var doc = firestore.collection("UserLocationRequests").document(widget.userID);

    doc.get().then((doc) {
      if (doc.exists) {
        print(doc.data["status"]);
        return doc.data["status"];
      }
    });
  }

  void statusUpdate(){
    int count = 0;
    Timer.periodic(Duration(seconds: 30), (timer) {
      count = count+1;
      var doc = firestore.collection("UserLocationRequests").document(widget.userID);
      doc.get().then((doc) {
        if (doc.exists) {
          if(doc.data["status"]=="Pending" && count ==6) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionReject()));
            firestore.collection("UserLocationRequests").document(widget.userID).delete();
            timer.cancel();
          }else if(doc.data["status"]=="Accept"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionAccept()));
            firestore.collection("UserLocationRequests").document(widget.userID).delete();
            timer.cancel();
          }else if(doc.data["status"]=="Pending" && count != 6){

          }
        }
      });
      print("Checked");
    });



  }


  @override
  void initState() {
    super.initState();
    statusUpdate();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 300),
    );
    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);


  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Warning'),
          content: Text('Do you really want to exit'),
          actions: [
            FlatButton(
              child: Text('Yes'),
              onPressed: () => Navigator.pop(c, false),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white10,
        body:
        AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.amber,
                      height:
                      controller.value * MediaQuery.of(context).size.height,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.center,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomPaint(
                                        painter: CustomTimerPainter(
                                          animation: controller,
                                          backgroundColor: Colors.white,
                                          color: themeData.indicatorColor,
                                        )),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Request Pending",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          timerString,
                                          style: TextStyle(
                                              fontSize: 112.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        /*
                        AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return FloatingActionButton.extended(
                                  onPressed: () {
                                    if (controller.isAnimating)
                                      controller.stop();
                                    else {
                                      controller.reverse(
                                          from: controller.value == 0.0
                                              ? 1.0
                                              : controller.value);
                                    }
                                  },
                                  icon: Icon(controller.isAnimating
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  label: Text(
                                      controller.isAnimating ? "Pause" : "Play"));
                            }),
                        */
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}


class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}