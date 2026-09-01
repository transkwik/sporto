import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Horizontally scrollable sport filter chips used on the profile screen.
/// The selected chip fills mint-green with dark text; others stay glass.
class ProfileSportChips extends StatelessWidget {
  const ProfileSportChips({
    super.key,
    required this.sports,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<(IconData icon, String label)> sports;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final (icon, label) = sports[index];
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? AppColors.mintGreen : AppColors.glassFillLighter,
                borderRadius: BorderRadius.circular(20),
                border: selected ? null : Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 15, color: selected ? Colors.black87 : Colors.white70),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.black87 : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
