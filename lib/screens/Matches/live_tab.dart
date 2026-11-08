import 'package:flutter/material.dart';
import 'widgets/batsman_stats_table.dart';
import 'widgets/bowler_stats_table.dart';
import 'widgets/fan_reactions_row.dart';
import 'widgets/live_score_panel.dart';
import 'widgets/match_status_pills.dart';
import 'widgets/outline_action_button.dart';
import 'widgets/predict_earn_card.dart';
import 'widgets/predictor_challenge_button.dart';
import 'widgets/sporto_hype_meter_card.dart';
import 'widgets/team_matchup_row.dart';
import 'widgets/view_bracket_tile.dart';

/// "Live" tab of the match screen: live score panel, current batsmen/bowlers,
/// fan reactions, predictor + hype meter cards.
class LiveTab extends StatelessWidget {
  const LiveTab({
    super.key,
    required this.roundLabel,
    required this.teamAName,
    required this.teamARole,
    required this.teamBName,
    required this.teamBRole,
    required this.teamAInitials,
    required this.teamAColor,
    required this.battingScore,
    required this.overs,
    required this.currentRunRate,
    required this.currentBowler,
    required this.thisOverBalls,
    required this.batsmen,
    required this.bowlers,
    required this.likeCount,
    required this.fireCount,
    required this.onStadiumCheckIn,
    required this.onPredictorLeaderboard,
    required this.onPredictorSheet,
  });

  final String roundLabel;
  final String teamAName;
  final String teamARole;
  final String teamBName;
  final String teamBRole;
  final String teamAInitials;
  final Color teamAColor;
  final String battingScore;
  final String overs;
  final String currentRunRate;
  final String currentBowler;
  final List<String> thisOverBalls;
  final List<Map<String, dynamic>> batsmen;
  final List<Map<String, dynamic>> bowlers;
  final String likeCount;
  final String fireCount;
  final VoidCallback onStadiumCheckIn;
  final VoidCallback onPredictorLeaderboard;
  final VoidCallback onPredictorSheet;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      children: [
        MatchStatusPills(roundLabel: roundLabel),
        const SizedBox(height: 18),
        TeamMatchupRow(
          teamAName: teamAName,
          teamARole: teamARole,
          teamBName: teamBName,
          teamBRole: teamBRole,
        ),
        const SizedBox(height: 18),
        LiveScorePanel(
          teamAName: teamAName,
          teamAInitials: teamAInitials,
          teamAColor: teamAColor,
          battingScore: battingScore,
          overs: overs,
          currentRunRate: currentRunRate,
          currentBowler: currentBowler,
          thisOverBalls: thisOverBalls,
        ),
        const SizedBox(height: 26),
        const Text(
          'Batsman',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        BatsmanStatsTable(batsmen: batsmen),
        const SizedBox(height: 24),
        const Text(
          'Bowler',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        BowlerStatsTable(bowlers: bowlers),
        const SizedBox(height: 24),
        const Text(
          'Fan Reactions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        FanReactionsRow(
          likeCount: likeCount,
          fireCount: fireCount,
          onLike: () {},
          onFire: () {},
          onShare: () {},
        ),
        const SizedBox(height: 22),
        PredictEarnCard(teamAName: teamAName, teamBName: teamBName),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlineActionButton(
                label: 'Stadium & Check In',
                onTap: onStadiumCheckIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlineActionButton(
                label: 'Predictor Leaderboard',
                onTap: onPredictorLeaderboard,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SportoHypeMeterCard(
          teamAName: teamAName,
          teamBName: teamBName,
          teamAPercent: 44,
          teamBPercent: 58,
        ),
        const SizedBox(height: 20),
        PredictorChallengeButton(onTap: onPredictorSheet),
        const SizedBox(height: 18),
        ViewBracketTile(onTap: () {}),
      ],
    );
  }
}
