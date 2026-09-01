import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sporto/core/apiServices/api_constants.dart';

final storage = GetStorage();

class ApiHelper {
  static bool _isSessionExpired = false;

  /// ================= SESSION EXPIRED =================
  Future<void> handleSessionExpired() async {
    if (_isSessionExpired) return;

    _isSessionExpired = true;

    await storage.remove('authToken');

    log("Session Expired - User Logged Out");
  }

  /// ================= STATUS CHECK =================
  Future<bool> _handleResponseStatus(int statusCode) async {
    if (statusCode == 401 || statusCode == 403) {
      await handleSessionExpired();
      return false;
    }

    return true;
  }

  /// ================= POST API =================
  Future<dynamic> getTypePost(String uri, Map<String, String> params) async {
    var authCode = storage.read('authToken');

    log("AUTH TOKEN -> $authCode");

    var url = Uri.parse(apiBaseUrl + uri);

    var request = http.MultipartRequest('POST', url);

    request.fields.addAll(params);

    request.headers.addAll({
      'Authorization': 'Bearer $authCode',
      'Content-Type': 'multipart/form-data',
    });

    log('URL -> ${apiBaseUrl + uri}');
    log('PARAMS -> $params');

    try {
      http.StreamedResponse response = await request.send();

      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        return {
          'session_expired': true,
          'message': 'Session expired',
          'errorRes': json.decode(jsonResponse),
        };
      }

      return json.decode(jsonResponse);
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  /// ================= POST JSON API =================
  Future<dynamic> getTypePostJson(
    String uri,
    Map<String, dynamic> params,
  ) async {
    var authCode = storage.read('authToken');

    log("AUTH TOKEN -> $authCode");

    var url = apiBaseUrl + uri;
    log('URL -> $url');

    var request = http.Request('POST', Uri.parse(url));

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authCode != null && authCode.toString().isNotEmpty) {
      headers['Authorization'] = 'Bearer $authCode';
    }

    request.headers.addAll(headers);
    request.body = json.encode(params);

    log('BODY -> ${request.body}');

    try {
      http.StreamedResponse response = await request.send();
      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        return {
          'session_expired': true,
          'message': 'Session expired',
          'errorRes': json.decode(jsonResponse),
        };
      }

      return json.decode(jsonResponse);
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  /// ================= DELETE API =================
  Future<dynamic> getTypeDelete(String uri) async {
    var authCode = storage.read('authToken');
    log("AUTH TOKEN -> $authCode");

    var url = apiBaseUrl + uri;
    log('URL -> $url');

    var request = http.Request('DELETE', Uri.parse(url));

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authCode != null && authCode.toString().isNotEmpty) {
      headers['Authorization'] = 'Bearer $authCode';
    }

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        return {
          'session_expired': true,
          'message': 'Session expired',
          'errorRes': json.decode(jsonResponse),
        };
      }

