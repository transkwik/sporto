import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Horizontal filter pill used on the Playground screen ("Nearby", "All",
/// "Cricket", "Football", ...). Shows a solid mint-green fill when selected,
/// otherwise a plain dark glass pill.
class PlaygroundFilterChip extends StatelessWidget {
  const PlaygroundFilterChip({super.key, required this.label, this.icon, required this.selected, this.onTap});

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.mintGreen : AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(12),
          border: selected ? null : Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: selected ? Colors.black87 : Colors.white),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style:GoogleFonts.quicksand(
                color: selected ? Colors.black87 : Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
