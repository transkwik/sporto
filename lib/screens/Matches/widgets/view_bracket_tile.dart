import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Dark glass row linking out to the full tournament bracket, shown at the
/// bottom of the live match detail screen.
class ViewBracketTile extends StatelessWidget {
  const ViewBracketTile({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('View full bracket', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
            Icon(Icons.chevron_right_rounded, color: AppColors.amberAccent, size: 22),
          ],
        ),
      ),
    );
  }
}
