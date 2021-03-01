import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/screens/GoPremium.dart';
import 'package:food_recommendation/screens/home_screen.dart';
import 'package:food_recommendation/screens/login_screen.dart';
import 'package:food_recommendation/screens/settings.dart';
import 'package:food_recommendation/tabs/restaurant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_recommendation/screens/FoodSelectionSettings.dart';
import 'package:food_recommendation/screens/Preferences.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  List<Restaurant> restaurantList = [];
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  onTapFunction(String clicked) {
    if (clicked == "FoodSelectionSettings") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Settings()));
    } else if (clicked == "Preferences") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Preferences()));
    } else if (clicked == "GoPremium") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GoPremium()));
    }

    // Toast.show(Clicked + " clicked", context,
    // duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  @override
  void initState() {
    super.initState();
    //getSF();
  }

  Future<String> getSF() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('distance', "2m");
    String dbKey = preferences.getString('key') ?? 'no_value';

    DatabaseReference restRef = FirebaseDatabase.instance.reference();
    restRef.child("users").child(dbKey).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values["status"] == "active" || values["status"] == "Active") {
        buildOne();
      } else {
        setState(() {
          isLoading = true;
        });
        final snackBar = SnackBar(
          content: Text(
              'You are restricted by admin. Please contact recommendation.food@gmail.com for further queries.'),
          action: SnackBarAction(
            label: "Ok",
            onPressed: () {
              auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });
    return dbKey;
  }

  Widget buildTwo() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.white70,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/prefs_logo.png",
                            fit: BoxFit.contain,
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Preferences",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      onTapFunction("Preferences");
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.white70,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/selection.png",
                            fit: BoxFit.contain,
                            height: 90,
                            width: 100,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Food Selection Settings",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      onTapFunction("FoodSelectionSettings");
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: GestureDetector(
                child: Container(
                  height: 150,
                  width: 150,
                  color: Colors.white70,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/diamond2.png",
                        fit: BoxFit.contain,
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Go Premium",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  onTapFunction("GoPremium");
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 190,
                  width: 150,
                  color: Colors.white70,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/prefs_logo.png",
                        fit: BoxFit.contain,
                        height: 130,
                        width: 130,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Preferences",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  onTapFunction("Preferences");
                },
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                child: Container(
                  height: 190,
                  width: 150,
                  color: Colors.white70,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/selection.png",
                        fit: BoxFit.contain,
                        height: 130,
                        width: 130,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Food Selection Settings",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  onTapFunction("FoodSelectionSettings");
                },
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                child: Container(
                  height: 190,
                  width: 150,
                  color: Colors.white70,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/diamond2.png",
                        fit: BoxFit.contain,
                        height: 130,
                        width: 130,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Go Premium",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  onTapFunction("GoPremium");
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget buildOne() {
    setState(() {
      isLoading = false;
    });
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // alignment: Alignment.bottomCenter,
              children: <Widget>[
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: ExactAssetImage(
                    'assets/images/dinder.jpg',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Dinder Guide ',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      decorationThickness: 10),
                ),
                // Container(
                //   alignment: Alignment.topLeft,
                //   child: Stack(
                //     children: <Widget>[
                //       (IconButton(
                //           icon: Icon(Icons.arrow_back),
                //           onPressed: () {
                //             Navigator.pop(context);
                //           }))
                //     ],
                //   ),
                // ),

                SizedBox(height: 30),
                // checkIfRestricted(),
                buildTwo(),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<bool> _onWillPop() async {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // isLoading = true;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ModalProgressHUD(
          inAsyncCall: isLoading, opacity: 0.7, child: buildOne()),
    );

    // return Stack(
    //   alignment: Alignment.topLeft,
    //   children: <Widget>[
    //     (IconButton(
    //         icon: Icon(Icons.arrow_back),
    //         onPressed: () {
    //           Navigator.pop(context);
    //         }))
    //   ],
    // );
  }
}
