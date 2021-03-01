import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/SplashScreen.dart';
import 'package:food_recommendation/admin/adminController.dart';
import 'package:food_recommendation/admin/admin_home.dart';
import 'package:food_recommendation/screens/home_screen.dart';
import 'package:food_recommendation/screens/initialPage.dart';
import 'package:food_recommendation/screens/login_screen.dart';
import 'package:food_recommendation/screens/settings.dart';
import 'package:food_recommendation/screens/signup_screen.dart';
import 'package:flutter/services.dart';
import 'package:food_recommendation/screens/step1.dart';
import 'package:food_recommendation/screens/step4.dart';
import 'package:food_recommendation/tabs/mainTab.dart';
import 'package:food_recommendation/tabs/preferrencesTab.dart';
import 'package:food_recommendation/tabs/settingsTab.dart';
import 'package:food_recommendation/userOrAdmin.dart';
import 'admin/login.dart';

void main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dinder',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        primaryColor: Colors.redAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
