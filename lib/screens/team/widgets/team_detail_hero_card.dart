import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Gradient hero card at the top of the Team Details screen: a large avatar
/// that overlaps the card's top edge, the team name, sport/captain line, and
/// location — sport-tinted to match the team's card on the Playground list.
class TeamDetailHeroCard extends StatelessWidget {
  const TeamDetailHeroCard({super.key, required this.team});

  final Map<String, dynamic> team;

  static const double _avatarSize = 68;

  @override
  Widget build(BuildContext context) {
    final teamName = team['team_name'] ?? team['name'] ?? 'Unnamed Team';
    final sportName = team['sport']?['name'] ?? 'Sport';
    final captainName = team['captain']?['name'] ?? 'Unknown Captain';
    final location = team['city'] ?? 'Unknown';
    final isCricket = sportName.toString().toLowerCase() == 'cricket';

    String initials = '?';
    if (teamName.toString().isNotEmpty) {
      initials = teamName.toString().substring(0, 1).toUpperCase();
      if (teamName.toString().contains(' ')) {
        final parts = teamName.toString().split(' ');
        if (parts.length > 1 && parts[1].isNotEmpty) {
          initials = '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'.toUpperCase();
        }
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: _avatarSize / 2),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 44, 20, 22),
          decoration: BoxDecoration(
            gradient: isCricket ? AppColors.playgroundCricketCardGradient : AppColors.playgroundFootballCardGradient,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              Text(
                teamName,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: sportName,
                      style: const TextStyle(color: AppColors.amberAccent, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: '  •  Captain: ', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    TextSpan(
                      text: captainName,
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
                  Text(location, style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
                  const SizedBox(width: 10),
                  const Icon(Icons.social_distance_rounded, color: Colors.white54, size: 14),
                  const SizedBox(width: 4),
                  const Text('N/A', style: TextStyle(color: Colors.white54, fontSize: 12.5)),
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
            color: isCricket ? const Color(0xFF1F4A3A) : const Color(0xFF8A4A22),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Text(
            initials,
            style: const TextStyle(color: AppColors.mintGreen, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
