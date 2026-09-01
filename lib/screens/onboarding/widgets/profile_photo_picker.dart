import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Rounded upload placeholder plus a small "clear" button, used for picking
/// the profile photo on the profile-completion form.
class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({
    super.key,
    required this.hasPhoto,
    this.photoUrl,
    this.isUploading = false,
    required this.onUpload,
    required this.onClear,
  });

  final bool hasPhoto;
  final String? photoUrl;
  final bool isUploading;
  final VoidCallback onUpload;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: isUploading ? null : onUpload,
          child: Container(
            width: 104,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.glassFillLighter,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: isUploading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.mintGreen, strokeWidth: 2.5))
                    : hasPhoto && photoUrl != null
                        ? Image.network(photoUrl!, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                        : hasPhoto
                            ? const Icon(Icons.check_circle_rounded, color: AppColors.mintGreen, size: 30)
                            : Text(
                                'Upload',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13.5, fontWeight: FontWeight.w500),
                              ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onClear,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.glassFillLighter,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(Icons.close_rounded, color: Colors.white60, size: 18),
          ),
        ),
      ],
    );
  }
}
