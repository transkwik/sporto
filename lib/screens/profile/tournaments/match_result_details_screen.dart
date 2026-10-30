import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/apiServices/user_api.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/match_data_parser.dart';
import '../../../models/my_tournament_info.dart';

class _BatterLine {
  const _BatterLine(this.name, this.dismissal, this.runs, this.balls, {this.isYou = false});
  final String name;
  final String dismissal;
  final int runs;
  final int balls;
  final bool isYou;
}

class _BowlerLine {
  const _BowlerLine(this.name, this.overs, this.runs, this.wickets);
  final String name;
  final String overs;
  final int runs;
  final int wickets;
}

class _Innings {
  const _Innings({
    required this.score,
    required this.oversLabel,
    required this.extras,
    required this.batting,
    required this.bowling,
  });

  final String score;
  final String oversLabel;
  final int extras;
  final List<_BatterLine> batting;
  final List<_BowlerLine> bowling;
}

const _homeInnings = _Innings(
  score: '162/6',
  oversLabel: '20 overs',
  extras: 24,
  batting: [
    _BatterLine('You', 'c wk b Sharma', 58, 34, isYou: true),
    _BatterLine('Rohit Naik', 'run out', 22, 16),
    _BatterLine('Sandeep Rao', 'c Yusuf b Sharma', 34, 26),
    _BatterLine('Vikram Chowdary', 'b Sharma', 18, 14),
    _BatterLine('Kiran Varma', 'lbw b Iqbal', 4, 6),
    _BatterLine('Farhan Ali', 'not out', 2, 3),
  ],
  bowling: [
    _BowlerLine('R. Sharma', '4', 26, 3),
    _BowlerLine('A. Iqbal', '4', 30, 1),
    _BowlerLine('M. Yusuf', '3', 28, 0),
    _BowlerLine('S. Reddy', '3', 32, 0),
  ],
);

const _awayInnings = _Innings(
  score: '148/9',
  oversLabel: '20 overs',
  extras: 22,
  batting: [
    _BatterLine('R. Sharma', 'b Kiran Varma', 42, 29),
    _BatterLine('A. Iqbal', 'c Naik b Farhan Ali', 35, 26),
    _BatterLine('M. Yusuf', 'run out', 28, 20),
    _BatterLine('S. Reddy*', 'not out', 21, 15),
  ],
  bowling: [
    _BowlerLine('Kiran Varma', '4', 22, 3),
    _BowlerLine('Farhan Ali', '4', 28, 2),
    _BowlerLine('Rohit Naik', '3', 25, 2),
    _BowlerLine('Vikram Chowdary', '3', 30, 1),
  ],
);

/// Match Results bottom sheet / screen opened from a tournament match-result card.
class MatchResultDetailsScreen extends StatefulWidget {
  const MatchResultDetailsScreen({
    super.key,
    required this.match,
    this.tournamentTitle = 'Asia Cup 2026',
    this.dateRange = 'Aug 2 – 10, 2026',
    this.isBottomSheet = false,
  });

  final MyTournamentMatchResult match;
  final String tournamentTitle;
  final String dateRange;
  final bool isBottomSheet;

  /// Shows the Match Results modal bottom sheet over Tournament Details.
  static Future<void> show(
    BuildContext context, {
    required MyTournamentMatchResult match,
    String tournamentTitle = '',
    String dateRange = '',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.88,
        child: MatchResultDetailsScreen(
          match: match,
          tournamentTitle: tournamentTitle,
          dateRange: dateRange,
          isBottomSheet: true,
        ),
      ),
    );
  }

  @override
  State<MatchResultDetailsScreen> createState() => _MatchResultDetailsScreenState();
}

class _MatchResultDetailsScreenState extends State<MatchResultDetailsScreen> {
  int _teamIndex = 0;
  bool _isLoadingScorecard = false;
  _Innings? _teamAInnings;
  _Innings? _teamBInnings;

  MyTournamentMatchResult get match => widget.match;

  @override
  void initState() {
    super.initState();
    if (match.rawMatch != null) {
      _isLoadingScorecard = true;
      _fetchMatchScorecard();
    }
  }

