import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Glass card describing one permission request (title + green action
/// caption) with a checkmark/empty-circle toggle on the trailing edge.
class PermissionTile extends StatelessWidget {
  const PermissionTile({
    super.key,
    required this.title,
    required this.caption,
    required this.granted,
    required this.onToggle,
  });

  final String title;
  final String caption;
  final bool granted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    caption,
                    style: GoogleFonts.quicksand(color: AppColors.mintGreen, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: granted ? AppColors.mintGreen : Colors.transparent,
                border: Border.all(color: granted ? AppColors.mintGreen : Colors.white38, width: 1.6),
              ),
              child: granted ? const Icon(Icons.check_rounded, color: Colors.white, size: 17) : null,
            ),
          ],
        ),
      ),
    );
  }
}
