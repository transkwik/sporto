import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/playground_player_info.dart';

/// Card for a single entry in the "Players Available Nearby" list: avatar,
/// sport/role/MVP recap, and an "Invite" call to action.
class PlaygroundPlayerCard extends StatelessWidget {
  const PlaygroundPlayerCard({super.key, required this.player, this.onInvite});

  final PlaygroundPlayerInfo player;
  final VoidCallback? onInvite;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: player.avatarColor, borderRadius: BorderRadius.circular(14)),
                child: Text(
                  player.avatarInitials,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: player.sport,
                            style: const TextStyle(color: AppColors.amberAccent, fontSize: 12.5, fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: '  •  ${player.role}', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          '${player.mvpAwards} MVP Awards',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white54, size: 13),
              const SizedBox(width: 3),
              Text(player.location, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(width: 10),
              const Icon(Icons.social_distance_rounded, color: Colors.white54, size: 13),
              const SizedBox(width: 3),
              Text(player.distanceKm, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  player.availableNow ? 'Available Now' : 'Unavailable',
                  style: TextStyle(
                    color: player.availableNow ? AppColors.mintGreen : Colors.white38,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onInvite,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(color: AppColors.mintGreen, borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    'Invite',
                    style: TextStyle(color: Colors.black87, fontSize: 12.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
