import 'dart:convert';

import 'package:food_recommendation/models/place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PlaceService {
  static final _service = new PlaceService();

  static PlaceService get() {
    return _service;
  }

  // final Position _position;

  // Future<void> getLocation() async {
  // Position position = await Geolocator()
  // .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // print(position);
  // return position;

  // String locatRion = position.toString();
  // }

  // Future<Position> position =
  // Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // final String searchUrl =
  // "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=24.9687932,67.062136&radius=1000&type=restaurant&key=AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY";
  //"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=24.9687932,67.062136&radius=3500&types=food&name=restaurant&key=AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY";
  // "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&key=AIzaSyAvZwLab_aC75vTPSB8oPCQkeOSYwnCUS4";

  Future getNearbyPlaces(
      double latitude, double longitude, String keyWord, int radius) async {
    print(latitude);
    print(longitude);
    // Future<Position> position =
    // Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final String searchUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=restaurant&keyword=$keyWord&key=AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY";
    var response =
        await http.get(searchUrl, headers: {"Accept": "application/json"});
    var places = <Place>[];
    List data = json.decode(response.body)["results"];

    data.forEach((f) => places.add(new Place(
          f["icon"],
          f["geometry"]["location"]["lat"].toString(),
          f["geometry"]["location"]["lng"].toString(),
          f["name"],
          f["rating"].toString(),
          f["vicinity"],
          f["id"],
        )));
    return places;
  }
}
