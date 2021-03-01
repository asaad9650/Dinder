import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/admin/login.dart';
import 'package:food_recommendation/screens/home_screen.dart';
import 'package:food_recommendation/screens/login_screen.dart';
import 'package:food_recommendation/screens/signup_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class UserOrAdmin extends StatefulWidget {
  @override
  _UserOrAdminState createState() => _UserOrAdminState();
}

class _UserOrAdminState extends State<UserOrAdmin> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('users');
  String databaseKey;

  Future getLocation() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.phone,
    ].request();
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position);
      delay();

      // LatLng start = new LatLng(
      // position.latitude, position.longitude);
    } catch (e) {
      print(e.toString());
    }
  }

  DateTime backButtonPressedTime;
  Future<bool> onDoubleBack() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 200);

    if (backButton) {
      backButtonPressedTime = currentTime;
      Toast.show("Press back again to exit the app ", context,
          gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }

  Future getStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // preferences.setString('distance', "2m");
    databaseKey = preferences.getString('key') ?? 'no_value';
    if (databaseKey != "no_value") {
      databaseReference.child(databaseKey).once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        if (values["status"] == "active" || values["status"] == "Active") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );
          // foodReference.once().then((DataSnapshot snapshot) {
          // if (arrayFoodType.length == 0) {
          // showLoader();
          // }
          // Map<dynamic, dynamic> values = snapshot.value;
          // values.forEach((key, values) {
          // setState(() {
          // arrayFoodType.add(values["foodType"]);
          // initial = arrayFoodType.first;
          // });
        } else {
          final snackBar = SnackBar(
            content: Text(
                'You are restricted by admin. Please contact recommendation.food@gmail.com for further queries.'),
            action: SnackBarAction(
              label: "Ok",
              onPressed: () {
                firebaseAuth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        getLocation();
      }
    } on SocketException catch (_) {
      Scaffold.of(context).showSnackBar(new SnackBar(
          content:
              new Text("Please Check Your Internet Connection and try again")));
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();

    // getStatus();
    // checkPermssion();
    // print(firebaseAuth.currentUser);
  }

  Future checkPermssion() async {
    // String email = firebaseAuth.currentUser.email;
    // if (email == null) {
    //   // if (firebaseAuth == null) {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginScreen()),
    //     (Route<dynamic> route) => false,
    //   );

    //   // } else {
    //   // Navigator.pushAndRemoveUntil(
    //   // context,
    //   // MaterialPageRoute(builder: (context) => HomeScreen()),
    //   // (Route<dynamic> route) => false,
    //   // );
    //   // }

    //   // Either the permission was already granted before or the user just granted it.
    // } else {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomeScreen()),
    //     (Route<dynamic> route) => false,
    //   );
    // }
  }

  Widget delay() {
    Timer(Duration(seconds: 5), () {
      User user = firebaseAuth.currentUser;
      if (user != null) {
        // checkPermssion();
        getStatus();
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });

    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onDoubleBack,
      child: Container(
        height: 200,
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          // make sure we apply clip it properly
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Hero(
                        tag: 'Dinder',
                        child: CircleAvatar(
                          backgroundImage: ExactAssetImage(
                            'assets/images/dinder.jpg',
                          ),
                          // backgroundColor: Colors.transparent,
                          radius: 70.0,
                          // child: Image.asset('assets/images/dinder.jpg'),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    // delay(),

                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   margin: EdgeInsets.only(left: 30, right: 30, top: 0),
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 0.0),
                    //     child: RaisedButton(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(24),
                    //       ),
                    //       onPressed: () {
                    //         // checkPermssion();

                    //         //   print(user);
                    //         //   Position position = await Geolocator()
                    //         //       .getCurrentPosition(
                    //         //           desiredAccuracy: LocationAccuracy.high);
                    //         //   if (position.latitude == null &&
                    //         //       position.longitude == null) {
                    //         //     position = await Geolocator()
                    //         //         .getCurrentPosition(
                    //         //             desiredAccuracy: LocationAccuracy.high);
                    //         //   } else {
                    //         //     Navigator.push(
                    //         //       context,
                    //         //       MaterialPageRoute(
                    //         //           builder: (context) => HomeScreen()),
                    //         //       // (Route<dynamic> route) => false,
                    //         //     );
                    //         //   }
                    //         // } else {
                    //         //   checkPermission();
                    //         //   // Navigator.push(
                    //         //   //   context,
                    //         //   //   MaterialPageRoute(
                    //         //   //       builder: (context) => LoginScreen()),
                    //         //   //   // (Route<dynamic> route) => false,
                    //         //   // );
                    //         // }

                    //         // print("hereeeee");
                    //         // print(email);
                    //         // print(password);
                    //         // login_with_auth(email, password);
                    //         // Navigator.of(context).pushNamed(HomePage.tag);
                    //       },
                    //       padding: EdgeInsets.all(12),
                    //       color: Colors.redAccent,
                    //       child: Text('A',
                    //           style: TextStyle(color: Colors.white)),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 0),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.only(left: 30, right: 30, top: 0),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 0.0),
//                         child: RaisedButton(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(24),
//                           ),
//                           onPressed: () {
//                             try {
// //                            firebaseAuth.signOut();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => AdminLogin()),
//                                 // (Route<dynamic> route) => false,
//                               );
//                             } catch (e) {
//                               print(e);
//                             }
//                             // Navigator.of(context).pushReplacement(
//                             //     MaterialPageRoute(
//                             //         builder: (BuildContext context) =>
//                             //             AdminLogin()));
//                             // print("hereeeee");
//                             // print(email);
//                             // print(password);
//                             // login_with_auth(email, password);
//                             // Navigator.of(context).pushNamed(HomePage.tag);
//                           },
//                           padding: EdgeInsets.all(12),
//                           color: Colors.redAccent,
//                           child: Text('ADMIN',
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     ),
                  ],

                  // "CHOCOLATE",
                  // style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
    //   // /backgroundColor: Colors.transparent,
    //   body: Center(
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: <Widget>[
    //           AnimatedOpacity(
    //               duration: Duration(milliseconds: 500),
    //               opacity: 0.5,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   image: DecorationImage(
    //                     image: AssetImage("assets/images/back.jpg"),
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               )),
    //           Container(
    //             width: MediaQuery.of(context).size.width,
    //             margin: EdgeInsets.only(left: 30, right: 30, top: 0),
    //             child: Padding(
    //               padding: EdgeInsets.symmetric(vertical: 16.0),
    //               child: RaisedButton(
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(24),
    //                 ),
    //                 onPressed: () async {
    //                   // print("hereeeee");
    //                   // print(email);
    //                   // print(password);
    //                   // login_with_auth(email, password);
    //                   // Navigator.of(context).pushNamed(HomePage.tag);
    //                 },
    //                 padding: EdgeInsets.all(12),
    //                 color: Colors.redAccent,
    //                 child: Text('USER', style: TextStyle(color: Colors.white)),
    //               ),
    //             ),
    //           ),
    //           SizedBox(height: 0),
    //           Container(
    //             width: MediaQuery.of(context).size.width,
    //             margin: EdgeInsets.only(left: 30, right: 30, top: 0),
    //             child: Padding(
    //               padding: EdgeInsets.symmetric(vertical: 16.0),
    //               child: RaisedButton(
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(24),
    //                 ),
    //                 onPressed: () async {
    //                   // print("hereeeee");
    //                   // print(email);
    //                   // print(password);
    //                   // login_with_auth(email, password);
    //                   // Navigator.of(context).pushNamed(HomePage.tag);
    //                 },
    //                 padding: EdgeInsets.all(12),
    //                 color: Colors.redAccent,
    //                 child: Text('ADMIN', style: TextStyle(color: Colors.white)),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
