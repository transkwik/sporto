import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Mint-tinted banner spelling out which position the team still needs
/// filled, plus an Invite Player action.
class TeamNeedsBanner extends StatelessWidget {
  const TeamNeedsBanner({super.key, required this.position, this.onInvite});

  final String position;
  final VoidCallback? onInvite;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.mintGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.32)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Team Needs',
                style: TextStyle(color: Colors.white60, fontSize: 13.5, fontWeight: FontWeight.w500),
              ),
              Text(
                position,
                style: const TextStyle(color: AppColors.amberAccent, fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onInvite,
            child: Container(
              width: double.infinity,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.65)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_alt_1_rounded, color: AppColors.mintGreen, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Invite Player',
                    style: TextStyle(color: AppColors.mintGreen, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
