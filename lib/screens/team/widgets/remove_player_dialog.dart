import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Centered confirmation dialog asking whether to remove a player from a
/// team, with a placeholder avatar, a "{name} from {team}" subtitle, and
/// gradient "Remove" / dark "Cancel" actions.
class RemovePlayerDialog extends StatelessWidget {
  const RemovePlayerDialog({super.key, required this.playerName, required this.teamName});

  final String playerName;
  final String teamName;

  static Future<bool> show(BuildContext context, {required String playerName, required String teamName}) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => RemovePlayerDialog(playerName: playerName, teamName: teamName),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
        decoration: BoxDecoration(
          color: const Color(0xFF161A24),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(color: AppColors.glassFillLight, borderRadius: BorderRadius.circular(24)),
            ),
            const SizedBox(height: 22),
            const Text(
              'Do you want to remove the player?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w700, height: 1.3),
            ),
            const SizedBox(height: 8),
            Text(
              '$playerName from $teamName',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(gradient: AppColors.bannerGradient, borderRadius: BorderRadius.circular(25)),
                      child: const Text(
                        'Remove',
                        style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.glassFillLighter,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70, fontSize: 14.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
