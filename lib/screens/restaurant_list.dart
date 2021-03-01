import 'package:flutter/material.dart';
import 'package:food_recommendation/models/place_model.dart';
import 'package:food_recommendation/services/Direction.dart';
import 'package:food_recommendation/services/place_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_star_rating/flutter_star_rating.dart';

class RestaurantList extends StatefulWidget {
  String keyWord;
  int distance;
  RestaurantList(this.keyWord, this.distance);
  // String keyWord;
  // String distance;
  // RestaurantList(this.keyWord, this.distance);

  @override
  _RestaurantListState createState() =>
      _RestaurantListState(this.keyWord, this.distance);
}

class _RestaurantListState extends State<RestaurantList> {
  String keyWord;
  int distance;
  List<Place> _places;
  _RestaurantListState(this.keyWord, this.distance);

  Future<void> getLocation(String keyWord, int distance) async {}

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);
      PlaceService.get()
          .getNearbyPlaces(
              position.latitude, position.longitude, keyWord, (distance))
          .then((data) {
        this.setState(() {
          _places = data;
        });
      });
    } catch (e) {
      Toast.show(e.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future getPhotos() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPhotos();

    getCurrentLocation();

    // getLocation();
  }

  Widget _createContent(String keyWord, int radius) {
    if (_places == null) {
      return new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20),
          ],
        ),
      );
    } else {
      print(_places);

      return CustomList();
    }
  }

  Widget CustomList() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return _places.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "No Restaurants Found",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : new ListView(
              children: <Widget>[
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: _places.map((f) {
                    return GestureDetector(
                      child: Container(
                        // margin: EdgeInsets.all(7),
                        // height: 10,
                        child: Card(
                          // shadowColor: Colors.grey,
                          // semanticContainer: true,

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage: ExactAssetImage(
                                        'assets/images/restaurant_logo.png',
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      f.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Text(f.vicinity),
                                    StarRating(
                                      rating: double.parse(f.rating),
                                      spaceBetween: 1,
                                      starConfig: StarConfig(
                                        fillColor: Colors.yellowAccent,
                                        size: 20,
                                        strokeWidth: 2,
                                        strokeColor: Colors.yellow,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                                f.name,
                                double.parse(f.rating),
                                f.vicinity,
                                f.latitude,
                                f.longitude));
                      },
                    );
                  }).toList(),
                )
              ],
            );
    } else {
      return _places.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "No Restaurants Found",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : new ListView(
              children: <Widget>[
                // Container(
                //   color: Colors.red,
                //   height: 50.0,
                // ),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: _places.map((f) {
                    return GestureDetector(
                      child: Container(
                        margin: EdgeInsets.all(7),
                        // height: 10,
                        child: Card(
                          // shadowColor: Colors.grey,
                          // semanticContainer: true,

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: ExactAssetImage(
                                      'assets/images/restaurant_logo.png',
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    f.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Text(f.vicinity),
                                  StarRating(
                                    rating: double.parse(f.rating),
                                    spaceBetween: 1,
                                    starConfig: StarConfig(
                                      fillColor: Colors.yellowAccent,
                                      size: 20,
                                      strokeWidth: 2,
                                      strokeColor: Colors.yellow,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                                f.name,
                                double.parse(f.rating),
                                f.vicinity,
                                f.latitude,
                                f.longitude));
                      },
                    );
                  }).toList(),
                )
              ],
            );
    }
  }

  Widget CustomDialog(String name, double ratings, String address,
      String latitude, String longitude) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.90,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 5,
                    left: 16,
                    right: 16,
                  ),
                  margin: EdgeInsets.only(),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        )
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                        backgroundImage:
                            AssetImage("assets/images/restaurant_logo.png"),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        name,
                        // textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: StarRating(
                          rating: ratings,
                          spaceBetween: 1,
                          starConfig: StarConfig(
                            fillColor: Colors.yellowAccent,
                            size: 22,
                            strokeWidth: 0,
                            strokeColor: Colors.yellowAccent,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        address,
                        // textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            child: Expanded(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/arrowBackword.png',
                                    width: 50,
                                    height: 30,
                                  ),
                                  Text(
                                    "No way",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              // CustomDialog(CustomDialog.pop());
                            },
                          ),
                          Spacer(),
                          GestureDetector(
                            child: Expanded(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/arrowForward.png',
                                    width: 50,
                                    height: 30,
                                  ),
                                  Text(
                                    "Let\'s Go!!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              Position position = await Geolocator()
                                  .getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high);
                              // LatLng start = new LatLng(
                              // position.latitude, position.longitude);
                              double destLat = double.parse(latitude);
                              double destLng = double.parse(longitude);
                              // LatLng destination = new LatLng(destLat, destLng);
                              // Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Direction(
                                        keyWord,
                                        distance,
                                        name,
                                        position.latitude,
                                        position.longitude,
                                        // double.parse(position.latitude),
                                        // double.parse(position.longitude),
                                        destLat,
                                        destLng)),
                              );

                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => Direction(
                              //         name,
                              //         position.latitude,
                              //         position.longitude,
                              //         // double.parse(position.latitude),
                              //         // double.parse(position.longitude),
                              //         destLat,
                              //         destLng),
                              //   ),
                              // );
                              // CustomDialog(CustomDialog.pop());
                            },
                          ),
                        ],
                      ),

                      // Text(
                      //   'Popup',
                      //   style: TextStyle(
                      //       fontSize: 22,
                      //       fontWeight: FontWeight.w500,
                      //       color: Colors.white),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 5,
                    left: 16,
                    right: 16,
                  ),
                  margin: EdgeInsets.only(),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        )
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 60,
                        backgroundImage:
                            AssetImage("assets/images/restaurant_logo.png"),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        name,
                        // textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: StarRating(
                          rating: ratings,
                          spaceBetween: 1,
                          starConfig: StarConfig(
                            fillColor: Colors.yellowAccent,
                            size: 24,
                            strokeWidth: 0,
                            strokeColor: Colors.yellowAccent,
                          ),
                        ),
                      ),
                      Text(
                        address,
                        // textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            child: Expanded(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/arrowBackword.png',
                                    width: 50,
                                    height: 30,
                                  ),
                                  Text(
                                    "No way",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              // CustomDialog(CustomDialog.pop());
                            },
                          ),
                          Spacer(),
                          GestureDetector(
                            child: Expanded(
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/arrowForward.png',
                                    width: 50,
                                    height: 30,
                                  ),
                                  Text(
                                    "Let\'s Go!!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              Position position = await Geolocator()
                                  .getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high);
                              // LatLng start = new LatLng(
                              // position.latitude, position.longitude);
                              double destLat = double.parse(latitude);
                              double destLng = double.parse(longitude);
                              // LatLng destination = new LatLng(destLat, destLng);
                              // Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Direction(
                                      keyWord,
                                      distance,
                                      name,
                                      position.latitude,
                                      position.longitude,
                                      // double.parse(position.latitude),
                                      // double.parse(position.longitude),
                                      destLat,
                                      destLng),
                                ),
                              );
                              // CustomDialog(CustomDialog.pop());
                            },
                          ),
                        ],
                      ),

                      // Text(
                      //   'Popup',
                      //   style: TextStyle(
                      //       fontSize: 22,
                      //       fontWeight: FontWeight.w500,
                      //       color: Colors.white),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
  // children: _places.map((f) {
  //   return new GridView.count(
  //     crossAxisCount: 2,
  //     // mainAxisSpacing: 2,
  //     children: <Widget>[
  //       Center(
  //         child: GestureDetector(
  //           child: Card(
  //             // width: 10,
  //             child: Container(
  //               padding: EdgeInsets.all(5),
  //               // child: Row(
  //               // children: <Widget>[
  //               // Column(
  //               // children: <Widget>[
  //               child: Column(
  //                 children: <Widget>[
  //                   Center(
  //                       child: Image.asset(
  //                     "assets/images/icon.jpg",
  //                     fit: BoxFit.contain,
  //                   )
  //                       // ),
  //                       // ],
  //                       ),
  //                   SizedBox(height: 10),
  //                   Text(
  //                     f.name,
  //                     style: TextStyle(
  //                         fontSize: 16, fontWeight: FontWeight.bold),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   Text(
  //                     f.rating,
  //                     style: TextStyle(
  //                         fontSize: 16, fontWeight: FontWeight.bold),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ],
  //               ),
  //               // ],
  //             ),
  //           ),
  //         ),
  //         // ),
  //       ),
  //     ],
  //     // title: new Text(f.name),
  //     // leading: new Image.network(f.icon),
  //     // subtitle: new Text(f.rating),
  //     // trailing: new Text(f.vicinity),
  //   );
  // }).toList(),
  // );
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(keyWord),
      ),
      body: Center(
        child: _createContent(
          keyWord,
          distance,
        ),
      ),
    );
  }
}
