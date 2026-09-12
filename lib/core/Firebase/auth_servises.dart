import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // ignore: body_might_complete_normally_nullable
  Future<String?> getAccessToken() async {
    try {
      // Load the service account key JSON from your assets
      final String serviceAccountJson = await rootBundle.loadString(
        'assets/firebase/sporto_firebase.json',
      );
      // Decode the JSON into a Map
      final Map<String, dynamic> accountCredentials = json.decode(
        serviceAccountJson,
      );
      // Create ServiceAccountCredentials from the decoded Map
      final credentials = ServiceAccountCredentials.fromJson(
        accountCredentials,
      );
      const scopes = ['https://www.googleapis.com/auth/cloud-platform'];
      // Create an HTTP client
      final client = http.Client();
      try {
        // Obtain access credentials using the service account credentials
        final accessCredentials =
            await obtainAccessCredentialsViaServiceAccount(
              credentials,
              scopes,
              client,
            );
        log('Access token: ${accessCredentials.accessToken.data}');
        return accessCredentials.accessToken.data;
      } catch (e) {
        log('Error obtaining the access token: $e');
      } finally {
        client.close(); // Close the client
      }
    } catch (e) {
      log('Error getting access token: $e');
      return null;
    }
  }
}
