import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Small pill-shaped outline button used for secondary match actions like
/// "Stadium & Check In" or "Predictor Leaderboard".
class OutlineActionButton extends StatelessWidget {
  const OutlineActionButton({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: const Color(0x99E3A93D)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.amberAccent, fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
