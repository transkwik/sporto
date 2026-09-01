import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Glass card celebrating a newly created team: a glowing green checkmark,
/// a "Team Created!" title, and a nested pill summarizing the squad's
/// membership validity window.
class TeamCreatedSuccessCard extends StatelessWidget {
  const TeamCreatedSuccessCard({
    super.key,
    required this.validUntilLabel,
    required this.daysRemaining,
  });

  final String validUntilLabel;
  final int daysRemaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF241A22),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.12), blurRadius: 30, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mintGreen.withValues(alpha: 0.16),
              boxShadow: [
                BoxShadow(color: AppColors.mintGreen.withValues(alpha: 0.35), blurRadius: 26, spreadRadius: 1),
              ],
            ),
            child: Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: AppColors.mintGreen, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.black87, size: 28),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Team Created! 🎉',
            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your team is ready to play together',
            style: TextStyle(color: Colors.white60, fontSize: 13.5),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.amberAccent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.calendar_month_rounded, color: AppColors.amberAccent, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Valid until $validUntilLabel',
                        style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$daysRemaining days remaining  •  Auto-renews on expiry',
                        style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
