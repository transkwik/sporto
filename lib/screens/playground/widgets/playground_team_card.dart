import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/providers/home_provider.dart';

/// Card for a single entry in the "Teams Looking for Players" list: a
/// sport-tinted gradient background, roster fill badge, and a "Join Team"
/// call to action.
class PlaygroundTeamCard extends StatelessWidget {
  const PlaygroundTeamCard({
    super.key,
    required this.team,
    this.onJoin,
    this.onTap,
  });

  final Map<String, dynamic> team;
  final VoidCallback? onJoin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final teamName = team['team_name'] ?? team['name'] ?? 'Unnamed Team';
    final sportName = team['sport']?['name'] ?? 'Sport';
    final captainName = team['captain']?['name'] ?? 'Unknown Captain';
    final location = team['city'] ?? 'Unknown';
    final maxPlayers = team['total_players'] ?? 11;
    final playersCount = team['members']?['current_count'] ?? 0;
    final neededCount = (maxPlayers - playersCount > 0)
        ? (maxPlayers - playersCount)
        : 0;
    final isCricket = sportName.toString().toLowerCase() == 'cricket';

    String initials = '?';
    if (teamName.toString().isNotEmpty) {
      initials = teamName.toString().substring(0, 1).toUpperCase();
      if (teamName.toString().contains(' ')) {
        final parts = teamName.toString().split(' ');
        if (parts.length > 1 && parts[1].isNotEmpty) {
          initials = '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
              .toUpperCase();
        }
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isCricket
              ? AppColors.playgroundCricketCardGradient
              : AppColors.playgroundFootballCardGradient,
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
                    color: isCricket
                        ? const Color(0xFF1F4A3A)
                        : const Color(0xFF8A4A22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    initials,
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              teamName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.infoBlue.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.infoBlue.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Text(
                              '$playersCount/$maxPlayers Players',
                              style: const TextStyle(
                                color: AppColors.infoBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: sportName,
                              style: const TextStyle(
                                color: AppColors.amberAccent,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: '  •  Captain: ',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12.5,
                              ),
                            ),
                            TextSpan(
                              text: captainName,
                              style: const TextStyle(
                                color: AppColors.mintGreen,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white54,
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.social_distance_rounded,
                            color: Colors.white54,
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'N/A',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Need $neededCount Player  •  Any',
                    style: const TextStyle(
                      color: AppColors.mintGreen,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Consumer<HomeProvider>(
                  builder: (context, homeProvider, child) {
                    final bool apiHasRequested = team['join_request']?['request_sent'] == true;
                    final hasRequested = apiHasRequested || homeProvider.hasRequestedToJoin(
                      team['id'] ?? -1,
                    );

                    if (hasRequested) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          'Request Sent',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: onJoin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.amberAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Join Team',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
