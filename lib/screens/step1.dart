import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'step2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

// ignore: must_be_immutable
class Step1 extends StatefulWidget {
  @override
  _Step1State createState() => _Step1State();

  //String databaseKey;
  //Step1({Key key, this.databaseKey}) : super(key: databaseKey);
}

class _Step1State extends State<Step1> {
  //final Key user;
  //String myString;

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('users');

  getStringValuesSF(String oftenEat) async {
    final prefs = await SharedPreferences.getInstance();

    //Return String
    final myString = prefs.getString('my_string_key') ?? 'no_value';
    prefs.setString('key', myString);
    //String stringValue = prefs.getString('stringValue');
    //childValue = myString;

    // Toast.show(myString, context,
    // duration: Toast.LENGTH_LONG, gravity: Toast.TOP);

    //Map<String, String> update = new HashMap<String, String>();
    //update.addEntries("Often_eat", oftenEat);
    //update.("Often_eat", oftenEat);

    databaseReference.child(myString).update({'eat_outside': oftenEat});
    return myString;
  }

  //Step1({Key key , this.user}) : super(key:user);

  bool _oneToTwoTimes = false;
  bool _threeToFourTimes = false;
  bool _fiveOrMoreTimes = false;
  sendData(String oftenEat) {
    //Toast.show(getStringValuesSF(), context,
    //  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    getStringValuesSF(oftenEat);
    //
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Step2()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.70,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 70, left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'How often you eat outside the home?',
                            style: TextStyle(fontSize: 20),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('1 - 2 times a week',
                                    style: TextStyle(fontSize: 20)),
                                Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    //tristate: true,
                                    value: _oneToTwoTimes,
                                    onChanged: (bool val) {
                                      setState(() {
                                        _threeToFourTimes = false;
                                        _fiveOrMoreTimes = false;
                                        _oneToTwoTimes = val;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('2 - 4 times a week',
                                    style: TextStyle(fontSize: 20)),
                                Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _threeToFourTimes,
                                    onChanged: (bool val) {
                                      setState(() {
                                        _oneToTwoTimes = false;
                                        _fiveOrMoreTimes = false;
                                        _threeToFourTimes = val;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('5 or more',
                                    style: TextStyle(fontSize: 20)),
                                Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _fiveOrMoreTimes,
                                    onChanged: (bool val) {
                                      setState(() {
                                        _threeToFourTimes = false;
                                        _oneToTwoTimes = false;
                                        _fiveOrMoreTimes = val;
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
                                'Next',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                if (_oneToTwoTimes == false &&
                                    _threeToFourTimes == false &&
                                    _fiveOrMoreTimes == false) {
                                  Toast.show('Please select one', context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                } else {
                                  if (_oneToTwoTimes == true) {
                                    sendData('One or two times a week');
                                  } else if (_threeToFourTimes == true) {
                                    sendData('Three or four times a week');
                                  } else if (_fiveOrMoreTimes == true) {
                                    sendData('Five or more times a week');
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
    );
  }
}
