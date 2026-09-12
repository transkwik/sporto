import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/sport_category.dart';

/// Circular glass icon with a label underneath, used for the sport
/// quick-filter row on the home dashboard.
class SportIconButton extends StatelessWidget {
  const SportIconButton({super.key, required this.category, this.selected = false, this.onTap});

  final Map<String, dynamic> category;
  final bool selected;
  final VoidCallback? onTap;

  IconData _getIconForSport(String name) {
    switch (name.toLowerCase()) {
      case 'cricket': return Icons.sports_cricket_rounded;
      case 'football': return Icons.sports_soccer_rounded;
      case 'basketball': return Icons.sports_basketball_rounded;
      case 'volleyball': return Icons.sports_volleyball_rounded;
      case 'badminton': return Icons.sports_tennis_rounded;
      case 'tennis': return Icons.sports_tennis_rounded;
      case 'kabaddi': return Icons.sports_martial_arts_rounded;
      case 'hockey': return Icons.sports_hockey_rounded;
      case 'baseball': return Icons.sports_baseball_rounded;
      case 'golf': return Icons.sports_golf_rounded;
      case 'esports': return Icons.sports_esports_rounded;
      default: return Icons.sports_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If it's our static 'All' fallback, it has 'label' and 'icon' instead of 'name'
    final String label = category['label'] ?? category['name'] ?? 'Sport';
    final IconData iconData = category['icon'] ?? _getIconForSport(label);

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
            child: Icon(iconData, color: selected ? AppColors.primaryLight : Colors.white70, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
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
