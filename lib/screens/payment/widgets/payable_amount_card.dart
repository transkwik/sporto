import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Single-row dark glass card showing the total amount payable, used on
/// lightweight payment flows that don't need a full cost breakdown (e.g.
/// paying an individual share to join someone else's team).
class PayableAmountCard extends StatelessWidget {
  const PayableAmountCard({super.key, required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Payable Amount', style: TextStyle(color: Colors.white54, fontSize: 14.5, fontWeight: FontWeight.w500)),
          Text(amount, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
