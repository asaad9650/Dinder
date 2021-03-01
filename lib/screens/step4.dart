import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_recommendation/screens/home_screen.dart';
import 'package:food_recommendation/screens/initialPage.dart';
import 'package:food_recommendation/screens/step3.dart';
import 'package:food_recommendation/tabs/mainTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Step4 extends StatefulWidget {
  @override
  _Step4State createState() => _Step4State();
}

class _Step4State extends State<Step4> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _oneToFiveMinutes = false;
  bool _tenToTwentyMinutes = false;
  bool _thrityOrMoreMinutes = false;
  bool _isLoading = false;

  sendData(String oftenEat) {
    setState(() {
      _isLoading = true;
    });
    //Toast.show(getStringValuesSF(), context,
    //  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    getStringValuesSF(oftenEat);
    //
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => InitialPage()));
  }

  getStringValuesSF(String oftenEat) async {
    final prefs = await SharedPreferences.getInstance();
    //Return String
    final myString = prefs.getString('my_string_key') ?? 'nooooooo';
    final myStringEmail = prefs.getString('my_string_email') ?? 'emailNotFound';
    final myStringPhone = prefs.getString('my_string_phone') ?? 'PhoneNotFound';
    print(myStringEmail);
    print(myStringPhone);

    databaseReference.child(myString).update({
      'often_travel': oftenEat,
      'status': 'Active',
      'default_radiius': '5 miles'
    });
    signUpAndSignIn(myStringEmail, myStringPhone);

    return myString;
  }

  void signUpAndSignIn(String _email, String _password) {
    // try {
    // firebaseAuth.createUserWithEmailAndPassword(
    // email: _email, password: _password);
    try {
      firebaseAuth.signInWithEmailAndPassword(
          email: _email, password: _password);
      Toast.show('Registered successfully', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      // print(firebaseAuth.currentUser.email);
      setState(() {
        _isLoading = false;
      });
      // } catch (e) {
      // setState(() {
      // _isLoading = false;
      // });
      // Toast.show(e.toString(), context,
      // duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      // }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Toast.show(e.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('assets/images/back.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: Colors.white70,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(40),
                  topRight: const Radius.circular(40),
                )),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 70, left: 10, right: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Center(
                              child: Text(
                                'How far do you typically travel for an outstanding meal experience?',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('1 - 5 minutes',
                                      style: TextStyle(fontSize: 20)),
                                  Checkbox(
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                      //tristate: true,
                                      value: _oneToFiveMinutes,
                                      onChanged: (bool val) {
                                        setState(() {
                                          _tenToTwentyMinutes = false;
                                          _thrityOrMoreMinutes = false;
                                          _oneToFiveMinutes = val;
                                        });
                                      })
                                ],
                              )),
                        ),
                        SizedBox(height: 8),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('10 - 20 minutes',
                                      style: TextStyle(fontSize: 20)),
                                  Checkbox(
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                      value: _tenToTwentyMinutes,
                                      onChanged: (bool val) {
                                        setState(() {
                                          _oneToFiveMinutes = false;
                                          _thrityOrMoreMinutes = false;
                                          _tenToTwentyMinutes = val;
                                        });
                                      })
                                ],
                              )),
                        ),
                        SizedBox(height: 8),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('30 or more',
                                      style: TextStyle(fontSize: 20)),
                                  Checkbox(
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                      value: _thrityOrMoreMinutes,
                                      onChanged: (bool val) {
                                        setState(() {
                                          _tenToTwentyMinutes = false;
                                          _oneToFiveMinutes = false;
                                          _thrityOrMoreMinutes = val;
                                        });
                                      })
                                ],
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 15, 7, 10),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: ButtonTheme(
                              height: 30,
                              //: MediaQuery.of(context).size.width,
                              buttonColor: Colors.blue,
                              //padding: EdgeInsets.only(right: 5),

                              child: FlatButton(
                                //padding: EdgeInsets.only(right: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.blue,
                                child: Text(
                                  'Submit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  if (_oneToFiveMinutes == false &&
                                      _tenToTwentyMinutes == false &&
                                      _thrityOrMoreMinutes == false) {
                                    Toast.show('Please select one', context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  } else {
                                    if (_oneToFiveMinutes == true) {
                                      sendData('One to five minutes');
                                    } else if (_tenToTwentyMinutes == true) {
                                      sendData('Ten to twenty minutes');
                                    } else if (_thrityOrMoreMinutes == true) {
                                      sendData('Thirty or more minutes');
                                    }

                                    _navigateToNextScreen(context);
                                  }
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