      return json.decode(jsonResponse);
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  /// ================= PUT JSON API =================
  Future<dynamic> getTypePutJson(
    String uri,
    Map<String, dynamic> params,
  ) async {
    var authCode = storage.read('authToken');

    log("AUTH TOKEN -> $authCode");

    var url = apiBaseUrl + uri;
    log('URL -> $url');

    var request = http.Request('PUT', Uri.parse(url));

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (authCode != null && authCode.toString().isNotEmpty) {
      headers['Authorization'] = 'Bearer $authCode';
    }

    request.headers.addAll(headers);
    request.body = json.encode(params);

    log('BODY -> ${request.body}');

    try {
      http.StreamedResponse response = await request.send();
      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        return {
          'session_expired': true,
          'message': 'Session expired',
          'errorRes': json.decode(jsonResponse),
        };
      }

      return json.decode(jsonResponse);
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  /// ================= GET API =================
  Future<dynamic> getTypeGet(String uri) async {
    var authCode = storage.read('authToken');

    Map<String, String> headers = {
      'Authorization': 'Bearer $authCode',
      'Content-Type': 'application/json',
    };

    var url = apiBaseUrl + uri;

    log('URL -> $url');
    log('AUTH TOKEN -> $authCode');

    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        return {
          'session_expired': true,
          'message': 'Session expired',
          'errorRes': json.decode(jsonResponse),
        };
      }

      return json.decode(jsonResponse);
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  /// ================= GET DIFFERENT BASE URL =================
  Future<dynamic> getTypeGetDiffUrl(String uri) async {
    var authCode = storage.read('authToken');

    Map<String, String> headers = {
      'Authorization': 'Bearer $authCode',
      'Content-Type': 'application/json',
    };

    var url = apiBaseUrl + uri;

    log('URL -> $url');
    log('AUTH TOKEN -> $authCode');

    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        return {
          'session_expired': true,
          'message': 'Session expired',
          'errorRes': json.decode(jsonResponse),
        };
      }

      return json.decode(jsonResponse);
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  /// ================= GET API ABSOLUTE URL =================
  Future<dynamic> getTypeGetAbsoluteUrl(String fullUrl) async {
    var authCode = storage.read('authToken');

    Map<String, String> headers = {
      'Authorization': 'Bearer $authCode',
      'Content-Type': 'application/json',
    };

    log('URL -> $fullUrl');
    log('AUTH TOKEN -> $authCode');

    var request = http.Request('GET', Uri.parse(fullUrl));

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        return {
          'session_expired': true,
          'message': 'Session expired',
          'errorRes': json.decode(jsonResponse),
        };
      }

      return json.decode(jsonResponse);
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  /// ================= POST API ABSOLUTE URL =================
  Future<dynamic> getTypePostAbsoluteUrl(
    String fullUrl, [
    Map<String, dynamic>? params,
  ]) async {
    var authCode = storage.read('authToken');

    log("AUTH TOKEN -> $authCode");
    log('URL -> $fullUrl');

    var request = http.Request('POST', Uri.parse(fullUrl));

    request.headers.addAll({
      'Authorization': 'Bearer $authCode',
      'Content-Type': 'application/json',
    });
    log('BODY -> ${params}');
    if (params != null && params.isNotEmpty) {
      request.body = json.encode(params);
      log('BODY -> ${json.encode(params)}');
    }

    try {
      http.StreamedResponse response = await request.send();

      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        return {
          'session_expired': true,
          'message': 'Session expired',
          'errorRes': json.decode(jsonResponse),
        };
      }

      return json.decode(jsonResponse);
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  /// ================= UPLOAD FILE API =================
  Future<dynamic> uploadFile(
    String fullUrl,
    Map<String, String> fields,
    String filePath, {
    String fileField = 'file',
  }) async {
    var authCode = storage.read('authToken');
    log("AUTH TOKEN -> $authCode");
    log('URL -> $fullUrl');
    log('FIELDS -> $fields');

    var request = http.MultipartRequest('POST', Uri.parse(fullUrl));
    request.fields.addAll(fields);

    if (authCode != null && authCode.toString().isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $authCode';
    }
    request.headers['Accept'] = 'application/json';

    try {
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));

      http.StreamedResponse response = await request.send();
      var jsonResponse = await response.stream.bytesToString();

      log('STATUS CODE -> ${response.statusCode}');
      log('RESPONSE -> $jsonResponse');

      if (response.statusCode == 413) {
        return {
          'success': false,
          'message': 'Image is too large. Please select a smaller file.',
        };
      }

      bool isValid = await _handleResponseStatus(response.statusCode);

      if (!isValid) {
        try {
          return {
            'session_expired': true,
            'message': 'Session expired',
            'errorRes': json.decode(jsonResponse),
          };
        } catch (_) {
          return {'success': false, 'message': 'Session expired'};
        }
      }

      try {
        return json.decode(jsonResponse);
      } catch (e) {
        return {
          'success': false,
          'message': 'Server returned an invalid response. Please try again.',
        };
      }
    } on SocketException {
      return {'error': 'No Internet Connection'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }
}
