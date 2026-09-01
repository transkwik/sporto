import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Dark glass card breaking down the requesting player's individual share
/// of the team's entry fee on the Team Details screen.
class EntryFeeCard extends StatelessWidget {
  const EntryFeeCard({super.key, required this.playerShare, required this.total});

  final String playerShare;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Player Share', style: TextStyle(color: Colors.white54, fontSize: 13.5, fontWeight: FontWeight.w500)),
              Text(playerShare, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: AppColors.glassBorder),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              Text(total, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
