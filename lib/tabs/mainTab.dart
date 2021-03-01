// import 'dart:html';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recommendation/models/place_model.dart';
import 'package:food_recommendation/screens/Settings%20screens/changeradius.dart';
import 'package:food_recommendation/screens/Settings%20screens/dislikes.dart';
import 'package:food_recommendation/screens/login_screen.dart';
import 'package:food_recommendation/screens/restaurant_list.dart';
import 'package:food_recommendation/screens/settings.dart';
import 'package:food_recommendation/services/place_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:food_recommendation/userOrAdmin.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:shake/shake.dart';
import 'package:flutter_shake_plugin/flutter_shake_plugin.dart';
import 'package:vibration/vibration.dart';

class MainTab extends StatefulWidget {
  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  FirebaseAuth auth = FirebaseAuth.instance;
  // FlutterShakePlugin _shakePlugin;
  bool food_type, distance_in_miles;
  DatabaseReference foodReference =
      FirebaseDatabase.instance.reference().child("foodType");
  // static const apiKey =
  String apiKey;
  // 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&key=AIzaSyAvZwLab_aC75vTPSB8oPCQkeOSYwnCUS4';
  static const nycLat = 40.7484445;
  static const nycLng = 73.9878531;
  CarouselController buttonCarouselController = CarouselController();
  bool status;
  String defaultRadius;
  int defRadius;
  List arrayFoodType = [];
  List arrayDislike = [];
  List distance = [
    '2',
    '5',
    '8',
    '10',
    '15',
    '20',
    '25',
  ];
  int _current = 0;
  String userStatus;
  // bool checkFoodType;
  // bool checkFoodTypeDistance;
  String _platformImei = "null";
  String uniqueId = "null";

  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('users');

  DatabaseReference check =
      FirebaseDatabase.instance.reference().child("users");
  List userSelectedItemsArray = [];
  List userSelectedDistanceArray = [];
  String databaseKey;
  int _imageIndex = 0;
  int _distanceIndex = 0;
  FlutterShakePlugin _shakePlugin;
  String initial = "";

