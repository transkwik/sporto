import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/my_sport_info.dart';

/// Large selected-sport row: icon, name, role/captain line, and a mint Selected pill.
class SelectedSportCard extends StatelessWidget {
  const SelectedSportCard({super.key, required this.sport, this.onTap});

  final MySportInfo sport;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF1B3328), Color(0xFF1C202A), Color(0xFF33201C)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.28)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF141820),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Icon(sport.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sport.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  if (sport.roleLabel != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      sport.roleLabel!,
                      style: const TextStyle(color: AppColors.mintGreen, fontSize: 12.5, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.mintGreen, size: 15),
                  SizedBox(width: 5),
                  Text(
                    'Selected',
                    style: TextStyle(color: AppColors.mintGreen, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
