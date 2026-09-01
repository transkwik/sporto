import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/team_player_info.dart';

/// Row card for a single added player on the "Create New Team" form: name,
/// phone, an "Edit" text action, and a remove ("X") button.
class PlayerEntryCard extends StatelessWidget {
  const PlayerEntryCard({super.key, required this.player, this.onEdit, this.onRemove});

  final TeamPlayerInfo player;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.glassFillLighter,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(player.phone, style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: AppColors.infoBlue, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onRemove,
          child: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.glassFillLighter,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(Icons.close_rounded, color: Colors.white60, size: 18),
          ),
        ),
      ],
    );
  }
}
