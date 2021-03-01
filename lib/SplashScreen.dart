import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_recommendation/useroradmin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Animation animation;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 0),
      // () => createButton(),
      () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => UserOrAdmin())),
    );
  }

  Widget createButton() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () async {
                    // print("hereeeee");
                    // print(email);
                    // print(password);
                    // login_with_auth(email, password);
                    // Navigator.of(context).pushNamed(HomePage.tag);
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.redAccent,
                  child: Text('USER', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          alignment: Alignment.bottomRight,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: 1,
            child: Image.asset(
              'assets/images/back.jpg',
              fit: BoxFit.fill,
            ),
          )),
    );
  }
}
