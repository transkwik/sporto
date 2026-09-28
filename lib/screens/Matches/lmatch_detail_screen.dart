import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/live_match_detail_info.dart';
import '../home/providers/home_provider.dart';
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
class LiveMatchDetailScreen extends StatefulWidget {
  const LiveMatchDetailScreen({
    super.key,
    required this.match,
    required this.matchId,
  });

  final LiveMatchDetailInfo match;
  final int matchId;

  @override
  State<LiveMatchDetailScreen> createState() => _LiveMatchDetailScreenState();
}

class _LiveMatchDetailScreenState extends State<LiveMatchDetailScreen> {
  late LiveMatchDetailInfo _currentMatch;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentMatch = widget.match;
    // Delay slightly so context.read works without error in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLiveScore();
    });
  }

  Future<void> _fetchLiveScore() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<HomeProvider>();
      final response = await provider.fetchLiveScore(widget.matchId);
      
      if (response != null && response['success'] == true) {
        final data = response['data'] ?? {};
        final scoring = data['scoring'];
        final toss = data['toss'];
        final teams = data['teams'] as List<dynamic>?;
        final tournament = data['tournament'];
        
        String newTournamentName = _currentMatch.tournamentName;
        if (tournament != null && tournament['name'] != null) {
          newTournamentName = tournament['name'];
        }

        String teamAName = _currentMatch.teamAName;
        String teamBName = _currentMatch.teamBName;
        String newScore = _currentMatch.battingScore;
        String currentBowlerName = _currentMatch.currentBowler;
        List<BatsmanStat> batsmen = _currentMatch.batsmen;
        List<BowlerStat> bowlers = _currentMatch.bowlers;

        if (toss != null) {
          final battingTeam = toss['batting_team'];
          final bowlingTeam = toss['bowling_team'];
          if (battingTeam != null) {
            teamAName = battingTeam['name'] ?? 'Unknown Team';
          }
          if (bowlingTeam != null) {
            teamBName = bowlingTeam['name'] ?? 'Unknown Team';
          }
        } else if (teams != null && teams.length >= 2) {
           teamAName = teams[0]['name'] ?? 'Unknown Team';
           teamBName = teams[1]['name'] ?? 'Unknown Team';
        }

        if (scoring != null && toss != null) {
          final activeTeamId = toss['batting_team_id'];
          if (activeTeamId != null) {
            final activeScoreData = scoring['score']?['teams']?[activeTeamId.toString()];
            if (activeScoreData != null) {
              final activeRuns = activeScoreData['score']?.toString() ?? '0';
              final activeWickets = activeScoreData['wickets']?.toString() ?? '0';
              newScore = '$activeRuns/$activeWickets';
            }
          }

          final runtime = scoring['runtime'];
          if (runtime != null) {
            final bowler = runtime['current_bowler'];
            if (bowler != null) {
               currentBowlerName = bowler['name'] ?? 'Unknown Bowler';
               if (bowlers.isNotEmpty) {
                 bowlers = List.from(bowlers);
                 bowlers[0] = BowlerStat(
                   name: currentBowlerName,
                   wicketsRuns: bowlers[0].wicketsRuns,
                   overs: bowlers[0].overs,
                   strikeRate: bowlers[0].strikeRate,
                 );
               }
            }

            final striker = runtime['current_striker'];
            final nonStriker = runtime['current_non_striker'];

            if (striker != null || nonStriker != null) {
              final newBatsmen = <BatsmanStat>[];
              if (striker != null) {
                newBatsmen.add(BatsmanStat(
                  name: striker['name'] ?? 'Unknown Striker',
                  runs: batsmen.isNotEmpty ? batsmen[0].runs : 0,
                  balls: batsmen.isNotEmpty ? batsmen[0].balls : 0,
                  fours: batsmen.isNotEmpty ? batsmen[0].fours : 0,
                  sixes: batsmen.isNotEmpty ? batsmen[0].sixes : 0,
                  strikeRate: batsmen.isNotEmpty ? batsmen[0].strikeRate : '0.0',
                  isCaptain: batsmen.isNotEmpty ? batsmen[0].isCaptain : false,
                ));
              }
              if (nonStriker != null) {
                newBatsmen.add(BatsmanStat(
                  name: nonStriker['name'] ?? 'Unknown Non-Striker',
                  runs: batsmen.length > 1 ? batsmen[1].runs : 0,
                  balls: batsmen.length > 1 ? batsmen[1].balls : 0,
                  fours: batsmen.length > 1 ? batsmen[1].fours : 0,
                  sixes: batsmen.length > 1 ? batsmen[1].sixes : 0,
                  strikeRate: batsmen.length > 1 ? batsmen[1].strikeRate : '0.0',
                  isCaptain: batsmen.length > 1 ? batsmen[1].isCaptain : false,
                ));
              }
              batsmen = newBatsmen.isNotEmpty ? newBatsmen : batsmen;
            }
          }
        }

        setState(() {
          _currentMatch = _currentMatch.copyWith(
            tournamentName: newTournamentName,
            teamAName: teamAName,
            teamBName: teamBName,
            battingScore: newScore,
            currentBowler: currentBowlerName,
            batsmen: batsmen,
            bowlers: bowlers,
          );
        });
      }
    } catch (e) {
      debugPrint('Error fetching live score: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openStadiumCheckIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => StadiumCheckInScreen(match: _currentMatch)),
    );
  }

  void _openPredictorLeaderboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PredictorLeaderboardScreen(match: _currentMatch)),
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
                            _currentMatch.tournamentName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.white38, size: 12),
                              const SizedBox(width: 3),
                              Text(_currentMatch.location, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchLiveScore,
                  color: AppColors.primary,
                  backgroundColor: AppColors.authBackgroundBottom,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                    children: [
                      MatchStatusPills(roundLabel: _currentMatch.roundLabel),
                      const SizedBox(height: 18),
                      TeamMatchupRow(
                        teamAName: _currentMatch.teamAName,
                        teamARole: _currentMatch.teamARole,
                        teamBName: _currentMatch.teamBName,
                        teamBRole: _currentMatch.teamBRole,
                      ),
                      const SizedBox(height: 18),
                      LiveScorePanel(match: _currentMatch),
                      const SizedBox(height: 26),
                      const Text('Batsman', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      BatsmanStatsTable(batsmen: _currentMatch.batsmen),
                      const SizedBox(height: 24),
                      const Text('Bowler', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      BowlerStatsTable(bowlers: _currentMatch.bowlers),
                      const SizedBox(height: 24),
                      const Text('Fan Reactions', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      FanReactionsRow(likeCount: _currentMatch.likeCount, fireCount: _currentMatch.fireCount, onLike: () {}, onFire: () {}, onShare: () {}),
                      const SizedBox(height: 22),
                      PredictEarnCard(teamAName: _currentMatch.teamAName, teamBName: _currentMatch.teamBName),
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
                        teamAName: _currentMatch.teamAName,
                        teamBName: _currentMatch.teamBName,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
