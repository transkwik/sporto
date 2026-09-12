import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/apiServices/user_api.dart';
import '../../auth/providers/location_provider.dart';

class PermissionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> requestPermissionsAndLocation({LocationProvider? locationProvider}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Request Notifications Permission (Non-blocking if denied)
      await Permission.notification.request();

      // 2. Request Location Permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = 'Location services are disabled. Please enable them in settings.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied. We need it to find nearby tournaments.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        _errorMessage = 'Location permissions are permanently denied. Please enable them in app settings.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 3. Fetch Location
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      // 4. Update API
      final params = {
        "latitude": position.latitude,
        "longitude": position.longitude
      };

      final response = await UserApis().updateLatLong(params);

      if (response != null && (response['success'] == true || response['details'] != null)) {
        // Reverse Geocode
        String address = "Unknown Location";
        try {
          List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks.first;
            String subLocality = place.subLocality ?? '';
            String locality = place.locality ?? '';
            String adminArea = place.administrativeArea ?? '';
            
            List<String> parts = [];
            if (subLocality.isNotEmpty) parts.add(subLocality);
            if (locality.isNotEmpty) parts.add(locality);
            if (parts.isEmpty && adminArea.isNotEmpty) parts.add(adminArea);
            
            if (parts.isNotEmpty) {
              address = parts.join(", ");
            }
          }
        } catch (e) {
          debugPrint("Geocoding error: $e");
        }

        locationProvider?.setLocation(position, address);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response?['message'] ?? response?['error'] ?? 'Failed to update location on server.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch location: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
