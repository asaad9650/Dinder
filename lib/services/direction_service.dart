import 'dart:convert';

import 'package:food_recommendation/models/place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:food_recommendation/models/direction_model.dart';

class DirectionService {
  static final _direction = new DirectionService();
  static DirectionService get() {
    return _direction;
  }

  Future<String> getLocationDirection(double originLat, double originLng,
      double destLat, double destLng) async {
    final String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$destLat,$destLng&key=AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY";
    // "https://maps.googleapis.com/maps/api/directions/json?origin=${position.latitude},${position.latitude}&destination=$destLat,$destLng&key=AIzaSyC6LcWmDXlVWalT7v0wy89QQBK_8TKPoBY";
    // http.Response response = await http.get(directionUrl);
    http.Response response = await http.get(directionUrl);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}