  Widget textWidget(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w700, color: Colors.blueAccent),
    );
  }

  Future<bool> _onWillPop() async {
    Toast.show("Double tap back button to exit the app ", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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

  @override
  Widget build(BuildContext context) {
    if (arrayFoodType.length == 0) {
      return Center(
        child: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: onDoubleBack,
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(0),
            // color: Colors.grey,
            decoration: BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: ExactAssetImage(
                      'assets/images/dinder.jpg',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'It\'s time for ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  textWidget(initial),
                  // textWidget("Mexican"),
                  // Text(
                  //   'Food',
                  //   style: TextStyle(
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.w700,
                  //       color: Colors.blueAccent),
                  // ),
                  SizedBox(height: 0),
                  Container(
                    // color: Colors.grey[100],
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                      // borderRadius: BorderRadius.circular(5),
                    ),
                    child: CarouselSlider(
                      items: arrayFoodType.map((foodType) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        // height: 140,
                                        // width: 130,
                                        // height:
                                        //     MediaQuery.of(context).size.height * 0.3,
                                        // width:
                                        //     MediaQuery.of(context).size.width * 0.3,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // color: Colors.red,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image(
                                            height: 119,
                                            width: 165,
                                            image: AssetImage(
                                                'assets/images/plate_3d.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //  CircleAvatar(
                                    // radius: 50,
                                    // backgroundImage:
                                    // AssetImage('assets/images/hd_food.png'),
                                    // child: Image.network(
                                    // imgUrl,
                                    // fit: BoxFit.fill,
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      carouselController: buttonCarouselController,

                      options: CarouselOptions(
                        autoPlay: false,
                        disableCenter: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.6,
                        aspectRatio: 1,
                        // disableCenter: true,

                        initialPage: 0,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,

                        onPageChanged: (prev, next) {
                          textWidget(arrayFoodType[prev]);

                          setState(() {
                            //placesUpdate(prev);
                            _imageIndex = prev;
                            // textWidget("Slide");
                            initial = arrayFoodType[prev];
                            // textWidget(foodType[prev]);
                          });
                        },
                        height: 150.0,
                      ),

                      // textWidget(foodType[1]),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //for distance

                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey[100],
                      ),
                      child: CarouselSlider(
                        items: distance.map((dist) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  // color: Colors.grey[100],
                                  // height: 10,
                                  // width: 50,
                                  // margin: EdgeInsets.only(left: 10),
                                  // width: MediaQuery.of(context).size.width * 0.1,
                                  // height: 20,
                                  // width: 50,
                                  // margin: EdgeInsets.symmetric(horizontal: 10.0),
                                  // decoration: BoxDecoration(
                                  //   shape: BoxShape.rectangle,
                                  //   // color: Colors.redAccent,
                                  // ),
                                  // child: Card(
                                  // shape: RoundedRectangleBorder(
                                  // borderRadius: BorderRadius.circular(40),
                                  // ),
                                  // shape: CircleAvatar(),
                                  // ),
                                  // child: Image.network(imgUrl, fit: BoxFit.cover),
                                  child: Center(
                                child: Text(
                                  dist + "m",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              )

                                  // Text()
                                  );
                            },
                          );
                        }).toList(),
                        carouselController: buttonCarouselController,
                        options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: false,
                            viewportFraction: 0.4,
                            aspectRatio: 1,
                            initialPage: 0,
                            onPageChanged: (prev, next) {
                              setState(() {
                                _distanceIndex = prev;

                                // /placesUpdate(prev);
                              });
                            },
                            height: 35.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonTheme(
                    height: 30,
                    minWidth: MediaQuery.of(context).size.width * 0.35,
                    child: RaisedButton(
                      disabledColor: Colors.lightBlue,
                      splashColor: Colors.blue,
                      hoverColor: Colors.blueGrey,
                      //padding: EdgeInsets.only(right: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue,

                      child: Text(
                        'Select',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        // print(userSelectedDistanceArray);
                        // Toast.show(distance[_distanceIndex], context,
                        // duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        updatePref(arrayFoodType[_imageIndex],
                            distance[_distanceIndex]);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Or Shake device for random selection.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void updatePref(String userSelectedType, String userSelectedDistance) {
    bool checkFoodType = false;
    bool checkFoodTypeDistance = false;

    // print(databaseKey);
    for (int i = 0; i < userSelectedItemsArray.length; i++) {
      if (userSelectedType == userSelectedItemsArray[i]) {
        checkFoodType = true;
        break;
      }
    }
    for (int i = 0; i < userSelectedDistanceArray.length; i++) {
      if (userSelectedDistance == userSelectedDistanceArray[i]) {
        checkFoodTypeDistance = true;
        break;
      }
    }
    if (checkFoodType && checkFoodTypeDistance) {
      Toast.show("Food Type already exist in your preferences.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      // } else if (!checkFoodType || !checkFoodTypeDistance) {
    } else {
      userSelectedItemsArray.add(userSelectedType);
      userSelectedDistanceArray.add(userSelectedDistance);
      databaseReference.child(databaseKey).child('preferences').push().set({
        'foodType': userSelectedType,
        'distanceInMiles': userSelectedDistance
      });

      Toast.show("Saved in preferences.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Widget _createContent() {
    if (_places == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new ListView(
        children: _places.map((f) {
          return new ListTile(
            title: new Text(f.name),
            leading: new Image.network(f.icon),
            subtitle: new Text(f.vicinity),
          );
        }).toList(),
      );
    }
  }

  List<Place> _places;

  Future<String> getKey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // preferences.setString('distance', "2m");
    databaseKey = preferences.getString('key') ?? 'no_value';
    print(databaseKey);

    databaseReference.child(databaseKey).once().then((DataSnapshot snapshot) {
      setState(() {
        defaultRadius = snapshot.value["default_radiius"];
        defaultRadius = defaultRadius.replaceAll(" miles", "");

        defRadius = int.parse(defaultRadius);
      });
      print(defRadius);
    });
    databaseReference
        .child(databaseKey)
        .child("dislikes")
        .once()
        .then((DataSnapshot snap) {
      // print(snap.value);
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      for (var individualKey in KEYS) {
        print(DATA[individualKey]["dislike"]);
        arrayDislike.add(DATA[individualKey]["dislike"]);
        setState(() {
          print('Length: $arrayDislike.length');
        });
      }

      // var KEYS = snap.value.keys;
      // var DATA = snap.value;
      // restaurantList.clear();
      // for (var individualKey in KEYS) {
      //   Restaurant restaurant = new Restaurant(DATA[individualKey]['foodType'],
      //       DATA[individualKey]['distanceInMiles']);
      //   restaurantList.add(restaurant);
      // }
      // setState(() {
      //   print('Length: $restaurantList.length');
      // });
    });

    databaseReference
        .child(databaseKey)
        .child('preferences')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          userSelectedItemsArray.add(values["foodType"]);
          userSelectedDistanceArray.add(values["distanceInMiles"]);
          // print(userSelectedItemsArray);
          // print(userSelectedDistanceArray);
          // print(values["foodType"]);
        });
      });
    });

    // getUserStatus(databaseKey);

    // print(userStatus);
    return databaseKey;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _shakePlugin.stopListening();
    initPlatformState();
  }

  @override
  void initState() {
    super.initState();
    getKey();
    initPlatformState();

    foodReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          arrayFoodType.add(values["foodType"]);
          initial = arrayFoodType.first;
        });
      });
    });

    _shakePlugin = FlutterShakePlugin(
      onPhoneShaken: () {
        Vibration.vibrate(duration: 200);
        //do stuff on phone shake
        print('phone shakes');
        showDialog(context: context, builder: (context) => CustomDialog());
      },
      shouldVibrate: true,
      vibrateDuration: 3,
      shakeTimeMS: 2000,
      shakeThresholdGravity: 20,
    )..startListening();
  }

  Future<void> getUserStatus(String keyToRoot) {
    databaseReference.child(keyToRoot).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values["status"] == "active" || values["status"] == "Active") {
        foodReference.once().then((DataSnapshot snapshot) {
          if (arrayFoodType.length == 0) {
            showLoader();
          }
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key, values) {
            setState(() {
              arrayFoodType.add(values["foodType"]);
              initial = arrayFoodType.first;
            });
          });
        });
        _shakePlugin = FlutterShakePlugin(
          onPhoneShaken: () {
            Vibration.vibrate(duration: 200);
            //do stuff on phone shake
            print('phone shakes');
            showDialog(context: context, builder: (context) => CustomDialog());
          },
          shouldVibrate: true,
          vibrateDuration: 3,
          shakeTimeMS: 2000,
          shakeThresholdGravity: 20,
        )..startListening();

        // ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
        //   Toast.show("Phone shaked", context,
        //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        //   showDialog(context: context, builder: (context) => CustomDialog());
        // });
      } else {
        // showLoader();
        userBlocked();
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
  }

  Widget userBlocked() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Text("You're restricted by admin"),
        ),
      ),
    );
  }

  Widget showLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget CustomDialog() {
    print(arrayDislike);
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      var random = new Random();
      int num = random.nextInt(7);
      return !arrayDislike.contains(arrayFoodType[num])
          ? Material(
              type: MaterialType.transparency,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        )
                      ]),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.close),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.settings),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Settings()));
                              },
                            ),
                          ],
                        ),
                        Text(
                          "Random Selection",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('assets/images/mexican.jpg'),
                          // child: Image.network(
                          // imgUrl,
                          // fit: BoxFit.fill,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          arrayFoodType[num],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                print("Dislike");

                                pushInDislike(arrayFoodType[num]);
                                Navigator.of(context).pop();
                                Toast.show(
                                    "${arrayFoodType[num]} is removed from random selection",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              },
                              child: Container(
                                height: 30,
                                width: 60,
                                // color: Colors.blue,
                                child: Image(
                                  image: AssetImage("assets/images/unlike.png"),
                                  fit: BoxFit.contain,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ButtonTheme(
                              height: 30,
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.35,
                              child: RaisedButton(
                                disabledColor: Colors.lightBlue,
                                splashColor: Colors.blue,
                                hoverColor: Colors.blueGrey,
                                //padding: EdgeInsets.only(right: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.blue,

                                child: Text(
                                  'Select',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RestaurantList(
                                          arrayFoodType[num],
                                          defRadius * 800)));
                                  // placesUpdate(_imageIndex, _distanceIndex);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : CustomDialog();
    }
  }

  Widget displayFoodTypeText(String displayText) {
    if (!arrayDislike.contains(displayText)) {
      return Text(
        displayText,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent),
      );
    }
  }

  Future pushInDislike(String dislike) async {
    print(arrayDislike);
    final prefs = await SharedPreferences.getInstance();
    //Return String
    final myString = prefs.getString('my_string_key') ?? 'nooooooo';
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('users').child(myString);
    databaseReference.child("dislikes").push().set({"dislike": dislike});
    setState(() {
      arrayDislike.add(dislike);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      print(multiImei);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    setState(() {
      _platformImei = platformImei;
      uniqueId = idunique;
    });

    Toast.show("IMEI: " + _platformImei + "\nID: " + uniqueId, context,
        gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _platformImei = platformImei;
      uniqueId = idunique;
    });
    getSF(uniqueId, _platformImei);
  }

  Future<void> getSF(String id, String imei) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('distance', "2m");
    String dbKey = preferences.getString('key') ?? 'no_value';

    // print(dbKey + "!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    DatabaseReference restRef = FirebaseDatabase.instance.reference();
//    restaurantList.clear();

    restRef.child("users").child(dbKey).update({'imei': imei, 'device_id': id});
    // return "";
  }
}

/* Future<List<String>> searchNearBy(String keyword) async {
    // AIzaSyAvZwLab_aC75vTPSB8oPCQkeOSYwnCUS4
    var dio = Dio();
    var url = 'http://maps.googleapis.com/maps/api/place/nearbysearch/json';
    var parameters = {
      'key': apiKey,
      'location': '$nycLat,$nycLng',
      'radius': '800',
      'keyword': keyword,
    };
    var response = await dio.get(url);
    return response.data['results']
        .map<String>((result) => result['name'].toString());
    print(response);

    // print();
  }
}
*/
