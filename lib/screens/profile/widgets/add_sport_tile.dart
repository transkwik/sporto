import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/my_sport_info.dart';

/// Compact unselected sport row used under "Add More Sports".
class AddSportTile extends StatelessWidget {
  const AddSportTile({super.key, required this.sport, this.onTap});

  final MySportInfo sport;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E28),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF141820),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Icon(sport.icon, color: Colors.white70, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sport.name,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${sport.nearbyTournaments} tournaments active near you',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Text(
              'Select',
              style: TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white38, width: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
