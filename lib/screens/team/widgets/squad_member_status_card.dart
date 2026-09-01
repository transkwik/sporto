import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/team_player_info.dart';

/// Dark glass card listing each player just added to a new team, with a
/// status pill: "Active" for the captain (already confirmed), "Pending"
/// for everyone else awaiting their invite response.
class SquadMemberStatusCard extends StatelessWidget {
  const SquadMemberStatusCard({super.key, required this.players});

  final List<TeamPlayerInfo> players;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < players.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          players[i].name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(players[i].phone, style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusPill(isActive: players[i].isCaptain),
                ],
              ),
            ),
            if (i != players.length - 1) Container(height: 1, color: AppColors.glassBorder),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? AppColors.mintGreen : AppColors.amberAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        isActive ? 'Active' : 'Pending',
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
