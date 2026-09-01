import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Single row in the tournament prize breakdown list: a numbered rank
/// badge, a place label, and the prize amount.
class PrizeRankRow extends StatelessWidget {
  const PrizeRankRow({
    super.key,
    required this.rank,
    required this.label,
    required this.amount,
    required this.badgeColor,
    this.amountColor = Colors.white,
  });

  final int rank;
  final String label;
  final String amount;
  final Color badgeColor;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
            child: Text(
              '$rank',
              style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            amount,
            style: TextStyle(color: amountColor, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
