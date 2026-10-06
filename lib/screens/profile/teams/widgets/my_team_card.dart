import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Team row on My Teams: complete squads vs action-required incomplete ones.
class MyTeamCard extends StatelessWidget {
  const MyTeamCard({
    super.key,
    required this.team,
    this.onTap,
    this.onComplete,
    this.onMenu,
  });

  final Map<String, dynamic> team;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final completion = team['completion'] ?? {};
    final isComplete = completion['is_complete'] == true;
    final incomplete = !isComplete;
    final nameColor = incomplete ? Colors.white70 : Colors.white;
    final muted = incomplete ? Colors.white38 : Colors.white54;
    
    final teamName = team['team_name']?.toString() ?? 'Unknown';
    final captainName = team['captain']?['profile']?['full_name']?.toString() ?? 'No Captain';
    final avatarInitials = teamName.isNotEmpty ? teamName.substring(0, 1).toUpperCase() : 'T';
    final avatarColor = const Color(0xFF293241);
    final wins = team['stats']?['wins'] ?? 0;
    final titles = team['stats']?['titles'] ?? 0;
    final playersCount = team['players']?['current'] ?? 0;
    final maxPlayers = team['players']?['maximum'];
    final tournamentsPlayed = team['stats']?['tournaments_played'] ?? 0;
    
    // Determine issue logic from backend
    final warningLabel = completion['message']?.toString() ?? 'Action Required';
    final showCompleteButton = completion['action'] == 'COMPLETE_TEAM';
    final actionLabel = completion['action_label']?.toString() ?? 'Complete Team';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1E28),
          border: Border.all(
            color: AppColors.glassBorder,
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: avatarColor,
                  child: Text(
                    avatarInitials,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamName,
                        style: TextStyle(color: nameColor, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Captain: $captainName',
                        style: TextStyle(color: muted, fontSize: 12.5),
                      ),
                      if (isComplete) ...[
                        const SizedBox(height: 6),
                        Text(
                          '$wins Wins  •  $titles Titles',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        maxPlayers != null
                            ? '$playersCount/$maxPlayers Players  •  $tournamentsPlayed Tournaments Played'
                            : '$playersCount Players  •  $tournamentsPlayed Tournaments Played',
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
                      warningLabel,
                      style: const TextStyle(
                        color: Color(0xFFE8B48A),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (showCompleteButton)
                    GestureDetector(
                      onTap: onComplete,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B1F1A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF8B2E28)),
                        ),
                        child: Text(
                          actionLabel,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
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
