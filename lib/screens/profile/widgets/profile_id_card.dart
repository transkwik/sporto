import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/profile_info.dart';

/// Green-bordered Sports ID card: brand mark, avatar, verified name,
/// location, Spoto ID, and a QR affordance.
class ProfileIdCard extends StatelessWidget {
  const ProfileIdCard({super.key, required this.profile, this.onQrTap});

  final ProfileInfo profile;
  final VoidCallback? onQrTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16382C), Color(0xFF0E1620)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.55), width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'SPOTO',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.45)),
                ),
                child: const Text(
                  'SPORTS ID',
                  style: TextStyle(color: AppColors.mintGreen, fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B4A8A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white70, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (profile.verified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded, color: AppColors.mintGreen, size: 18),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.location,
                      style: const TextStyle(color: Colors.white54, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SPOTO ID', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(
                      profile.spotoId,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onQrTap,
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code_2_rounded, color: Colors.black87, size: 28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
