import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/profile_info.dart';

/// Horizontal wrap of sport · role pills (e.g. "CRICKET · ALL-ROUNDER").
class ProfileRoleChips extends StatelessWidget {
  const ProfileRoleChips({super.key, required this.roles});

  final List<ProfileSportRole> roles;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final role in roles)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.glassFillLighter,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(role.icon, size: 14, color: Colors.white70),
                const SizedBox(width: 7),
                Text(
                  '${role.sport} · ${role.role}',
                  style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
