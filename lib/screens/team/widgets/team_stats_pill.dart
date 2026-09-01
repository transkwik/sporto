import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Full-width dark glass pill summarizing a team's win count and roster
/// fill, e.g. "🏆 12 Wins • 5/6 Players".
class TeamStatsPill extends StatelessWidget {
  const TeamStatsPill({super.key, required this.wins, required this.playersCount, required this.maxPlayers});

  final int wins;
  final int playersCount;
  final int maxPlayers;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text('$wins Wins', style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          const Text('•', style: TextStyle(color: Colors.white38, fontSize: 13)),
          const SizedBox(width: 8),
          Text(
            '$playersCount/$maxPlayers Players',
            style: const TextStyle(color: AppColors.infoBlue, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
