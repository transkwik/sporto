import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Warm gradient prize banner for the Predictor Leaderboard: trophy, "Top
/// Predictor Wins", cash prize amount, and a season-reset footnote.
class PredictorPrizeCard extends StatelessWidget {
  const PredictorPrizeCard({super.key, this.prizeLabel = '₹5,000 Cash Prize'});

  final String prizeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
      decoration: BoxDecoration(
        gradient: AppColors.predictorPrizeGradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 34),
          const SizedBox(height: 10),
          const Text(
            'Top Predictor Wins',
            style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            prizeLabel,
            style: const TextStyle(color: AppColors.amberAccent, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '* Season resets every Sunday',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
