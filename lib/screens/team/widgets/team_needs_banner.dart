import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Mint-tinted banner spelling out which position the team still needs
/// filled, e.g. "Team Needs — Bowler".
class TeamNeedsBanner extends StatelessWidget {
  const TeamNeedsBanner({super.key, required this.position});

  final String position;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.mintGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Team Needs', style: TextStyle(color: Colors.white60, fontSize: 13.5, fontWeight: FontWeight.w500)),
          Text(position, style: const TextStyle(color: AppColors.amberAccent, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
