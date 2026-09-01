import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/live_match_detail_info.dart';
import 'stadium_check_in_screen.dart';
import 'predictor_leaderboard_screen.dart';
import 'widgets/batsman_stats_table.dart';
import 'widgets/bowler_stats_table.dart';
import 'widgets/fan_reactions_row.dart';
import 'widgets/live_score_panel.dart';
import 'widgets/match_status_pills.dart';
import 'widgets/outline_action_button.dart';
import 'widgets/predict_earn_card.dart';
import 'widgets/predictor_challenge_button.dart';
import 'widgets/predictor_sheet.dart';
import 'widgets/sporto_hype_meter_card.dart';
import 'widgets/team_matchup_row.dart';
import 'widgets/view_bracket_tile.dart';

/// Full live scorecard for a single match: current score, ball-by-ball
/// breakdown of the over in progress, batsman/bowler stats, fan reactions,
/// a score predictor, a fan "hype meter", and a predictor challenge CTA.
class LiveMatchDetailScreen extends StatelessWidget {
  const LiveMatchDetailScreen({super.key, required this.match});

  final LiveMatchDetailInfo match;

  void _openStadiumCheckIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StadiumCheckInScreen(match: match)),
    );
  }

  void _openPredictorLeaderboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PredictorLeaderboardScreen(match: match)),
    );
  }

  void _openPredictorSheet(BuildContext context) {
    PredictorSheet.show(
      context,
      onRevealResult: () => _openStadiumCheckIn(context),
    );
  }

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
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  children: [
                    MatchStatusPills(roundLabel: match.roundLabel),
                    const SizedBox(height: 18),
                    TeamMatchupRow(
                      teamAName: match.teamAName,
                      teamARole: match.teamARole,
                      teamBName: match.teamBName,
                      teamBRole: match.teamBRole,
                    ),
                    const SizedBox(height: 18),
                    LiveScorePanel(match: match),
                    const SizedBox(height: 26),
                    const Text('Batsman', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    BatsmanStatsTable(batsmen: match.batsmen),
                    const SizedBox(height: 24),
                    const Text('Bowler', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    BowlerStatsTable(bowlers: match.bowlers),
                    const SizedBox(height: 24),
                    const Text('Fan Reactions', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    FanReactionsRow(likeCount: match.likeCount, fireCount: match.fireCount, onLike: () {}, onFire: () {}, onShare: () {}),
                    const SizedBox(height: 22),
                    PredictEarnCard(teamAName: match.teamAName, teamBName: match.teamBName),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlineActionButton(
                            label: 'Stadium & Check In',
                            onTap: () => _openStadiumCheckIn(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlineActionButton(
                            label: 'Predictor Leaderboard',
                            onTap: () => _openPredictorLeaderboard(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SportoHypeMeterCard(
                      teamAName: match.teamAName,
                      teamBName: match.teamBName,
                      teamAPercent: 44,
                      teamBPercent: 58,
                    ),
                    const SizedBox(height: 20),
                    PredictorChallengeButton(onTap: () => _openPredictorSheet(context)),
                    const SizedBox(height: 18),
                    ViewBracketTile(onTap: () {}),
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
