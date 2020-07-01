import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/splashscreens/initial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        home: SplashScreenI(),
        //home: NormalUser(),
        //home: BusinessUser(),

       // initialRoute: 'business_user' ,
        //routes: {
          //'business_user': (context) => BusinessUser(user: null,userEmail: null,),
        //},

      ),
    );
  }
}
