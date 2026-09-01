import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Dark glass card recapping the team captain's name, win rate, and
/// tournament count on the Team Details screen.
class CaptainCard extends StatelessWidget {
  const CaptainCard({super.key, required this.name, required this.winRate, required this.tournaments});

  final String name;
  final String winRate;
  final int tournaments;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: name,
                        style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(
                        text: '  (C)',
                        style: TextStyle(color: AppColors.amberAccent, fontSize: 12.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Win Rate: ', style: TextStyle(color: Colors.white54, fontSize: 12.5)),
                    TextSpan(
                      text: winRate,
                      style: const TextStyle(color: AppColors.mintGreen, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('$tournaments Tournament', style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
        ],
      ),
    );
  }
}
