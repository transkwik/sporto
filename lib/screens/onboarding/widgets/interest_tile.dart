import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Glass row summarizing a suggested interest/stat (e.g. "12 Nearby
/// Tournaments") with a trailing arrow, used on the welcome/onboarding
/// summary screen.
class InterestTile extends StatelessWidget {
  const InterestTile({super.key, required this.count, required this.label, this.onTap});

  final String count;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: '$count ',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                  children: [
                    TextSpan(
                      text: label,
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: AppColors.amberAccent, size: 20),
          ],
        ),
      ),
    );
  }
}
