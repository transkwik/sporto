import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/live_match_detail_info.dart';
import 'ball_indicator.dart';

/// Gradient scoreboard panel on the live match detail screen: batting
/// team's badge and score, overs and run rate, and the current bowler with
/// a ball-by-ball breakdown of the over in progress.
class LiveScorePanel extends StatelessWidget {
  const LiveScorePanel({super.key, required this.match});

  final LiveMatchDetailInfo match;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.liveScorePanelGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: match.teamAColor, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  match.teamAInitials,
                  style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  match.teamAName,
                  style: const TextStyle(color: AppColors.infoBlue, fontSize: 14.5, fontWeight: FontWeight.w700),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    match.battingScore,
                    style: const TextStyle(color: AppColors.amberAccent, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(match.overs, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _DashedDivider(),
          const SizedBox(height: 12),
          Text('CRR: ${match.currentRunRate}', style: const TextStyle(color: Colors.white54, fontSize: 12.5)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Bowler: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      TextSpan(
                        text: match.currentBowler,
                        style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (final ball in match.thisOverBalls) BallIndicator(label: ball),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double dashWidth = 5;
        const double gap = 4;
        final int count = (constraints.maxWidth / (dashWidth + gap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Padding(
              padding: const EdgeInsets.only(right: gap),
              child: Container(width: dashWidth, height: 1, color: Colors.white24),
            ),
          ),
        );
      },
    );
  }
}
