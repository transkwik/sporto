import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Row of glass pills for reacting to / sharing a live match: a like
/// count, a "fire" count, and a share action.
class FanReactionsRow extends StatelessWidget {
  const FanReactionsRow({
    super.key,
    required this.likeCount,
    required this.fireCount,
    this.onLike,
    this.onFire,
    this.onShare,
  });

  final String likeCount;
  final String fireCount;
  final VoidCallback? onLike;
  final VoidCallback? onFire;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ReactionPill(icon: Icons.thumb_up_alt_rounded, iconColor: AppColors.mintGreen, label: likeCount, onTap: onLike)),
        const SizedBox(width: 10),
        Expanded(child: _ReactionPill(icon: Icons.local_fire_department_rounded, iconColor: AppColors.primary, label: fireCount, onTap: onFire)),
        const SizedBox(width: 10),
        Expanded(child: _ReactionPill(icon: Icons.share_rounded, iconColor: AppColors.infoBlue, onTap: onShare)),
      ],
    );
  }
}

class _ReactionPill extends StatelessWidget {
  const _ReactionPill({required this.icon, required this.iconColor, this.label, this.onTap});

  final IconData icon;
  final Color iconColor;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 17),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(label!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ],
        ),
      ),
    );
  }
}
