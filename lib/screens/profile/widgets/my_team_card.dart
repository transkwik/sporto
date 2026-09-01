import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/my_team_info.dart';

/// Team row on My Teams: complete squads vs action-required incomplete ones.
class MyTeamCard extends StatelessWidget {
  const MyTeamCard({
    super.key,
    required this.team,
    this.onTap,
    this.onComplete,
    this.onMenu,
  });

  final MyTeamInfo team;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final incomplete = !team.isComplete;
    final nameColor = incomplete ? Colors.white70 : Colors.white;
    final muted = incomplete ? Colors.white38 : Colors.white54;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: team.highlighted ? AppColors.liveCardGradient : null,
          color: team.highlighted ? null : const Color(0xFF1A1E28),
          border: Border.all(
            color: team.highlighted ? Colors.transparent : AppColors.glassBorder,
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: team.avatarColor,
                  child: Text(
                    team.avatarInitials,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: TextStyle(color: nameColor, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Captain: ${team.captainName}',
                        style: TextStyle(color: muted, fontSize: 12.5),
                      ),
                      if (team.isComplete) ...[
                        const SizedBox(height: 6),
                        Text(
                          '${team.wins} Wins  •  ${team.titles} Titles',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        '${team.playersCount}/${team.maxPlayers} Players  •  ${team.tournamentsPlayed} Tournaments Played',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onMenu,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.more_vert_rounded, color: muted, size: 20),
                ),
              ],
            ),
            if (incomplete) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFE8B48A), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      team.warningLabel,
                      style: const TextStyle(
                        color: Color(0xFFE8B48A),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onComplete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B1F1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF8B2E28)),
                      ),
                      child: const Text(
                        'Complete Team',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
