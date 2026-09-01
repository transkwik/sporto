import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/sport_category.dart';

/// Circular glass icon with a label underneath, used for the sport
/// quick-filter row on the home dashboard.
class SportIconButton extends StatelessWidget {
  const SportIconButton({super.key, required this.category, this.selected = false, this.onTap});

  final SportCategory category;
  final bool selected;
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: selected ? AppColors.primary.withValues(alpha: 0.18) : AppColors.glassFillLighter,
              // shape: BoxShape.circle,
              border: Border.all(color: selected ? AppColors.primaryLight : AppColors.glassBorder),
            ),
            child: Icon(category.icon, color: selected ? AppColors.primaryLight : Colors.white70, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            category.label,
            style: GoogleFonts.quicksand(
              color: selected ? Colors.white : Colors.white54,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
