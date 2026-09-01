import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Single row on the Predictor Leaderboard: rank + name on the left, points
/// (with an optional trophy for #1) on the right. Top rank uses amber text.
class LeaderboardRowCard extends StatelessWidget {
  const LeaderboardRowCard({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    this.isTop = false,
  });

  final int rank;
  final String name;
  final int points;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    final color = isTop ? AppColors.amberAccent : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$rank $name',
              style: TextStyle(color: color, fontSize: 14.5, fontWeight: FontWeight.w600),
            ),
          ),
          if (isTop) ...[
            const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            '$points pts',
            style: TextStyle(
              color: isTop ? AppColors.amberAccent : Colors.white70,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
