import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Purple gradient card inviting the viewer to predict the final scoreboard
/// for a small points reward, with a pill button per team to lock in a
/// pick.
class PredictEarnCard extends StatelessWidget {
  const PredictEarnCard({
    super.key,
    required this.teamAName,
    required this.teamBName,
    this.points = '+25 pts',
    this.onPickTeamA,
    this.onPickTeamB,
  });

  final String teamAName;
  final String teamBName;
  final String points;
  final VoidCallback? onPickTeamA;
  final VoidCallback? onPickTeamB;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(gradient: AppColors.predictCardGradient, borderRadius: BorderRadius.circular(22)),
      child: Column(
        children: [
          const Text(
            'Predict & Earn Points',
            style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Predict the Final Scoreboard',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              Text(points, style: const TextStyle(color: AppColors.amberAccent, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _PredictPickButton(label: teamAName, gradient: AppColors.bannerGradient, onTap: onPickTeamA)),
              const SizedBox(width: 12),
              Expanded(child: _PredictPickButton(label: teamBName, gradient: AppColors.pinkGradient, onTap: onPickTeamB)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PredictPickButton extends StatelessWidget {
  const _PredictPickButton({required this.label, required this.gradient, this.onTap});

  final String label;
  final Gradient gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(22)),
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
