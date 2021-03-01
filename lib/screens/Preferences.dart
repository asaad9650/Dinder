import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/tabs/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  List<Restaurant> restaurantList = [];
  String updatedName;
  String oldName;
  String updatedDistance;
  String key;
  TextEditingController textEditingController;
  // String dbKey;
  Future<String> getSF() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('distance', "2m");
    String dbKey = preferences.getString('key') ?? 'no_value';
    key = dbKey;
    // print(dbKey + "!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    DatabaseReference restRef = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(dbKey)
        .child("preferences");

    restRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      restaurantList.clear();
      for (var individualKey in KEYS) {
        Restaurant restaurant = new Restaurant(DATA[individualKey]['foodType'],
            DATA[individualKey]['distanceInMiles']);
        restaurantList.add(restaurant);
      }
      setState(() {
        print('Length: $restaurantList.length');
      });
    });

    return dbKey;
  }

  save(String _name, String _oldName, String _distance) {
    DatabaseReference myRef = FirebaseDatabase.instance.reference();
    DatabaseReference renameRef = FirebaseDatabase.instance.reference();
    myRef
        .child("users")
        .child(key)
        .child("preferences")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((keys, values) {
        if (values["foodType"] == _oldName &&
            values["distanceInMiles"] == _distance) {
          renameRef
              .child("users")
              .child(key)
              .child("preferences")
              .child(keys)
              .update({'foodType': _name});
        }

        // if (values["name"] == name) {
        //   // reference.child(key).remove();

        // }
      });
    });

    // DatabaseReference restRef = FirebaseDatabase.instance
    //     .reference()
    //     .child("users")
    //     .child(key)
    //     .child("preferences")
    //     .once()
    //     .then((value) => null);

    // restRef.update({'foodType': _name});
  }

  @override
  void initState() {
    super.initState();
    getSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferences"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              save(updatedName, oldName, updatedDistance);
              // do something
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: restaurantList.length == 0
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    "No items found to load",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                ],
              ))
            : CheckOrientation(),
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
      );
    } else {
      return new GridView.count(
        shrinkWrap: true,
        // physics: ,
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

  void _onEditingComplete() {
    save(updatedName, oldName, updatedDistance);
  }

  Widget RestaurantUI(String foodType, String distanceInMiles) {
    return new Container(
      // height: 100,
      height: MediaQuery.of(context).size.height * 0.4,
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
              child: SingleChildScrollView(
                child: Form(
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
                      TextFormField(
                        maxLines: 1,
                        controller: textEditingController,
                        initialValue: foodType,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        autovalidate: true,
                        textCapitalization: TextCapitalization.words,
                        onEditingComplete: _onEditingComplete,
                        onChanged: (value) {
                          if (value.length > 0) {
                            print(value);
                            updatedName = value;
                            oldName = foodType;
                            updatedDistance = distanceInMiles;
                            // textEditingController.addListener(() {
                            //   setState(() {
                            //     updatedName = value;
                            //     save(updatedName, foodType, distanceInMiles);
                            //   });
                            // });
                          }
                        },
                        onSaved: (value) {
                          if (value.length > 0) {
                            updatedName = value;
                            oldName = foodType;
                            updatedDistance = distanceInMiles;
                          }
                        },
                        validator: (value) {
                          if (value.length < 1) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                      ),
                      // Text(
                      //   foodType,
                      //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      //   textAlign: TextAlign.center,
                      // ),
                      SizedBox(height: 5),
                      TextFormField(
                        maxLines: 1,
                        readOnly: true,
                        initialValue: distanceInMiles + " miles",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        autovalidate: true,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value.length < 1) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          updatedDistance = value;
                        },
                        onSaved: (value) {
                          updatedDistance = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // ],
            ),
          ),
          onTap: () {
            // showDialog(
            //     context: context,
            //     builder: (context) => customDialog(foodType, distanceInMiles));
            Toast.show(foodType + " " + distanceInMiles + " miles", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            int dst = int.parse(distanceInMiles);
            dst = dst * 400;
            // Navigator.of(context).push(MaterialPageRoute(
            // builder: (context) => RestaurantList(foodType, dst)));
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) => customDialog(foodType, distanceInMiles));
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

  Widget customDialog(String foodtype, String dstInMile) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.55,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  )
                ]),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      foodtype + " " + dstInMile,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Delete"),
                    onTap: () {
                      deleteUser(foodtype, dstInMile);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: Text("Close"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // ListTile(),
                ],
              ),
            ),
          ),
        ));
  }

  void deleteUser(String type, String distance) {
    DatabaseReference myRef = FirebaseDatabase.instance.reference();
    DatabaseReference deleteRef = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(key)
        .child("preferences");

    myRef
        .child("users")
        .child(key)
        .child("preferences")
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((keys, values) {
        // restaurantList.clear();
        if (values["foodType"] == type &&
            values["distanceInMiles"] == distance) {
          print(type);
          print(distance);
          print(values["foodType"]);
          deleteRef.child(keys).remove();
          restaurantList.clear();
          setState(() {
            getSF();
            // restaurantList.remove(value)
          });
        }
      });
    });

    Toast.show("Deleted, " + type + " " + distance.toString(), context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    // myRef
    //     .child("users")
    //     .child(key)
    //     .child("preferences")
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   Map<dynamic, dynamic> values = snapshot.value;
    //   values.forEach((keys, values) {
    //     if (values["foodType"] == type &&
    //         values["distanceInMiles"] == distance) {
    //       renameRef
    //           .child("users")
    //           .child(key).remove();
  }
}

//  style: Theme.of(context).textTheme.subtitle1,
//       textAlign: TextAlign.center,
//     ),
//   ),
// );
// }
// }
