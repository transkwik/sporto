import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

enum Gender { male, female, other }

/// Row of three selectable glass chips for choosing a gender, matching the
/// profile-completion form styling.
class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key, required this.selected, required this.onChanged});

  final Gender? selected;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _GenderChip(value: Gender.male, icon: Icons.male_rounded, label: 'Male', selected: selected, onChanged: onChanged)),
        const SizedBox(width: 10),
        Expanded(child: _GenderChip(value: Gender.female, icon: Icons.female_rounded, label: 'Female', selected: selected, onChanged: onChanged)),
        const SizedBox(width: 10),
        Expanded(child: _GenderChip(value: Gender.other, icon: null, label: 'Others', selected: selected, onChanged: onChanged)),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({required this.value, required this.icon, required this.label, required this.selected, required this.onChanged});

  final Gender value;
  final IconData? icon;
  final String label;
  final Gender? selected;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selected == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.18) : AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primaryLight : AppColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? AppColors.primaryLight : Colors.white54),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
