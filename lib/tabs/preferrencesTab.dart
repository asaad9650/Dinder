import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recommendation/screens/home_screen.dart';
import 'package:food_recommendation/screens/login_screen.dart';
import 'package:food_recommendation/screens/restaurant_list.dart';
import 'package:food_recommendation/tabs/mainTab.dart';
import 'package:food_recommendation/userOrAdmin.dart';
import 'restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PreferrencesTab extends StatefulWidget {
  @override
  _PreferrencesTabState createState() => _PreferrencesTabState();
}

class _PreferrencesTabState extends State<PreferrencesTab> {
  // Future<Position> position =
  // Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // static var type;
  // String type;

  List<Restaurant> restaurantList = [];

  FirebaseAuth auth = FirebaseAuth.instance;

  // String dbKey;
  Future<String> getSF() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('distance', "2m");
    String dbKey = preferences.getString('key') ?? 'no_value';

    // print(dbKey + "!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    DatabaseReference restRef = FirebaseDatabase.instance.reference();
//    restaurantList.clear();

    restRef
        .child("users")
        .child(dbKey)
        .child("preferences")
        .once()
        .then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      // print(DATA);

      for (var individualKey in KEYS) {
        Restaurant restaurant = new Restaurant(DATA[individualKey]['foodType'],
            DATA[individualKey]['distanceInMiles']);
        restaurantList.add(restaurant);
      }
      setState(() {
        print('Length: $restaurantList.length');
      });
      // if (values["status"] == "active" || values["status"] == "Active") {
      //   restRef
      //       .child("users")
      //       .child(dbKey)
      //       .child("preferences")
      //       .once()
      //       .then((DataSnapshot snap) {
      //     var KEYS = snap.value.keys;
      //     var DATA = snap.value;
      //     // print(DATA);

      //     for (var individualKey in KEYS) {
      //       Restaurant restaurant = new Restaurant(
      //           DATA[individualKey]['foodType'],
      //           DATA[individualKey]['distanceInMiles']);
      //       restaurantList.add(restaurant);
      //     }
      //     setState(() {
      //       print('Length: $restaurantList.length');
      //     });
      //   });
      // } else {
      //   final snackBar = SnackBar(
      //     content: Text(
      //         'You are restricted by admin. Please contact recommendation.food@gmail.com for further queries.'),
      //     action: SnackBarAction(
      //       label: "Ok",
      //       onPressed: () {
      //         auth.signOut();
      //         Navigator.of(context).pushAndRemoveUntil(
      //             MaterialPageRoute(builder: (context) => LoginScreen()),
      //             (route) => false);
      //       },
      //     ),
      //   );
      //   Scaffold.of(context).showSnackBar(snackBar);
      // }
    });

    return dbKey;
  }

  @override
  void initState() {
    super.initState();
    getSF();
  }

  Future<bool> _onWillPop() async {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: restaurantList.length == 0
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Text(
                      "No items found to load",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ))
              : CheckOrientation(),
        ),
      ),
    );
  }

  Widget CheckOrientation() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return new GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        children: List.generate(restaurantList.length, (index) {
          return RestaurantUI(restaurantList[index].foodType,
              restaurantList[index].distanceInMiles);
        }),
        // new ListView.builder(
        // itemCount: restaurantList.length,
        // itemBuilder: (_, index) {
        // return RestaurantUI(restaurantList[index].foodType,
        // restaurantList[index].distanceInMiles);
        // },
        // ),
        // ],
      );
    } else {
      return new GridView.count(
        shrinkWrap: false,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 0,
        children: List.generate(restaurantList.length, (index) {
          return RestaurantUI(restaurantList[index].foodType,
              restaurantList[index].distanceInMiles);
        }),
        // new ListView.builder(
        // itemCount: restaurantList.length,
        // itemBuilder: (_, index) {
        // return RestaurantUI(restaurantList[index].foodType,
        // restaurantList[index].distanceInMiles);
        // },
        // ),
        // ],
      );
    }
  }

  Widget RestaurantUI(String foodType, String distanceInMiles) {
    // return Table(
    //   children: <TableRow>[
    //     TableRow(children: <Widget>[
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Container(
    //             child: Card(
    //                 child: Text(
    //               foodType,
    //               style: Theme.of(context).textTheme.subtitle1,
    //               textAlign: TextAlign.center,
    //             )),
    //           )
    //         ],
    //       )
    //     ])
    //   ],
    // );
    return new Container(
      // height: 100,
      // height: MediaQuery.of(context).size.height * 0.01,
      // width: MediaQuery.of(context).size.height * 0.1,
      child: Center(
        child: GestureDetector(
          child: Card(
            // width: 10,
            child: Container(
              // height: 250,
              padding: EdgeInsets.all(0),
              // child: Row(
              // children: <Widget>[
              // Column(
              // children: <Widget>[
              child: Column(
                children: <Widget>[
                  Center(
                      child: Image.asset(
                    "assets/images/icon.jpg",
                    fit: BoxFit.contain,
                  )
                      // ),
                      // ],
                      ),
                  SizedBox(height: 5),
                  Text(
                    foodType,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    distanceInMiles + " miles",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              // ],
            ),
          ),
          onTap: () {
            Toast.show(foodType + " " + distanceInMiles + " miles", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            int dst = int.parse(distanceInMiles);
            dst = dst * 800;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RestaurantList(foodType, dst)));
          },
        ),
        // ),
      ),
    );
    // return new Card(
    //   elevation: 8.0,
    //   margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    //   child: Container(
    //     decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    //     margin: EdgeInsets.all(10.0),
    //     child: new Text(
    //       foodType,
    //       style: Theme.of(context).textTheme.subtitle1,
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    // );
  }
}
