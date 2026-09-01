import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Full-width amber gradient pill button with a soft glow, used as the
/// primary "Continue" action across the onboarding screens.
class OnboardingContinueButton extends StatelessWidget {
  const OnboardingContinueButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppColors.bannerGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: const Color(0xFFFF7A1E).withValues(alpha: 0.4), blurRadius: 22, offset: const Offset(0, 10)),
          ],
        ),
        child: Text(label, style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
