import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Small frosted square back button used across the dark glassmorphism
/// auth/onboarding screens.
class GlassBackButton extends StatelessWidget {
  const GlassBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.glassFillLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}
