import 'dart:async';
import 'package:carousel_slider/utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/screens/restaurant_list.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'direction_service.dart';
import 'package:food_recommendation/models/direction_model.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Direction extends StatefulWidget {
  String keyWord;
  int distance;
  String name;
  double originLat;
  double originLng;
  double latitude;
  double longitude;
  Direction(this.keyWord, this.distance, this.name, this.originLat,
      this.originLng, this.latitude, this.longitude);

  @override
  _DirectionState createState() => _DirectionState(this.keyWord, this.distance,
      this.name, this.originLat, this.originLng, this.latitude, this.longitude);
}

class _DirectionState extends State<Direction> {
  String keyWord;
  int distance;
  String name;
  double originLat;
  double originLng;
  double latitude;
  double longitude;
  _DirectionState(this.keyWord, this.distance, this.name, this.originLat,
      this.originLng, this.latitude, this.longitude);
  // GoogleMapController _controller;
  // final Set<Polyline> _polyLines = {};
  // DirectionModel _directionModel;
  // List<LatLng> routeCoords;
  // GoogleMapPolyline googleMapPolyline =
  //     new GoogleMapPolyline(apiKey: "AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY");

  GoogleMapController _controller;
  Set<Polyline> polyline = {};
  Polyline _polyline;
  Set<Marker> markers = {};
  List<LatLng> routeCoords;
  bool isLoading;
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY");
  PolylinePoints points = new PolylinePoints();
  List<PointLatLng> result;
  Polyline routes;
  Polyline direction;
  Dio dio;
  DatabaseReference database =
      FirebaseDatabase.instance.reference().child("users");
  String databaseKey;
  int defRadius;
  String defaultRadius;

  // this will hold each polyline coordinate as Lat and Lng pairs
  // String googleAPIKey = "AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY";

  Future getRadius() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('distance', "2m");
    databaseKey = preferences.getString('key') ?? 'no_value';
    database.child(databaseKey).once().then((DataSnapshot snapshot) {
      setState(() {
        defaultRadius = snapshot.value["default_radiius"];
        defaultRadius = defaultRadius.replaceAll(" miles", "");

        defRadius = int.parse(defaultRadius);
      });
      print(defRadius);
    });
  }

  @override
  initState() {
    super.initState();
    // getDirection();
    // sendRequest();
    getRadius();
  }

  sendRequest() async {
    String direction = await DirectionService.get()
        .getLocationDirection(originLat, originLng, latitude, longitude);
    if (direction == null) {
      return CircularProgressIndicator();
    } else {
      List<PointLatLng> result = points.decodePolyline(direction);
      List<LatLng> po = [];
      result.forEach((f) {
        po.add(LatLng(f.latitude, f.longitude));
      });

      _polyline = new Polyline(
        polylineId: PolylineId("route"),
        geodesic: true,
        startCap: Cap.buttCap,
        endCap: Cap.roundCap,
        visible: true,
        points: po,
        width: 4,
        color: Colors.blue,
      );
      Marker marker = Marker(
        markerId: MarkerId("Destination"),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: name,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      markers.add(marker);

      polyline.add(_polyline);
    }
    // Toast.show(direction, context,
    //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    // print(direction);

    //print(po);

    // _decodePoly(direction);
    // getPolyline(direction);
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    // _convertToLatLng(1List);
    return lList;
  }

  getPolyline(dynamic direction) {
    result = points.decodePolyline(direction);
    List<LatLng> po = [];
    result.forEach((f) {
      po.add(LatLng(f.latitude, f.longitude));
    });
    routes = new Polyline(
        polylineId: PolylineId("route1"),
        geodesic: true,
        points: _convertToLatLng(_decodePoly(direction)),
        width: 20,
        color: Colors.blue);
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    print(result);
    return result;
  }

  getDirection() async {
    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(latitude, longitude),
        destination: LatLng(originLat, originLng),
        mode: RouteMode.driving);

    direction = new Polyline(
        polylineId: PolylineId("route1"),
        geodesic: true,
        points: routeCoords,
        width: 4,
        color: Colors.blue);

    Toast.show(direction.toString(), context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    polyline.add(direction);

    print(latitude);
    print(longitude);
    // String route =
  }

  Future<bool> _onWillPop() {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => RestaurantList(keyWord, distance)),
        (Route<dynamic> route) => true);
  }

  PickResult selectedPlace;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search places",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            } else if (!_searchQueryController.text.isEmpty) {
              // Toast.show(distance.toString(), context,
              //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              String searchWord = _searchQueryController.text;

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      RestaurantList(searchWord, defRadius * 800)));
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    Toast.show("Search ", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: false,
      child: Scaffold(
        appBar: AppBar(
          leading: _isSearching ? const BackButton() : const BackButton(),
          title: _isSearching ? _buildSearchField() : Text("Direction"),
          centerTitle: false,
          actions: _buildActions(),
        ),
        // drawer: PlacePicker(
        //   apiKey: "AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY",
        //   initialPosition: LatLng(latitude, longitude),
        //   useCurrentLocation: true,
        //   selectInitialPosition: true,
        //   onMapCreated: onMapCreated,
        //   desiredLocationAccuracy: LocationAccuracy.high,

        //   //usePlaceDetailSearch: true,
        //   onPlacePicked: (result) {
        //     selectedPlace = result;
        //     Navigator.of(context).pop();
        //     setState(() {});
        //   },
        // ),
        body: SafeArea(
          child: Container(
            //height: 200,
            child: GoogleMap(
              mapToolbarEnabled: true,

              // liteModeEnabled: true,
              // polylines: _polyLines,
              onMapCreated: onMapCreated,
              // compassEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              scrollGesturesEnabled: true,
              // trafficEnabled: false,
              // tiltGesturesEnabled: false,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              padding: EdgeInsets.all(10),
              zoomControlsEnabled: false,
              indoorViewEnabled: true,
              // mapToolbarEnabled: true,

              initialCameraPosition: CameraPosition(
                target: LatLng(originLat, originLng),
                zoom: 18.0,
              ),
              markers: markers != null ? Set<Marker>.from(markers) : null,
              mapType: MapType.normal,
              polylines: polyline,

              // polylines: ,

              // polylines: polyline != null ? Set<Polyline>.from(polyline) : null,
            ),
          ),
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      isLoading = true;
    });
    // Response response = await dio.get(
    // 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$originLat,$originLng&destinations=$latitude,$longitude&key=AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY');
    // print(response.data);
    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(originLat, originLng),
        destination: LatLng(latitude, longitude),
        mode: RouteMode.driving);

    Marker marker = Marker(
      markerId: MarkerId(name),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: name,
        snippet: name,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    direction = new Polyline(
        polylineId: PolylineId("route1"),
        geodesic: true,
        points: routeCoords,
        width: 6,
        color: Colors.redAccent);
    setState(() {
      _controller = controller;
      polyline.add(direction);
      markers.add(marker);
      isLoading = false;
    });
  }
}
