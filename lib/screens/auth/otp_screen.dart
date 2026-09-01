import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../routes/app_routes.dart';
import '../onboarding/complete_profile_screen.dart';
import 'providers/auth_provider.dart';
import 'widgets/auth_pill_buttons.dart';
import 'widgets/otp_input_row.dart';

/// OTP verification screen shown right after the mobile-number login/signup
/// step: a back button, heading, a frosted card holding the boxed OTP input
/// and resend countdown, and a gradient "Verify OTP" action.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 4;
  static const int _resendSeconds = 30;

  final _otpKey = GlobalKey<OtpInputRowState>();
  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  String _code = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_code.length != _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter the $_otpLength-digit code')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();

    final data = await authProvider.verifyOtp(
      mobileNumber: widget.phoneNumber,
      countryCode: "+91",
      otp: _code,
    );

    if (!mounted) return;

    if (data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.successMessage ?? 'Login successful'),
          backgroundColor: AppColors.success,
        ),
      );

      bool isNewUser = data['is_new_user'] ?? false;

      if (isNewUser) {
        Get.to(() => CompleteProfileScreen());
      } else {
        Get.to(() => CompleteProfileScreen());
        // Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to verify OTP'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleResend() async {
    if (_secondsLeft > 0) return;

    final authProvider = context.read<AuthProvider>();
    bool success = await authProvider.sendOtp(
      mobileNumber: widget.phoneNumber,
      countryCode: "+91",
    );

    if (!mounted) return;

    if (success) {
      _otpKey.currentState?.clear();
      setState(() => _code = '');
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.successMessage ?? 'OTP resent successfully',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to resend OTP'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String get _formattedTime {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassBackButton(onTap: () => Navigator.of(context).maybePop()),
                const SizedBox(height: 30),
                Text(
                  'Verify Your Number',
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter $_otpLength-digit OTP',
                  style: GoogleFonts.quicksand(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassFillLighter,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    children: [
                      OtpInputRow(
                        key: _otpKey,
                        length: _otpLength,
                        onChanged: (value) => setState(() => _code = value),
                        onCompleted: (_) => _handleVerify(),
                      ),
                      const SizedBox(height: 22),
                      GestureDetector(
                        onTap: _handleResend,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13.5,
                            ),
                            children: [
                              const TextSpan(text: 'Resend code  '),
                              TextSpan(
                                text: _secondsLeft > 0
                                    ? _formattedTime
                                    : 'Resend',
                                style: const TextStyle(
                                  color: AppColors.infoBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                GradientPillButton(
                  label: 'Verify OTP',
                  onPressed: _handleVerify,
                  loading: authProvider.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
