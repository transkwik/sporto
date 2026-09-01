import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _address = "Unknown location";

  double get latitude => _latitude;
  double get longitude => _longitude;
  String get address => _address;

  void setLocation(Position position, String address) {
    _latitude = position.latitude;
    _longitude = position.longitude;
    _address = address;
    notifyListeners();
  }
}
