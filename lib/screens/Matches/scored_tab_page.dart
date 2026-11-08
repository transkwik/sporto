// ═════════════════════════════════════════════════════════════════════
// Scorecard tab (summary card, innings toggle, batting, FOW, bowling)
//
// Expected keys per innings in `scoring['innings']` (all read defensively,
// rename to match your backend):
//   innings_number, batting_team{name}, score|total, wickets, overs,
//   batting[{player_id,name,runs,balls_faced,fours,sixes,strike_rate,
//            status,dismissal,sponsor}],
//   bowling[{player_id,name,overs,maidens,runs_conceded,wickets,
//            economy_rate,sponsor}],
//   extras{byes,leg_byes,wides,no_balls,total},
//   fall_of_wickets[{player_id,name,score,wicket_number,over}]
// ═════════════════════════════════════════════════════════════════════

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

class _ScorecardTab extends StatefulWidget {
  const _ScorecardTab({
    required this.innings,
    required this.currentInnings,
    required this.resolveName,
    required this.isCaptain,
    required this.teamName,
    required this.teamInitials,
    required this.battingScore,
    required this.overs,
    required this.otherTeamLabel,
    required this.otherTeamScore,
    required this.crr,
    required this.rrr,
    required this.statusText,
    required this.inningsBadge,
  });

  final List<Map<String, dynamic>> innings;
  final int currentInnings;
  final String Function(dynamic id, dynamic inlineName) resolveName;
  final bool Function(dynamic id) isCaptain;
  final String teamName;
  final String teamInitials;
  final String battingScore;
  final String overs;
  final String otherTeamLabel;
  final String otherTeamScore;
  final String crr;
  final String rrr;
  final String statusText;
  final String inningsBadge;

  @override
  State<_ScorecardTab> createState() => _ScorecardTabState();
}

class _ScorecardTabState extends State<_ScorecardTab> {
  static const _card = Color(0xFF161C2E);
  static const _head = Color(0xFF283250);
  static const _rowBg = Color(0xFF0E1320);
  static const _green = Color(0xFF2ECC71);
  static const _orange = Color(0xFFF2A500);
  static const _blue = Color(0xFF3DB2F0);

  int? _sel; // null => follow current innings

  int get _selected {
    if (_sel != null && _sel! < widget.innings.length) return _sel!;
    final i = widget.innings.indexWhere(
      (e) => e['innings_number']?.toString() == '${widget.currentInnings}',
    );
    return i < 0 ? 0 : i;
  }

