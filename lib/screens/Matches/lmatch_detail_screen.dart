import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/apiServices/user_api.dart';
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
    required this.matchId,
  });

  final int matchId;

  @override
  State<LiveMatchDetailScreen> createState() => _LiveMatchDetailScreenState();
}

class _LiveMatchDetailScreenState extends State<LiveMatchDetailScreen> {
  bool _isLoading = false;

  String _tournamentName = 'Live Match';
  String _location = '';
  String _roundLabel = 'Live';
  String _teamAName = 'Team A';
  String _teamAInitials = 'TA';
  final Color _teamAColor = const Color(0xFF2E9EE0);
  String _teamARole = 'Batting';
  String _teamBName = 'Team B';
  String _teamBRole = 'Bowling';
  String _battingScore = '0/0';
  String _overs = '0.0';
  String _baseRunRate = '0.00';
  String _currentRunRate = '0.00';
  String _currentBowler = 'No bowler';
  List<String> _thisOverBalls = [];
  List<Map<String, dynamic>> _batsmen = [];
  List<Map<String, dynamic>> _bowlers = [];
  final String _likeCount = '384';
  final String _fireCount = '1.2k';

  @override
  void initState() {
    super.initState();
    // Delay slightly so context.read works without error in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLiveScore();
    });
  }

  /// Converts one ball in `current_over_deliveries` (an object such as
  /// `{event_code: RUN, value: 4, display: "4"}` or a plain value) into the
  /// short label shown in the over strip.
  String _deliveryLabel(dynamic d) {
    if (d is! Map) return d.toString();
    final display = d['display']?.toString();
    if (display != null && display.isNotEmpty) return display;
    final code = (d['event_code'] ?? '').toString();
    final val = int.tryParse(d['value']?.toString() ?? '') ?? 0;
    if (code == 'WIDE') return 'WD';
    if (code == 'NO_BALL') return 'NB';
    if (code == 'WICKET') return 'W';
    if (val == 0) return '•';
    return '$val';
  }

  Future<void> _fetchLiveScore() async {
    setState(() => _isLoading = true);
    try {
      final provider = context.read<HomeProvider>();
      final response = await provider.fetchLiveScore(widget.matchId);

      if (response != null && response['success'] == true) {
        final data = response['data'] ?? {};
        final scoring = data['scoring'] as Map<String, dynamic>?;
        final toss = data['toss'] as Map<String, dynamic>?;
        final teams = data['teams'] as List<dynamic>?;
        final tournament = data['tournament'] as Map<String, dynamic>?;
        final runtime = scoring?['runtime'] as Map<String, dynamic>?;
        final events = runtime?['events'] as List<dynamic>? ?? [];

        String newTournamentName = _tournamentName;
        if (tournament != null && tournament['name'] != null) {
          newTournamentName = tournament['name'].toString();
        }

        String newLocation = _location;
        if (data['venue'] != null && data['venue']['name'] != null) {
          newLocation = data['venue']['name'].toString();
        }

        String newRoundLabel = _roundLabel;
        if (data['round'] != null && data['round']['name'] != null) {
          newRoundLabel = data['round']['name'].toString();
        }

        String teamAName = _teamAName;
        String teamBName = _teamBName;
        int? teamAId;
        int? teamBId;

        // Runtime reflects the CURRENT innings (the toss only describes who
        // batted first), so it takes priority for the batting/bowling teams.
        if (runtime != null) {
          final battingTeam = runtime['current_batting_team'];
          final bowlingTeam = runtime['current_bowling_team'];
          if (battingTeam != null) {
            teamAName = (battingTeam['name'] ?? teamAName).toString();
            teamAId = runtime['current_batting_team_id'] ?? battingTeam['id'];
          }
          if (bowlingTeam != null) {
            teamBName = (bowlingTeam['name'] ?? teamBName).toString();
            teamBId = runtime['current_bowling_team_id'] ?? bowlingTeam['id'];
          }
        }

        if (teamAId == null && toss != null) {
          final battingTeam = toss['batting_team'];
          final bowlingTeam = toss['bowling_team'];
          if (battingTeam != null) {
            teamAName = (battingTeam['name'] ?? teamAName).toString();
            teamAId = toss['batting_team_id'] ?? battingTeam['id'];
          }
          if (bowlingTeam != null) {
            teamBName = (bowlingTeam['name'] ?? teamBName).toString();
            teamBId = toss['bowling_team_id'] ?? bowlingTeam['id'];
          }
        }

        if (teamAId == null && data['team_a'] != null) {
          teamAName = (data['team_a']['name'] ?? teamAName).toString();
          teamAId = data['team_a']['id'];
          if (data['team_b'] != null) {
            teamBName = (data['team_b']['name'] ?? teamBName).toString();
            teamBId = data['team_b']['id'];
          }
        }

        if (teamAId == null && teams != null && teams.length >= 2) {
          teamAName = (teams[0]['name'] ?? teamAName).toString();
          teamAId = teams[0]['id'];
          teamBName = (teams[1]['name'] ?? teamBName).toString();
          teamBId = teams[1]['id'];
        }

        // Live score & overs from scoring.score
        final scoreObj = (scoring?['score'] ?? data['score']) as Map<String, dynamic>?;
        String newScore = _battingScore;
        String newOvers = _overs;
        String currentRunRate = _baseRunRate;

        if (scoreObj != null) {
          final teamsScore = scoreObj['teams'] as Map<String, dynamic>?;
          if (teamsScore != null) {
            Map<String, dynamic>? activeScoreData;
            if (teamAId != null && teamsScore[teamAId.toString()] != null) {
              activeScoreData = teamsScore[teamAId.toString()] as Map<String, dynamic>?;
            } else if (teamsScore.isNotEmpty) {
              activeScoreData = teamsScore.values.firstWhere(
                (t) => (t['legal_balls'] ?? 0) > 0 || (t['score'] ?? 0) > 0,
                orElse: () => teamsScore.values.first,
              ) as Map<String, dynamic>?;
            }

            if (activeScoreData != null) {
              final runs = activeScoreData['score']?.toString() ?? '0';
              final wickets = activeScoreData['wickets']?.toString() ?? '0';
              newScore = '$runs/$wickets';

              final oversVal = activeScoreData['overs'];
              if (oversVal != null) {
                newOvers = oversVal.toString();
              } else if (runtime != null) {
                final curOver = runtime['current_over'] ?? 0;
                final curBall = runtime['current_ball'] ?? 0;
                newOvers = '$curOver.$curBall';
              }

              final double runsNum = double.tryParse(runs) ?? 0.0;
              final int legalBalls = activeScoreData['legal_balls'] is int
                  ? activeScoreData['legal_balls'] as int
                  : int.tryParse(activeScoreData['legal_balls']?.toString() ?? '') ?? 0;
              if (legalBalls > 0) {
                currentRunRate = (runsNum / (legalBalls / 6.0)).toStringAsFixed(2);
              } else {
                final double oversNum = double.tryParse(newOvers) ?? 0.0;
                if (oversNum > 0) {
                  currentRunRate = (runsNum / oversNum).toStringAsFixed(2);
                }
              }
            }
          }
        }

        // --- Player Names & Captain Resolution ---
        final Map<int, String> playerNames = {};
        final Map<int, bool> playerIsCaptain = {};

        // 1. Check teams array in match response
        if (teams != null) {
          for (final t in teams) {
            final pList = t['players'] as List<dynamic>?;
            if (pList != null) {
              for (final p in pList) {
                final uid = p['user_id'] ?? p['id'];
                final pName = p['full_name'] ?? p['name'] ?? p['player_name'] ?? p['display_name'];
                if (uid != null) {
                  final parsedUid = uid is int ? uid : int.tryParse(uid.toString()) ?? 0;
                  if (pName != null && pName.toString().trim().isNotEmpty && pName != 'Unknown') {
                    playerNames[parsedUid] = pName.toString().trim();
                  }
                  if (p['is_captain'] == true) {
                    playerIsCaptain[parsedUid] = true;
                  }
                }
              }
            }
          }
        }

        // 2. Fetch team players roster from API if striker/bowler name is null
        final strikerObj = runtime?['current_striker'] as Map<String, dynamic>?;
        final nonStrikerObj = runtime?['current_non_striker'] as Map<String, dynamic>?;
        final bowlerObj = runtime?['current_bowler'] as Map<String, dynamic>?;

        final strikerUid = runtime?['current_striker_user_id'] ?? strikerObj?['user_id'];
        final nonStrikerUid = runtime?['current_non_striker_user_id'] ?? nonStrikerObj?['user_id'];
        final bowlerUid = runtime?['current_bowler_user_id'] ?? bowlerObj?['user_id'];

        bool needsPlayerLookup = false;
        if (strikerUid != null && !playerNames.containsKey(strikerUid is int ? strikerUid : int.tryParse(strikerUid.toString()) ?? 0)) {
          needsPlayerLookup = true;
        }
        if (nonStrikerUid != null && !playerNames.containsKey(nonStrikerUid is int ? nonStrikerUid : int.tryParse(nonStrikerUid.toString()) ?? 0)) {
          needsPlayerLookup = true;
        }
        if (bowlerUid != null && !playerNames.containsKey(bowlerUid is int ? bowlerUid : int.tryParse(bowlerUid.toString()) ?? 0)) {
          needsPlayerLookup = true;
        }

        if (needsPlayerLookup) {
          try {
            final futures = <Future<dynamic>>[];
            if (teamAId != null) futures.add(UserApis().getTeamPlayers(teamAId));
            if (teamBId != null && teamBId != teamAId) futures.add(UserApis().getTeamPlayers(teamBId));

            final results = await Future.wait(futures);
            for (final res in results) {
              if (res != null && res['success'] == true && res['data'] is List) {
                for (final p in res['data']) {
                  final uid = p['user_id'] ?? p['id'];
                  String pName = (p['player_name'] ?? '').toString().trim();
                  final user = p['user'];
                  if (user != null) {
                    final fullName = user['profile']?['full_name'] ?? user['display_name'] ?? user['name'];
                    if (fullName != null && fullName.toString().trim().isNotEmpty) {
                      pName = fullName.toString().trim();
                    }
                  }
                  if (uid != null) {
                    final parsedUid = uid is int ? uid : int.tryParse(uid.toString()) ?? 0;
                    if (pName.isNotEmpty && pName != 'Captain' && pName != 'Unknown') {
                      playerNames[parsedUid] = pName;
                    }
                    if (p['is_captain'] == true) {
                      playerIsCaptain[parsedUid] = true;
                    }
                  }
                }
              }
            }
          } catch (e) {
            debugPrint('Error loading team players for names: $e');
          }
        }

        String resolvePlayerName(dynamic uid, dynamic inlineName, String fallback, [dynamic inlineFullName]) {
          if (inlineFullName != null && inlineFullName.toString().trim().isNotEmpty && inlineFullName != 'Unknown') {
            return inlineFullName.toString().trim();
          }
          if (inlineName != null && inlineName.toString().trim().isNotEmpty && inlineName != 'Unknown') {
            return inlineName.toString().trim();
          }
          if (uid != null) {
            final parsedUid = uid is int ? uid : int.tryParse(uid.toString()) ?? 0;
            if (playerNames.containsKey(parsedUid)) {
              return playerNames[parsedUid]!;
            }
            return '$fallback ($parsedUid)';
          }
          return fallback;
        }

        // --- Calculate Player Stats from Events ---
        final int currentInning = runtime?['current_inning'] is int
            ? runtime!['current_inning'] as int
            : int.tryParse(runtime?['current_inning']?.toString() ?? '1') ?? 1;

        final Map<int, int> batsmanRuns = {};
        final Map<int, int> batsmanBalls = {};
        final Map<int, int> batsmanFours = {};
        final Map<int, int> batsmanSixes = {};

        final Map<int, int> bowlerRuns = {};
        final Map<int, int> bowlerLegalBalls = {};
        final Map<int, int> bowlerWickets = {};
        final Map<int, List<String>> overBallsMap = {};
        final List<String> currentOverBallsList = [];

        int activeEventInning = 1;
        for (final ev in events) {
          final type = ev['type'];
          final evData = ev['data'];
          if (type == 'INNINGS_STARTED' && evData is Map) {
            activeEventInning = evData['inning'] is int 
                ? evData['inning'] as int 
                : int.tryParse(evData['inning']?.toString() ?? '1') ?? 1;
          }

          // Only process ball events for the CURRENT inning
          if (activeEventInning == currentInning && type == 'BALL_RECORDED' && evData is Map<String, dynamic>) {
            final sId = evData['striker_user_id'] is int 
                ? evData['striker_user_id'] as int 
                : int.tryParse(evData['striker_user_id']?.toString() ?? '') ?? 0;
            final bId = evData['bowler_user_id'] is int 
                ? evData['bowler_user_id'] as int 
                : int.tryParse(evData['bowler_user_id']?.toString() ?? '') ?? 0;

            final int val = evData['value'] is int 
                ? evData['value'] as int 
                : int.tryParse(evData['value']?.toString() ?? '') ?? 0;
            final int delRuns = evData['delivery_runs'] is int 
                ? evData['delivery_runs'] as int 
                : int.tryParse(evData['delivery_runs']?.toString() ?? '') ?? val;

            final bool isLegal = evData['legal_delivery'] == true || evData['legal'] == true;
            final String eventCode = (evData['event_code'] ?? '').toString();
            final int overNum = evData['over_number'] is int 
                ? evData['over_number'] as int 
                : int.tryParse(evData['over_number']?.toString() ?? '') ?? 0;

            if (sId != 0) {
              if (eventCode != 'WIDE') {
                batsmanRuns[sId] = (batsmanRuns[sId] ?? 0) + val;
              }
              if (isLegal) {
                batsmanBalls[sId] = (batsmanBalls[sId] ?? 0) + 1;
              }
              if (val == 4) batsmanFours[sId] = (batsmanFours[sId] ?? 0) + 1;
              if (val == 6) batsmanSixes[sId] = (batsmanSixes[sId] ?? 0) + 1;
            }

            if (bId != 0) {
              bowlerRuns[bId] = (bowlerRuns[bId] ?? 0) + delRuns;
              if (isLegal) {
                bowlerLegalBalls[bId] = (bowlerLegalBalls[bId] ?? 0) + 1;
              }
              final int w = evData['wickets'] is int 
                  ? evData['wickets'] as int 
                  : int.tryParse(evData['wickets']?.toString() ?? '') ?? 0;
              if (eventCode == 'WICKET' || w > 0) {
                bowlerWickets[bId] = (bowlerWickets[bId] ?? 0) + (w > 0 ? w : 1);
              }
            }

            final display = evData['display']?.toString();
            String ballLabel = '$val';
            if (display != null && display.isNotEmpty) {
              ballLabel = display;
            } else if (eventCode == 'WIDE') {
              ballLabel = 'WD';
            } else if (eventCode == 'NO_BALL') {
              ballLabel = 'NB';
            } else if (eventCode == 'WICKET') {
              ballLabel = 'W';
            } else if (val == 0) {
              ballLabel = '•';
            }
            currentOverBallsList.add(ballLabel);
            overBallsMap.putIfAbsent(overNum, () => []).add(ballLabel);
          }
        }

        // Build batsmen list
        final List<Map<String, dynamic>> newBatsmen = [];
        if (strikerUid != null) {
          final int sId = strikerUid is int ? strikerUid : int.tryParse(strikerUid.toString()) ?? 0;
          final r = batsmanRuns[sId] ?? 0;
          final b = batsmanBalls[sId] ?? 0;
          final f = batsmanFours[sId] ?? 0;
          final s = batsmanSixes[sId] ?? 0;
          final sr = b > 0 ? ((r / b) * 100).toStringAsFixed(1) : '0.0';
          final bool isCap = strikerObj?['is_captain'] == true || (playerIsCaptain[sId] == true);
          newBatsmen.add({
            'name': resolvePlayerName(strikerUid, strikerObj?['name'], 'Striker', strikerObj?['full_name']),
            'runs': r,
            'balls': b,
            'fours': f,
            'sixes': s,
            'strikeRate': sr,
            'isCaptain': isCap,
          });
        }

        if (nonStrikerUid != null && nonStrikerUid != strikerUid) {
          final int nsId = nonStrikerUid is int ? nonStrikerUid : int.tryParse(nonStrikerUid.toString()) ?? 0;
          final r = batsmanRuns[nsId] ?? 0;
          final b = batsmanBalls[nsId] ?? 0;
          final f = batsmanFours[nsId] ?? 0;
          final s = batsmanSixes[nsId] ?? 0;
          final sr = b > 0 ? ((r / b) * 100).toStringAsFixed(1) : '0.0';
          final bool isCap = nonStrikerObj?['is_captain'] == true || (playerIsCaptain[nsId] == true);
          newBatsmen.add({
            'name': resolvePlayerName(nonStrikerUid, nonStrikerObj?['name'], 'Non-Striker', nonStrikerObj?['full_name']),
            'runs': r,
            'balls': b,
            'fours': f,
            'sixes': s,
            'strikeRate': sr,
            'isCaptain': isCap,
          });
        }

        // Build bowler list (current bowler first, followed by other bowlers who bowled)
        final List<Map<String, dynamic>> newBowlers = [];
        String currentBowlerName = 'No bowler';
        final int currentBId = bowlerUid is int ? bowlerUid : int.tryParse(bowlerUid?.toString() ?? '') ?? 0;

        if (currentBId != 0 && (bowlerObj != null && (bowlerObj['name'] != null || bowlerObj['full_name'] != null))) {
          currentBowlerName = resolvePlayerName(bowlerUid, bowlerObj['name'], 'Bowler', bowlerObj['full_name']);
          int curBWickets = bowlerWickets[currentBId] ?? 0;
          int curBRuns = bowlerRuns[currentBId] ?? 0;
          String curBOvers = '0.0';
          String curBEcon = '0.0';

          final legalB = bowlerLegalBalls[currentBId] ?? 0;
          final o = legalB ~/ 6;
          final rem = legalB % 6;
          curBOvers = '$o.$rem';
          if (legalB > 0) {
            curBEcon = (curBRuns / (legalB / 6.0)).toStringAsFixed(1);
          }

          final bool curBowlerIsCap = bowlerObj['is_captain'] == true || (playerIsCaptain[currentBId] == true);
          newBowlers.add({
            'name': currentBowlerName,
            'isCaptain': curBowlerIsCap,
            'wicketsRuns': '$curBWickets-$curBRuns',
            'overs': curBOvers,
            'strikeRate': curBEcon,
          });
        }

        // Add any other bowlers who bowled in this innings
        for (final entry in bowlerLegalBalls.entries) {
          final otherBId = entry.key;
          if (otherBId != currentBId && otherBId != 0) {
            final otherW = bowlerWickets[otherBId] ?? 0;
            final otherR = bowlerRuns[otherBId] ?? 0;
            final otherLegalB = entry.value;
            final o = otherLegalB ~/ 6;
            final rem = otherLegalB % 6;
            final otherOvers = '$o.$rem';
            final otherEcon = otherLegalB > 0
                ? (otherR / (otherLegalB / 6.0)).toStringAsFixed(1)
                : '0.0';
            final otherName = resolvePlayerName(otherBId, null, 'Bowler');
            final bool otherBowlerIsCap = playerIsCaptain[otherBId] == true;
            newBowlers.add({
              'name': otherName,
              'isCaptain': otherBowlerIsCap,
              'wicketsRuns': '$otherW-$otherR',
              'overs': otherOvers,
              'strikeRate': otherEcon,
            });
          }
        }

        // Prefer the server-computed innings scorecard for the current innings
        // (the event stream is truncated to the latest 50 events). Only used
        // when it actually has entries; otherwise the event-derived lists stand.
        Map<String, dynamic>? currentInningsData;
        final inningsList = scoring?['innings'] as List<dynamic>?;
        if (inningsList != null) {
          for (final inn in inningsList) {
            if (inn is Map && inn['innings_number']?.toString() == currentInning.toString()) {
              currentInningsData = Map<String, dynamic>.from(inn);
            }
          }
        }
        final curInnObj = scoring?['current_innings'];
        if (curInnObj is Map && curInnObj['innings_number']?.toString() == currentInning.toString()) {
          final hasStats = ((curInnObj['batting'] as List?)?.isNotEmpty ?? false) ||
              ((curInnObj['bowling'] as List?)?.isNotEmpty ?? false);
          if (currentInningsData == null || hasStats) {
            currentInningsData = Map<String, dynamic>.from(curInnObj);
          }
        }

        final List<dynamic> serverBatting = (currentInningsData?['batting'] as List<dynamic>?) ?? const [];
        final List<dynamic> serverBowling = (currentInningsData?['bowling'] as List<dynamic>?) ?? const [];

        if (serverBatting.isNotEmpty) {
          final atCrease = serverBatting.where((b) => b is Map && b['status'] == 'not_out').toList();
          final shown = atCrease.isNotEmpty ? atCrease : serverBatting;
          newBatsmen.clear();
          for (final b in shown.whereType<Map>()) {
            final id = int.tryParse(b['player_id']?.toString() ?? '') ?? 0;
            final sr = double.tryParse(b['strike_rate']?.toString() ?? '') ?? 0.0;
            newBatsmen.add({
              'name': resolvePlayerName(id, b['name'], 'Batter'),
              'runs': b['runs'] ?? 0,
              'balls': b['balls_faced'] ?? 0,
              'fours': b['fours'] ?? 0,
              'sixes': b['sixes'] ?? 0,
              'strikeRate': sr.toStringAsFixed(1),
              'isCaptain': playerIsCaptain[id] == true,
            });
          }
        }

        if (serverBowling.isNotEmpty) {
          final List<Map<String, dynamic>> currentFirst = [];
          final List<Map<String, dynamic>> others = [];
          for (final b in serverBowling.whereType<Map>()) {
            final id = int.tryParse(b['player_id']?.toString() ?? '') ?? 0;
            final econ = double.tryParse(b['economy_rate']?.toString() ?? '') ?? 0.0;
            final name = resolvePlayerName(id, b['name'], 'Bowler');
            final entry = <String, dynamic>{
              'name': name,
              'isCaptain': playerIsCaptain[id] == true,
              'wicketsRuns': '${b['wickets'] ?? 0}-${b['runs_conceded'] ?? 0}',
              'overs': b['overs']?.toString() ?? '0.0',
              'strikeRate': econ.toStringAsFixed(1),
            };
            if (id != 0 && id == currentBId) {
              currentBowlerName = name;
              currentFirst.add(entry);
            } else {
              others.add(entry);
            }
          }
          newBowlers
            ..clear()
            ..addAll(currentFirst)
            ..addAll(others);
        }

        final rawCurDeliveries = runtime?['current_over_deliveries'] as List<dynamic>?;
        final int curOver = runtime?['current_over'] ?? 0;
        List<String> thisOverBalls = [];
        if (rawCurDeliveries != null && rawCurDeliveries.isNotEmpty) {
          thisOverBalls = rawCurDeliveries.map(_deliveryLabel).toList();
        } else if (overBallsMap.containsKey(curOver) && overBallsMap[curOver]!.isNotEmpty) {
          thisOverBalls = overBallsMap[curOver]!;
        } else if (overBallsMap.containsKey(curOver - 1) && overBallsMap[curOver - 1]!.isNotEmpty) {
          thisOverBalls = overBallsMap[curOver - 1]!;
        } else if (currentOverBallsList.isNotEmpty) {
          thisOverBalls = currentOverBallsList.length > 6
              ? currentOverBallsList.sublist(currentOverBallsList.length - 6)
              : currentOverBallsList;
        } else {
          thisOverBalls = [];
        }

        final targetVal = runtime?['target'];
        final runsRequiredVal = runtime?['runs_required'];
        String displayRunRate = currentRunRate;
        if (targetVal != null && runsRequiredVal != null) {
          displayRunRate = '$currentRunRate  •  Target: $targetVal (Need $runsRequiredVal)';
        }

        String initials = teamAName.trim().split(RegExp(r'\s+')).map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
        if (initials.isEmpty) initials = 'TM';

        setState(() {
          _tournamentName = newTournamentName;
          _location = newLocation;
          _roundLabel = newRoundLabel;
          _teamAName = teamAName;
          _teamAInitials = initials;
          _teamARole = 'Batting';
          _teamBName = teamBName;
          _teamBRole = 'Bowling';
          _battingScore = newScore;
          _overs = newOvers;
          _baseRunRate = currentRunRate;
          _currentRunRate = displayRunRate;
          _currentBowler = currentBowlerName;
          _thisOverBalls = thisOverBalls;
          _batsmen = newBatsmen;
          _bowlers = newBowlers;
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
      MaterialPageRoute(
        builder: (_) => StadiumCheckInScreen(
          tournamentName: _tournamentName,
          location: _location,
          roundLabel: _roundLabel,
          teamAName: _teamAName,
          teamBName: _teamBName,
          teamARole: _teamARole,
          teamBRole: _teamBRole,
        ),
      ),
    );
  }

  void _openPredictorLeaderboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PredictorLeaderboardScreen(
          tournamentName: _tournamentName,
          location: _location,
        ),
      ),
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
                            _tournamentName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.white38, size: 12),
                              const SizedBox(width: 3),
                              Text(_location, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                const LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: Colors.transparent,
                  minHeight: 2,
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchLiveScore,
                  color: AppColors.primary,
                  backgroundColor: AppColors.authBackgroundBottom,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                    children: [
                      MatchStatusPills(roundLabel: _roundLabel),
                      const SizedBox(height: 18),
                      TeamMatchupRow(
                        teamAName: _teamAName,
                        teamARole: _teamARole,
                        teamBName: _teamBName,
                        teamBRole: _teamBRole,
                      ),
                      const SizedBox(height: 18),
                      LiveScorePanel(
                        teamAName: _teamAName,
                        teamAInitials: _teamAInitials,
                        teamAColor: _teamAColor,
                        battingScore: _battingScore,
                        overs: _overs,
                        currentRunRate: _currentRunRate,
                        currentBowler: _currentBowler,
                        thisOverBalls: _thisOverBalls,
                      ),
                      const SizedBox(height: 26),
                      const Text('Batsman', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      BatsmanStatsTable(batsmen: _batsmen),
                      const SizedBox(height: 24),
                      const Text('Bowler', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      BowlerStatsTable(bowlers: _bowlers),
                      const SizedBox(height: 24),
                      const Text('Fan Reactions', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      FanReactionsRow(likeCount: _likeCount, fireCount: _fireCount, onLike: () {}, onFire: () {}, onShare: () {}),
                      const SizedBox(height: 22),
                      PredictEarnCard(teamAName: _teamAName, teamBName: _teamBName),
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
                        teamAName: _teamAName,
                        teamBName: _teamBName,
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
