import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Amber-tinted notice banner with a warning icon, used to set expectations
/// before a request-to-join action (e.g. captain approval required).
class WarningNoticeBanner extends StatelessWidget {
  const WarningNoticeBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.amberAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.amberAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.amberAccent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white60, fontSize: 12.5, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
