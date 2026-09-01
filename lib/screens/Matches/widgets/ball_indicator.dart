import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Small circle representing the outcome of a single delivery in the
/// current over: a number/label for bowled deliveries, or a dim dot for
/// deliveries yet to be bowled.
class BallIndicator extends StatelessWidget {
  const BallIndicator({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final bool isPending = label == '•';
    final bool isBoundary = label == '4' || label == '6';
    final Color fillColor = isPending
        ? AppColors.glassFillLighter
        : isBoundary
            ? AppColors.infoBlue
            : const Color(0xFF2A3040);
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        color: fillColor,
        shape: BoxShape.circle,
        border: isPending ? Border.all(color: AppColors.glassBorder) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPending ? Colors.white38 : Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
