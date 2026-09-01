// const String apiBaseUrl = 'https://bladecloudify.com/api/user/';
const String apiBaseUrl = 'https://app.spotoapp.in/api/v1/user/';

// Onboarding Apis
const SEND_OTP = 'send-otp';
const VERIFY_OTP = 'verify-otp';
const CHECK = 'profile';

// Feature Flags
const bool ENABLE_LOCATION_API_PARAMS = false;

/// When true, logged-out launches always open onboarding (even after refresh).
/// Set this back to `false` to restore: show onboarding once, then login.
const bool FORCE_SHOW_ONBOARDING = false;
