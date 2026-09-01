import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Row of two pills atop the live match detail screen: the round label
/// (e.g. "Quarter Final") in an outlined mint pill, and a solid "Live Now"
/// pill with a pulsing red dot.
class MatchStatusPills extends StatelessWidget {
  const MatchStatusPills({super.key, required this.roundLabel});

  final String roundLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.5)),
          ),
          child: Text(
            roundLabel,
            style: const TextStyle(color: AppColors.mintGreen, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFE85A9B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(color: Color(0xFFFF3B3B), shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              const Text(
                'Live Now',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
