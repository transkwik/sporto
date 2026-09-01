import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Team-vs-team header row on the live match detail screen: names on
/// either side of a small "vs", with each team's current role (batting or
/// bowling) called out underneath.
class TeamMatchupRow extends StatelessWidget {
  const TeamMatchupRow({
    super.key,
    required this.teamAName,
    required this.teamARole,
    required this.teamBName,
    required this.teamBRole,
  });

  final String teamAName;
  final String teamARole;
  final String teamBName;
  final String teamBRole;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(teamAName, style: const TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(teamARole, style: const TextStyle(color: AppColors.mintGreen, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const Text('vs', style: TextStyle(color: Colors.white38, fontSize: 12.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(teamBName, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(teamBRole, style: const TextStyle(color: AppColors.infoBlue, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
