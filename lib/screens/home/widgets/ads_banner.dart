import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Orange gradient promotional banner shown at the bottom of the home feed.
class AdsBanner extends StatelessWidget {
  const AdsBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(gradient: AppColors.bannerGradient, borderRadius: BorderRadius.circular(18)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ads Banner', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
