import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/profile_info.dart';

/// Compact 4-up detail stats row with large values and uppercase labels
/// (MATCHES / WINS / TITLES / MVPS) — no icons.
class ProfileDetailStatsRow extends StatelessWidget {
  const ProfileDetailStatsRow({super.key, required this.stats});

  final List<ProfileStat> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _DetailStatCard(stat: stats[i])),
        ],
      ],
    );
  }
}

class _DetailStatCard extends StatelessWidget {
  const _DetailStatCard({required this.stat});

  final ProfileStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Text(
            stat.value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          Text(
            stat.label,
            style: const TextStyle(color: Colors.white54, fontSize: 9.5, fontWeight: FontWeight.w600, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }
}
