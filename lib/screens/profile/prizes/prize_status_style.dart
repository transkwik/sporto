import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/prize_utils.dart';

/// Colors and icon used for each payout status, shared by the prize list and
/// the transaction details screen.
class PrizeStatusStyle {
  const PrizeStatusStyle({
    required this.color,
    required this.icon,
    required this.heroBg,
  });

  final Color color;
  final IconData icon;
  final Color heroBg;

  static PrizeStatusStyle of(PayoutStatus status) => switch (status) {
        PayoutStatus.credited => const PrizeStatusStyle(
            color: AppColors.mintGreen,
            icon: Icons.check_circle,
            heroBg: Color(0xFF12241C),
          ),
        PayoutStatus.failed => const PrizeStatusStyle(
            color: Color(0xFFE85A6B),
            icon: Icons.error_outline_rounded,
            heroBg: Color(0xFF2A1418),
          ),
        PayoutStatus.processing => const PrizeStatusStyle(
            color: Color(0xFFFF8A1E),
            icon: Icons.sync_rounded,
            heroBg: Color(0xFF2A1A0C),
          ),
        PayoutStatus.pending => const PrizeStatusStyle(
            color: Color(0xFFE3A93D),
            icon: Icons.schedule_rounded,
            heroBg: Color(0xFF2A2410),
          ),
      };
}
