import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_recommendation/screens/step4.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Step3 extends StatefulWidget {
  @override
  _Step3State createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('users');

  sendData(String oftenEat) {
    //Toast.show(getStringValuesSF(), context,
    //  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    getStringValuesSF(oftenEat);
    //
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Step4()));
  }

  getStringValuesSF(String oftenEat) async {
    final prefs = await SharedPreferences.getInstance();
    //Return String
    final myString = prefs.getString('my_string_key') ?? 'nooooooo';
    //String stringValue = prefs.getString('stringValue');
    //childValue = myString;

    // /Toast.show(myString, context,
    //  /   duration: Toast.LENGTH_LONG, gravity: Toast.TOP);

    //Map<String, String> update = new HashMap<String, String>();
    //update.addEntries("Often_eat", oftenEat);
    //update.("Often_eat", oftenEat);

    databaseReference.child(myString).update({'what_matters': oftenEat});
    return myString;
  }

  bool _distance = false;
  bool _atmosphere = false;
  bool _qualityOfFood = false;
  bool _priceRange = false;
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
              )),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 70, left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'What\'s important for you?',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Distance from you',
                                    style: TextStyle(fontSize: 20)),
                                Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    //tristate: true,
                                    value: _distance,
                                    onChanged: (bool val) {
                                      setState(() {
                                        _atmosphere = false;
                                        _qualityOfFood = false;
                                        _priceRange = false;
                                        _distance = val;
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
                                Text('Atmosphere',
                                    style: TextStyle(fontSize: 20)),
                                Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _atmosphere,
                                    onChanged: (bool val) {
                                      setState(() {
                                        _distance = false;
                                        _qualityOfFood = false;
                                        _atmosphere = val;
                                        _priceRange = false;
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
                                Text('Quality', style: TextStyle(fontSize: 20)),
                                Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _qualityOfFood,
                                    onChanged: (bool val) {
                                      setState(() {
                                        _priceRange = false;
                                        _atmosphere = false;
                                        _distance = false;
                                        _qualityOfFood = val;
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
                                Text('Price range',
                                    style: TextStyle(fontSize: 20)),
                                Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _priceRange,
                                    onChanged: (bool val) {
                                      setState(() {
                                        _priceRange = val;
                                        _atmosphere = false;
                                        _distance = false;
                                        _qualityOfFood = false;
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
                                if (_distance == false &&
                                    _atmosphere == false &&
                                    _qualityOfFood == false &&
                                    _priceRange == false) {
                                  Toast.show('Please select one', context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                } else {
                                  if (_distance == true) {
                                    sendData('Distance');
                                  } else if (_atmosphere == true) {
                                    sendData('Atmosphere');
                                  } else if (_qualityOfFood == true) {
                                    sendData('Quality');
                                  } else if (_priceRange = true) {
                                    sendData("Price Range");
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
