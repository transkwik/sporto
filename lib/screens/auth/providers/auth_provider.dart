import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:get_storage/get_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  String? _sessionKey;
  String? get sessionKey => _sessionKey;

  Map<String, dynamic>? _checkResponse;
  Map<String, dynamic>? get checkResponse => _checkResponse;

  void saveCheckResponce(Map<String, dynamic> data) {
    _checkResponse = data;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> sendOtp({
    required String mobileNumber,
    required String countryCode,
  }) async {
    _setLoading(true);
    clearMessages();

    try {
      final params = {
        "mobile_number": mobileNumber,
        "country_code": countryCode,
      };

      final response = await UserApis().getSendOtp(params);

      // Handle custom ApiHelper errors (e.g. No Internet)
      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
        _setLoading(false);
        return false;
      }

      // Handle API Response based on provided payloads
      if (response != null && response['success'] == true) {
        _successMessage = response['message'] ?? 'OTP sent successfully.';
        if (response['data'] != null &&
            response['data']['session_key'] != null) {
          _sessionKey = response['data']['session_key'].toString();
        }
        _setLoading(false);
        return true;
      } else {
        // Parse validation errors
        if (response != null && response['errors'] != null) {
          if (response['errors'] is Map) {
            final errors = response['errors'] as Map<String, dynamic>;
            if (errors.containsKey('mobile_number') &&
                errors['mobile_number'] is List &&
                errors['mobile_number'].isNotEmpty) {
              _errorMessage = errors['mobile_number'][0].toString();
            } else {
              _errorMessage = response['message'] ?? 'Validation failed.';
            }
          } else {
            _errorMessage = response['message'] ?? 'Failed to send OTP.';
          }
        } else {
          _errorMessage = response != null
              ? response['message']
              : 'Failed to send OTP.';
        }

        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _setLoading(false);
      return false;
    }
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    final storage = GetStorage();
    String? deviceId = storage.read('device_id');
    if (deviceId == null) {
      deviceId =
          'DEV-${DateTime.now().millisecondsSinceEpoch}-${math.Random().nextInt(10000)}';
      await storage.write('device_id', deviceId);
    }

    String deviceName = "Unknown Device";
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceName = "${androidInfo.brand} ${androidInfo.model}";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
      }
    } catch (_) {}

    return {"device_name": deviceName, "device_id": deviceId};
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required String mobileNumber,
    required String countryCode,
    required String otp,
  }) async {
    _setLoading(true);
    clearMessages();

    try {
      final deviceInfo = await _getDeviceInfo();

      final params = {
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "otp": otp,
        "device_name": deviceInfo['device_name'],
        "device_id": deviceInfo['device_id'],
        if (_sessionKey != null) "session_key": _sessionKey,
      };

      final response = await UserApis().getVerifyOtp(params);

      // Handle custom ApiHelper errors (e.g. No Internet)
      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
        _setLoading(false);
        return null;
      }

      // Handle API Response
      if (response != null && response['success'] == true) {
        _successMessage = response['message'] ?? 'Login successful.';

        final data = response['data'] as Map<String, dynamic>?;
        if (data != null && data['token'] != null) {
          final storage = GetStorage();
          await storage.write('authToken', data['token']);
        }

        _setLoading(false);
        return data;
      } else {
        // Parse validation errors
        if (response != null && response['errors'] != null) {
          if (response['errors'] is Map) {
            final errors = response['errors'] as Map<String, dynamic>;
            if (errors.containsKey('otp') &&
                errors['otp'] is List &&
                errors['otp'].isNotEmpty) {
              _errorMessage = errors['otp'][0].toString();
            } else {
              _errorMessage = response['message'] ?? 'Validation failed.';
            }
          } else {
            _errorMessage = response['message'] ?? 'Failed to verify OTP.';
          }
        } else {
          _errorMessage = response != null
              ? response['message']
              : 'Failed to verify OTP.';
        }

        _setLoading(false);
        return null;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _setLoading(false);
      return null;
    }
  }
}
