import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Circular action button with a label underneath, used for the
/// "Create Team / Join Team / My Team / Find Player" row on the Playground
/// screen. The primary action renders as a solid amber circle; the rest are
/// outlined glass circles with an amber icon.
class PlaygroundActionButton extends StatelessWidget {
  const PlaygroundActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.isPrimary = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.amberAccent : AppColors.glassFillLighter,
              shape: BoxShape.circle,
              border: isPrimary ? null : Border.all(color: AppColors.amberAccent.withValues(alpha: 0.6)),
            ),
            child: Icon(icon, color: isPrimary ? Colors.black87 : AppColors.amberAccent, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
