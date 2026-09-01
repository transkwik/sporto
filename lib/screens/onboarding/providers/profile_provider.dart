import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/apiServices/user_api.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUploadingPhoto = false;
  bool get isUploadingPhoto => _isUploadingPhoto;

  String? _uploadedPhotoUrl;
  String? get uploadedPhotoUrl => _uploadedPhotoUrl;

  String? _uploadedPhotoPath;
  String? get uploadedPhotoPath => _uploadedPhotoPath;

  bool get hasPhoto => _uploadedPhotoUrl != null;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  void clearPhoto() {
    _uploadedPhotoUrl = null;
    _uploadedPhotoPath = null;
    notifyListeners();
  }

  Future<bool> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      _isUploadingPhoto = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final response = await UserApis().uploadProfileImage(pickedFile.path);

        if (response != null && response['success'] == true) {
          _uploadedPhotoUrl = response['data']['url'];
          _uploadedPhotoPath = response['data']['path'];
          _isUploadingPhoto = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = response?['message'] ?? 'Failed to upload image';
          _isUploadingPhoto = false;
          notifyListeners();
          return false;
        }
      } catch (e) {
        _errorMessage = 'Error: $e';
        _isUploadingPhoto = false;
        notifyListeners();
        return false;
      }
    }
    return false;
  }

  Future<bool> completeProfile({
    required String fullName,
    required String email,
    required String dateOfBirth, // needs to be YYYY-MM-DD
    required String gender,
    required String city,
    required String state,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final params = {
        "full_name": fullName,
        "email": email,
        "date_of_birth": dateOfBirth, // YYYY-MM-DD
        "gender": gender,
        "city": city,
        "state": state,
        if (_uploadedPhotoPath != null) "profile_photo_path": _uploadedPhotoPath,
      };

      final response = await UserApis().completeProfile(params);

      if (response != null && response['success'] == true) {
        _successMessage = response['message'] ?? 'Profile completed successfully.';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response?['message'] ?? 'Failed to complete profile';
        // Parse custom validation errors if they exist
        if (response != null && response['errors'] != null && response['errors'] is Map) {
          final errors = response['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            final firstErrorList = errors.values.first;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              _errorMessage = firstErrorList[0].toString();
            }
          }
        }
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
