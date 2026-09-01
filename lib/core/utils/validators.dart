/// Collection of pure, reusable form-field validators.
///
/// Each method returns `null` when the value is valid, or a user-facing
/// error message otherwise, matching the signature expected by
/// [TextFormField.validator].
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
  );

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Please enter your full name';
    if (trimmed.length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Please enter your email';
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final trimmed = value ?? '';
    if (trimmed.isEmpty) return 'Please enter your password';
    if (trimmed.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? Function(String?) confirmPassword(
    String? Function() getPassword,
  ) {
    return (value) {
      if ((value ?? '').isEmpty) return 'Please confirm your password';
      if (value != getPassword()) return 'Passwords do not match';
      return null;
    };
  }

  static String? required(String? value, {String field = 'This field'}) {
    if ((value ?? '').trim().isEmpty) return '$field is required';
    return null;
  }
}