  _Innings _buildInningsFromRaw(
    Map<String, dynamic> raw, {
    required bool isTeamA,
    List<_BatterLine>? parsedBatting,
    List<_BowlerLine>? parsedBowling,
  }) {
    final sideTeam = MatchDataParser.team(raw, isA: isTeamA);
    final teamsMap = raw['scoring']?['score']?['teams'];
    final teamScoreMap = (sideTeam.id != null && teamsMap is Map && teamsMap[sideTeam.id] is Map)
        ? teamsMap[sideTeam.id] as Map
        : null;

    final runs = teamScoreMap?['score']?.toString() ?? '0';
    final wickets = teamScoreMap?['wickets']?.toString() ?? '0';
    final overs = teamScoreMap?['overs']?.toString() ?? '0';

    final extrasMap = teamScoreMap?['extras'] is Map ? teamScoreMap!['extras'] as Map : null;
    final totalExtras = int.tryParse(extrasMap?['total']?.toString() ?? '') ?? 0;

    return _Innings(
      score: '$runs/$wickets',
      oversLabel: '$overs overs',
      extras: totalExtras,
      batting: parsedBatting ?? const [],
      bowling: parsedBowling ?? const [],
    );
  }

  Future<void> _fetchMatchScorecard() async {
    final raw = match.rawMatch;
    if (raw == null) {
      setState(() => _isLoadingScorecard = false);
      return;
    }

    final matchId = int.tryParse(raw['id']?.toString() ?? '');
    if (matchId == null) {
      setState(() {
        _teamAInnings = _buildInningsFromRaw(raw, isTeamA: true);
        _teamBInnings = _buildInningsFromRaw(raw, isTeamA: false);
        _isLoadingScorecard = false;
      });
      return;
    }

    setState(() => _isLoadingScorecard = true);
    try {
      final response = await UserApis().getLiveScore(matchId);
      if (response != null && response['success'] == true && response['data'] is Map) {
        final data = Map<String, dynamic>.from(response['data'] as Map);
        final scoring = data['scoring'] as Map<String, dynamic>?;
        final runtime = scoring?['runtime'] as Map<String, dynamic>?;
        final events = runtime?['events'] as List<dynamic>? ?? [];

        final teamA = MatchDataParser.team(raw, isA: true);
        final teamB = MatchDataParser.team(raw, isA: false);
        final teamAId = int.tryParse(teamA.id ?? '');
        final teamBId = int.tryParse(teamB.id ?? '');

        // Resolve player names from teams or getTeamPlayers
        final Map<int, String> playerNames = {};
        final Map<int, bool> playerIsCaptain = {};
        final Map<int, List<int>> teamPlayerIds = {};

        final futures = <Future<dynamic>>[];
        if (teamAId != null) futures.add(UserApis().getTeamPlayers(teamAId));
        if (teamBId != null && teamBId != teamAId) futures.add(UserApis().getTeamPlayers(teamBId));

        if (futures.isNotEmpty) {
          final results = await Future.wait(futures);
          for (var i = 0; i < results.length; i++) {
            final res = results[i];
            final tId = (i == 0) ? teamAId : teamBId;
            if (res != null && res['success'] == true && res['data'] is List) {
              for (final p in res['data']) {
                final uid = p['user_id'] ?? p['id'];
                String pName = (p['player_name'] ?? '').toString().trim();
                final user = p['user'];
                if (user is Map) {
                  final fullName = user['profile']?['full_name'] ?? user['display_name'] ?? user['name'];
                  if (fullName != null && fullName.toString().trim().isNotEmpty) {
                    pName = fullName.toString().trim();
                  }
                }
                final parsedUid = int.tryParse(uid?.toString() ?? '') ?? 0;
                if (parsedUid != 0) {
                  if (pName.isNotEmpty) playerNames[parsedUid] = pName;
                  if (p['is_captain'] == true) playerIsCaptain[parsedUid] = true;
                  if (tId != null) {
                    teamPlayerIds.putIfAbsent(tId, () => []).add(parsedUid);
                  }
                }
              }
            }
          }
        }

        // Parse per-inning batting & bowling from events if available
        final Map<int, Map<int, int>> innBatsmanRuns = {1: {}, 2: {}};
        final Map<int, Map<int, int>> innBatsmanBalls = {1: {}, 2: {}};
        final Map<int, Map<int, String>> innBatsmanDismissal = {1: {}, 2: {}};
        final Map<int, Map<int, int>> innBowlerRuns = {1: {}, 2: {}};
        final Map<int, Map<int, int>> innBowlerBalls = {1: {}, 2: {}};
        final Map<int, Map<int, int>> innBowlerWickets = {1: {}, 2: {}};
        final Map<int, int> inningBattingTeamId = {};

        int activeInning = 1;
        for (final ev in events) {
          if (ev is! Map) continue;
          final type = ev['type']?.toString();
          final evData = ev['data'];
          if (type == 'INNINGS_STARTED' && evData is Map) {
            activeInning = int.tryParse(evData['inning']?.toString() ?? '1') ?? 1;
            final batTid = int.tryParse(evData['batting_team_id']?.toString() ?? '');
            if (batTid != null) inningBattingTeamId[activeInning] = batTid;
          } else if (type == 'BALL_RECORDED' && evData is Map) {
            final sId = int.tryParse(evData['striker_user_id']?.toString() ?? '') ?? 0;
            final bId = int.tryParse(evData['bowler_user_id']?.toString() ?? '') ?? 0;
            final val = int.tryParse(evData['value']?.toString() ?? '') ?? 0;
            final delRuns = int.tryParse(evData['delivery_runs']?.toString() ?? '') ?? val;
            final isLegal = evData['legal_delivery'] == true || evData['legal'] == true;
            final eventCode = (evData['event_code'] ?? '').toString();

            if (sId != 0) {
              innBatsmanRuns[activeInning]![sId] = (innBatsmanRuns[activeInning]![sId] ?? 0) + (eventCode != 'WIDE' ? val : 0);
              if (isLegal) {
                innBatsmanBalls[activeInning]![sId] = (innBatsmanBalls[activeInning]![sId] ?? 0) + 1;
              }
              innBatsmanDismissal[activeInning]!.putIfAbsent(sId, () => 'not out');
            }
            if (bId != 0) {
              innBowlerRuns[activeInning]![bId] = (innBowlerRuns[activeInning]![bId] ?? 0) + delRuns;
              if (isLegal) {
                innBowlerBalls[activeInning]![bId] = (innBowlerBalls[activeInning]![bId] ?? 0) + 1;
              }
              final w = int.tryParse(evData['wickets']?.toString() ?? '') ?? 0;
              if (eventCode == 'WICKET' || w > 0) {
                innBowlerWickets[activeInning]![bId] = (innBowlerWickets[activeInning]![bId] ?? 0) + (w > 0 ? w : 1);
                if (sId != 0) {
                  final bName = playerNames[bId] ?? 'Bowler';
                  innBatsmanDismissal[activeInning]![sId] = 'b $bName';
                }
              }
            }
          }
        }

        List<_BatterLine> buildBattingForInning(int inn, int? tId) {
          final runsMap = innBatsmanRuns[inn] ?? {};
          final ballsMap = innBatsmanBalls[inn] ?? {};
          final disMap = innBatsmanDismissal[inn] ?? {};
          if (runsMap.isNotEmpty || ballsMap.isNotEmpty) {
            final ids = {...runsMap.keys, ...ballsMap.keys};
            return ids.map((id) {
              return _BatterLine(
                playerNames[id] ?? 'Player $id',
                disMap[id] ?? 'not out',
                runsMap[id] ?? 0,
                ballsMap[id] ?? 0,
                isYou: playerIsCaptain[id] == true,
              );
            }).toList();
          }
          if (tId != null && (teamPlayerIds[tId]?.isNotEmpty ?? false)) {
            return teamPlayerIds[tId]!.map((id) {
              return _BatterLine(
                playerNames[id] ?? 'Player $id',
                'not out',
                0,
                0,
                isYou: playerIsCaptain[id] == true,
              );
            }).toList();
          }
          return const [];
        }

        List<_BowlerLine> buildBowlingForInning(int inn, int? oppTeamId) {
          final runsMap = innBowlerRuns[inn] ?? {};
          final ballsMap = innBowlerBalls[inn] ?? {};
          final wMap = innBowlerWickets[inn] ?? {};
          if (runsMap.isNotEmpty || ballsMap.isNotEmpty) {
            final ids = {...runsMap.keys, ...ballsMap.keys};
            return ids.map((id) {
              final legal = ballsMap[id] ?? 0;
              final oversStr = legal % 6 == 0 ? '${legal ~/ 6}' : '${legal ~/ 6}.${legal % 6}';
              return _BowlerLine(
                playerNames[id] ?? 'Bowler $id',
                oversStr,
                runsMap[id] ?? 0,
                wMap[id] ?? 0,
              );
            }).toList();
          }
          if (oppTeamId != null && (teamPlayerIds[oppTeamId]?.isNotEmpty ?? false)) {
            return teamPlayerIds[oppTeamId]!.map((id) {
              return _BowlerLine(
                playerNames[id] ?? 'Bowler $id',
                '0',
                0,
                0,
              );
            }).toList();
          }
          return const [];
        }

        final int teamAInning = (inningBattingTeamId[2] == teamAId) ? 2 : 1;
        final int teamBInning = (teamAInning == 1) ? 2 : 1;

        if (mounted) {
          setState(() {
            _teamAInnings = _buildInningsFromRaw(
              raw,
              isTeamA: true,
              parsedBatting: buildBattingForInning(teamAInning, teamAId),
              parsedBowling: buildBowlingForInning(teamAInning, teamBId),
            );
            _teamBInnings = _buildInningsFromRaw(
              raw,
              isTeamA: false,
              parsedBatting: buildBattingForInning(teamBInning, teamBId),
              parsedBowling: buildBowlingForInning(teamBInning, teamAId),
            );
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _teamAInnings = _buildInningsFromRaw(raw, isTeamA: true);
            _teamBInnings = _buildInningsFromRaw(raw, isTeamA: false);
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching match scorecard: $e');
      if (mounted) {
        setState(() {
          _teamAInnings ??= _buildInningsFromRaw(raw, isTeamA: true);
          _teamBInnings ??= _buildInningsFromRaw(raw, isTeamA: false);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingScorecard = false);
      }
    }
  }

  _Innings get _innings {
    final raw = match.rawMatch;
    if (_teamIndex == 0) {
      return _teamAInnings ?? (raw != null ? _buildInningsFromRaw(raw, isTeamA: true) : _homeInnings);
    }
    return _teamBInnings ?? (raw != null ? _buildInningsFromRaw(raw, isTeamA: false) : _awayInnings);
  }

  @override
  Widget build(BuildContext context) {
    final innings = _innings;

    final content = Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1117),
        borderRadius: widget.isBottomSheet
            ? const BorderRadius.vertical(top: Radius.circular(26))
            : BorderRadius.zero,
        border: widget.isBottomSheet
            ? Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1)))
            : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Match Results',
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF232730),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoadingScorecard)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  _ScoreSummary(match: match),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _TeamPill(
                          label: match.teamA,
                          selected: _teamIndex == 0,
                          onTap: () => setState(() => _teamIndex = 0),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TeamPill(
                          label: match.teamB,
                          selected: _teamIndex == 1,
                          onTap: () => setState(() => _teamIndex = 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${innings.score} (${innings.oversLabel})',
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Batting',
                    style: GoogleFonts.quicksand(
                      color: AppColors.infoBlue,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151821),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Column(
                      children: [
                        const _StatHeader(left: 'Batter', right: ['R', 'B']),
                        const SizedBox(height: 12),
                        if (innings.batting.isEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'No batting stats available',
                              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ] else
                          for (final batter in innings.batting) ...[
                            _BatterRow(batter: batter),
                            const SizedBox(height: 14),
                          ],
                        Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
                        const SizedBox(height: 12),
                        _ExtrasRow(extras: innings.extras),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bowling',
                    style: GoogleFonts.quicksand(
                      color: AppColors.infoBlue,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151821),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Column(
                      children: [
                        const _StatHeader(left: 'Bowler', right: ['O', 'R', 'W']),
                        const SizedBox(height: 12),
                        if (innings.bowling.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'No bowling stats available',
                              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13),
                            ),
                          )
                        else
                          for (var i = 0; i < innings.bowling.length; i++) ...[
                            _BowlerRow(bowler: innings.bowling[i]),
                            if (i != innings.bowling.length - 1) const SizedBox(height: 14),
                          ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    if (widget.isBottomSheet) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        child: Material(
          color: Colors.transparent,
          child: content,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E1117),
      body: SafeArea(child: content),
    );
  }
}

class _ScoreSummary extends StatelessWidget {
  const _ScoreSummary({required this.match});

  final MyTournamentMatchResult match;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.teamA,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match.scoreA,
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                  ],
                ),
              ),
              Text(
                'Vs',
                style: GoogleFonts.quicksand(
                  color: Colors.white54,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      match.teamB,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match.scoreB,
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              match.matchLabel,
              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamPill extends StatelessWidget {
  const _TeamPill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFF3981A), Color(0xFFD69E2E)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: selected ? null : const Color(0xFF1B1F27),
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.quicksand(
            color: selected ? Colors.white : Colors.white54,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatHeader extends StatelessWidget {
  const _StatHeader({required this.left, required this.right});

  final String left;
  final List<String> right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(left, style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5)),
        ),
        for (final label in right)
          SizedBox(
            width: 36,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
            ),
          ),
      ],
    );
  }
}

class _BatterRow extends StatelessWidget {
  const _BatterRow({required this.batter});

  final _BatterLine batter;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                batter.name,
                style: GoogleFonts.quicksand(
                  color: batter.isYou ? AppColors.mintGreen : Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                batter.dismissal,
                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${batter.runs}',
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${batter.balls}',
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _ExtrasRow extends StatelessWidget {
  const _ExtrasRow({required this.extras});

  final int extras;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Extras',
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          width: 72,
          child: Text(
            '$extras',
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _BowlerRow extends StatelessWidget {
  const _BowlerRow({required this.bowler});

  final _BowlerLine bowler;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            bowler.name,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            bowler.overs,
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${bowler.runs}',
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${bowler.wickets}',
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
