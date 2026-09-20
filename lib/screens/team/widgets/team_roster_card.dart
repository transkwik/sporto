import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

/// Glass card summarizing a single team's roster status on the "Select Your
/// Team" screen: avatar, captain, player count, and a "Complete Team" pill
/// prompting the user to finish filling out the squad.
class TeamRosterCard extends StatelessWidget {
  const TeamRosterCard({
    super.key,
    required this.team,
    required this.requiredPlayers,
    this.onMenuTap,
    this.onCompleteTap,
  });

  final Map<String, dynamic> team;
  final int requiredPlayers;
  final VoidCallback? onMenuTap;
  final VoidCallback? onCompleteTap;

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }

  Color _getColor(String name) {
    final colors = [
      const Color(0xFFF95B3D),
      const Color(0xFF4A5568),
      const Color(0xFF38B2AC),
      const Color(0xFF4299E1),
      const Color(0xFF9F7AEA),
      const Color(0xFFED64A6),
    ];
    int hash = 0;
    for (var i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return colors[hash.abs() % colors.length];
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
      return 'just now';
    } catch (_) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamName = team['name'] ?? team['team_name'] ?? 'Unnamed Team';
    final captainName = team['captain']?['profile']?['full_name'] ?? team['captain']?['name'] ?? 'N/A';
    final playersCount =
        team['total_players']?.toString() ??
        team['player_count']?.toString() ??
        '0';
    final tournamentsPlayed = team['tournaments_played']?.toString() ?? '0';
    final updatedLabel = _timeAgo(team['updated_at']);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _getColor(teamName),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getInitials(teamName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: 'Captain: ',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12.5,
                        ),
                        children: [
                          TextSpan(
                            text: captainName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$playersCount/$requiredPlayers Players • $tournamentsPlayed Tournaments Played',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onMenuTap,
                child: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Updated $updatedLabel',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                ),
              ),
              if (onCompleteTap != null) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onCompleteTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.glassFillLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassBorderStrong),
                    ),
                    child: const Text(
                      'Complete Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