  String _s(dynamic v, [String f = '0']) => v == null ? f : v.toString();
  int _i(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;
  String _d1(dynamic v) =>
      (double.tryParse(v?.toString() ?? '') ?? 0).toStringAsFixed(1);
  String _d2(dynamic v) =>
      (double.tryParse(v?.toString() ?? '') ?? 0).toStringAsFixed(2);

  String _inningsName(int idx) {
    final inn = widget.innings[idx];
    final n = inn['batting_team']?['name'] ?? inn['team_name'];
    return n?.toString() ?? 'Innings ${idx + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final sel = widget.innings.isEmpty ? null : _selected;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        _summaryCard(),
        if (sel != null) ...[
          const SizedBox(height: 20),
          _inningsToggle(sel),
          const SizedBox(height: 18),
          ..._inningsBody(widget.innings[sel]),
        ],
      ],
    );
  }

  // ───────── Summary card ─────────
  Widget _summaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A3A2A), Color(0xFF1C3A2A)],
              ),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.teamInitials,
                        style: const TextStyle(
                          color: Color(0xFF0B1530),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.teamName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                widget.battingScore,
                                style: const TextStyle(
                                  color: _blue,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.overs,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.inningsBadge,
                      style: const TextStyle(
                        color: _orange,
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 6),
                if (widget.otherTeamScore.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.otherTeamLabel}  ',
                            style: const TextStyle(color: Colors.white54),
                          ),
                          TextSpan(
                            text: widget.otherTeamScore,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 10),
                const _Dashed(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _rate('CRR', widget.crr),
                    _rate('RRR', widget.rrr),
                  ],
                ),
              ],
            ),
          ),
          if (widget.statusText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                widget.statusText,
                style: const TextStyle(color: _orange, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _rate(String l, String v) => Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: '$l: ',
          style: const TextStyle(color: Colors.white54),
        ),
        TextSpan(
          text: v,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
    style: const TextStyle(fontSize: 14),
  );

  // ───────── Innings toggle ─────────
  Widget _inningsToggle(int selected) {
    final count = widget.innings.length < 2 ? widget.innings.length : 2;
    return Row(
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _sel = i),
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: selected == i
                      ? const LinearGradient(
                          colors: [Color(0xFFF08A00), Color(0xFFD4A52A)],
                        )
                      : null,
                  color: selected == i ? null : _card,
                  border: Border.all(
                    color: selected == i ? Colors.transparent : Colors.white12,
                  ),
                ),
                child: Text(
                  _inningsName(i),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected == i ? Colors.white : Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ───────── Innings body ─────────
  List<Widget> _inningsBody(Map<String, dynamic> inn) {
    final batting = (inn['batting'] as List?)?.whereType<Map>().toList() ?? [];
    final bowling = (inn['bowling'] as List?)?.whereType<Map>().toList() ?? [];
    final fow =
        (inn['fall_of_wickets'] as List?)?.whereType<Map>().toList() ?? [];
    final total = _s(inn['score'] ?? inn['total']);
    final wkts = _s(inn['wickets']);
    final ov = _s(inn['overs']);

    return [
      Text(
        '$total/$wkts ($ov overs)',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      _battingTable(batting, inn['extras']),
      if (fow.isNotEmpty) ...[const SizedBox(height: 22), _fowTable(fow)],
      if (bowling.isNotEmpty) ...[
        const SizedBox(height: 22),
        _bowlingTable(bowling),
      ],
    ];
  }

  Widget _frame({required Widget child}) => Container(
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white12),
    ),
    clipBehavior: Clip.antiAlias,
    child: child,
  );

  Widget _headerRow(String title, List<String> cols, List<double> widths) {
    return Container(
      color: _head,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          for (int i = 0; i < cols.length; i++)
            SizedBox(
              width: widths[i],
              child: Text(
                cols[i],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cell(String t, double w, {bool strong = false}) => SizedBox(
    width: w,
    child: Text(
      t,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: strong ? Colors.white : Colors.white54,
        fontSize: 16,
        fontWeight: strong ? FontWeight.w600 : FontWeight.w400,
      ),
    ),
  );

  Widget _nameBlock(
    String name, {
    String? sponsor,
    String? sub,
    bool captain = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sponsor != null && sponsor.isNotEmpty && sponsor != 'null')
            Text(sponsor, style: const TextStyle(color: _green, fontSize: 15)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: name),
                if (captain)
                  const TextSpan(
                    text: ' (C)',
                    style: TextStyle(color: _orange, fontSize: 14),
                  ),
              ],
            ),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          if (sub != null && sub.isNotEmpty)
            Text(
              sub,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
        ],
      ),
    );
  }

  Widget _row(Widget child, {bool last = false}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: _rowBg,
      border: Border(
        bottom: BorderSide(color: last ? Colors.transparent : Colors.white10),
      ),
    ),
    child: child,
  );

  Widget _battingTable(List<Map> batting, dynamic extras) {
    const w = [40.0, 40.0, 40.0, 40.0, 70.0];
    return _frame(
      child: Column(
        children: [
          _headerRow('Batting', ['R', 'B', '4s', '6s', 'SR'], w),
          for (int i = 0; i < batting.length; i++)
            _row(
              Row(
                children: [
                  _nameBlock(
                    widget.resolveName(
                      batting[i]['player_id'],
                      batting[i]['name'],
                    ),
                    sponsor: batting[i]['sponsor']?.toString(),
                    sub:
                        (batting[i]['dismissal'] ??
                                batting[i]['how_out'] ??
                                (batting[i]['status'] == 'not_out'
                                    ? 'not out'
                                    : ''))
                            .toString(),
                    captain:
                        batting[i]['is_captain'] == true ||
                        widget.isCaptain(batting[i]['player_id']),
                  ),
                  _cell(_s(batting[i]['runs']), w[0], strong: true),
                  _cell(_s(batting[i]['balls_faced']), w[1]),
                  _cell(_s(batting[i]['fours']), w[2]),
                  _cell(_s(batting[i]['sixes']), w[3]),
                  _cell(_d1(batting[i]['strike_rate']), w[4]),
                ],
              ),
              last: i == batting.length - 1,
            ),
          Container(
            color: _card,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Extras',
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
                Text(
                  _extrasText(extras),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _extrasText(dynamic e) {
    if (e is! Map) return '0';
    final parts = <String>[];
    void add(String k, String l) {
      final v = _i(e[k]);
      if (v > 0) parts.add('$l $v');
    }

    add('byes', 'b');
    add('leg_byes', 'lb');
    add('wides', 'w');
    add('no_balls', 'nb');
    final total = e['total'] != null
        ? _i(e['total'])
        : [
            'byes',
            'leg_byes',
            'wides',
            'no_balls',
          ].fold<int>(0, (a, k) => a + _i(e[k]));
    return parts.isEmpty ? '$total' : '$total (${parts.join(', ')})';
  }

  Widget _fowTable(List<Map> fow) {
    return _frame(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: _head,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: const Text(
              'Fall of wickets',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          for (int i = 0; i < fow.length; i++)
            _row(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.resolveName(fow[i]['player_id'], fow[i]['name']),
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    '${_s(fow[i]['score'])}-${_s(fow[i]['wicket_number'] ?? i + 1)} (${_s(fow[i]['over'])})',
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ],
              ),
              last: i == fow.length - 1,
            ),
        ],
      ),
    );
  }

  Widget _bowlingTable(List<Map> bowling) {
    const w = [44.0, 40.0, 44.0, 40.0, 70.0];
    return _frame(
      child: Column(
        children: [
          _headerRow('Bowling', ['O', 'M', 'R', 'W', 'Econ'], w),
          for (int i = 0; i < bowling.length; i++)
            _row(
              Row(
                children: [
                  _nameBlock(
                    widget.resolveName(
                      bowling[i]['player_id'],
                      bowling[i]['name'],
                    ),
                    sponsor: bowling[i]['sponsor']?.toString(),
                    captain:
                        bowling[i]['is_captain'] == true ||
                        widget.isCaptain(bowling[i]['player_id']),
                  ),
                  _cell(_s(bowling[i]['overs'], '0.0'), w[0], strong: true),
                  _cell(_s(bowling[i]['maidens']), w[1]),
                  _cell(_s(bowling[i]['runs_conceded']), w[2]),
                  _cell(_s(bowling[i]['wickets']), w[3]),
                  _cell(_d2(bowling[i]['economy_rate']), w[4]),
                ],
              ),
              last: i == bowling.length - 1,
            ),
        ],
      ),
    );
  }
}

class _Dashed extends StatelessWidget {
  const _Dashed();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) {
      final n = (c.maxWidth / 8).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          n,
          (_) => Container(width: 4, height: 1, color: Colors.white24),
        ),
      );
    },
  );
}
