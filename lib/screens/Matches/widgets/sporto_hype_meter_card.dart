import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Dark green gradient card showing a two-team "hype" bar with a live
/// percentage split, plus a circular "Cheer" call to action that overlaps
/// the bar.
class SportoHypeMeterCard extends StatelessWidget {
  const SportoHypeMeterCard({
    super.key,
    required this.teamAName,
    required this.teamBName,
    required this.teamAPercent,
    required this.teamBPercent,
    this.onCheer,
  });

  final String teamAName;
  final String teamBName;
  final int teamAPercent;
  final int teamBPercent;
  final VoidCallback? onCheer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: BoxDecoration(gradient: AppColors.liveScorePanelGradient, borderRadius: BorderRadius.circular(22)),
      child: Column(
        children: [
          const Text(
            'Sporto Hype Meter',
            style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  teamAName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const Text('Hype', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
              Expanded(
                child: Text(
                  teamBName,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(gradient: AppColors.hypeMeterBarGradient, borderRadius: BorderRadius.circular(6)),
                ),
                GestureDetector(
                  onTap: onCheer,
                  child: Container(
                    width: 62,
                    height: 62,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.pinkGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(color: AppColors.hypePink.withValues(alpha: 0.5), blurRadius: 18, spreadRadius: 1),
                      ],
                    ),
                    child: const Text(
                      'Cheer',
                      style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '$teamAPercent%',
                style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '$teamBPercent%',
                style: const TextStyle(color: AppColors.hypePink, fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
