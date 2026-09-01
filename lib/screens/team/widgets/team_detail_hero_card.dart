import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/playground_team_info.dart';

/// Gradient hero card at the top of the Team Details screen: a large avatar
/// that overlaps the card's top edge, the team name, sport/captain line, and
/// location — sport-tinted to match the team's card on the Playground list.
class TeamDetailHeroCard extends StatelessWidget {
  const TeamDetailHeroCard({super.key, required this.team});

  final PlaygroundTeamInfo team;

  static const double _avatarSize = 68;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: _avatarSize / 2),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 44, 20, 22),
          decoration: BoxDecoration(
            gradient: team.cardGradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              Text(
                team.name,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: team.sport,
                      style: const TextStyle(color: AppColors.amberAccent, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: '  •  Captain: ', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    TextSpan(
                      text: team.captainName,
                      style: const TextStyle(color: AppColors.mintGreen, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.white54, size: 14),
                  const SizedBox(width: 4),
                  Text(team.location, style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
                  const SizedBox(width: 10),
                  const Icon(Icons.social_distance_rounded, color: Colors.white54, size: 14),
                  const SizedBox(width: 4),
                  Text(team.distanceKm, style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: _avatarSize,
          height: _avatarSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: team.avatarColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Text(
            team.avatarInitials,
            style: const TextStyle(color: AppColors.mintGreen, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
