import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/live_match_detail_info.dart';
import 'widgets/leaderboard_row_card.dart';
import 'widgets/predictor_prize_card.dart';

/// Predictor Leaderboard for a live match: prize banner plus ranked list of
/// predictors (top rank highlighted in amber with a trophy).
class PredictorLeaderboardScreen extends StatelessWidget {
  const PredictorLeaderboardScreen({super.key, required this.match});

  final LiveMatchDetailInfo match;

  static const List<(int rank, String name, int points)> _entries = [
    (1, 'Devika N.', 1240),
    (2, 'Sana K.', 980),
    (3, 'You', 440),
    (4, 'Vikram P.', 210),
    (5, 'Meera J.', 145),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            match.tournamentName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.white38, size: 12),
                              const SizedBox(width: 3),
                              Text(match.location, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                  children: [
                    const Text(
                      'Predictor Leaderboard',
                      style: TextStyle(color: AppColors.amberAccent, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 18),
                    const PredictorPrizeCard(),
                    const SizedBox(height: 22),
                    const Text(
                      'Batsman',
                      style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    for (final entry in _entries) ...[
                      LeaderboardRowCard(
                        rank: entry.$1,
                        name: entry.$2,
                        points: entry.$3,
                        isTop: entry.$1 == 1,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
