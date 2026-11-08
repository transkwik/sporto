import 'package:flutter/material.dart';

class ScorecardTab extends StatefulWidget {
  const ScorecardTab({
    super.key,
    this.innings = const [],
    this.currentInnings = 1,
    this.resolveName = _defaultResolveName,
    this.isCaptain = _defaultIsCaptain,
    this.teamName = 'Hyd Highlanders',
    this.teamInitials = 'HH',
    this.battingScore = '80/2',
    this.overs = '4/6',
    this.otherTeamLabel = 'Delhi W',
    this.otherTeamScore = '102/5 (6.0)',
    this.crr = '12.25',
    this.rrr = '12.00',
    this.statusText = 'Hyd Highlanders need 22 runs in 12 balls',
    this.inningsBadge = '1',
  });

  final List<dynamic> innings;
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

  static String _defaultResolveName(dynamic id, dynamic inlineName) =>
      inlineName?.toString() ?? 'Player';
  static bool _defaultIsCaptain(dynamic id) => false;

  @override
  State<ScorecardTab> createState() => _ScorecardTabState();
}

class _ScorecardTabState extends State<ScorecardTab> {
  static const Color _background = Color(0xFF090D12);
  static const Color _card = Color(0xFF1B2233);
  static const Color _header = Color(0xFF293244);
  static const Color _rowBackground = Color(0xFF090D12);

  static const Color _green = Color(0xFF16B978);
  static const Color _orange = Color(0xFFFFA900);
  static const Color _blue = Color(0xFF55C2F5);
  static const Color _muted = Color(0xFF92959D);

  int? _selectedInnings;

  @override
  void initState() {
    super.initState();
    // When no real data is supplied, open on the 2nd tab (Delhi Warriors)
    // so the page matches the design screenshot.
    if (widget.innings.isEmpty) {
      _selectedInnings = 1;
    }
  }

  // Dummy fallback data if none is supplied via widget parameters
  // Always re-evaluated, so new data passed from navigation / API is used
  // (a `late final` field would cache the first value forever).
  List<dynamic> get _effectiveInnings => _ensureTwoTabs(
    widget.innings.isNotEmpty ? widget.innings : _dummyInnings,
  );

  // Guarantees the selector always shows TWO tabs, even when the caller
  // passes only one innings (e.g. 2nd innings not started yet).
  List<dynamic> _ensureTwoTabs(List<dynamic> source) {
    final list = List<dynamic>.from(source);
    while (list.length < 2) {
      list.add({
        'innings_number': list.length + 1,
        'batting_team': {
          'name': widget.otherTeamLabel.isNotEmpty
              ? widget.otherTeamLabel
              : 'Innings ${list.length + 1}',
        },
        'score': '0',
        'wickets': '0',
        'overs': '0.0 overs',
        'extras': {'total': 0},
        'batting': [],
        'yet_to_bat': [],
        'fall_of_wickets': [],
        'bowling': [],
      });
    }
    return list;
  }

  late final List<dynamic> _dummyInnings = [
    // ---------------- Tab 1: Hyd Highlanders ----------------
    {
      'innings_number': 1,
      'batting_team': {'name': 'Hyd Highlanders'},
      'score': '80',
      'wickets': '2',
      'overs': '4.0 overs',
      'extras': {'byes': 0, 'leg_byes': 1, 'wides': 2, 'total': 3},
      'batting': [
        {
          'player_id': 'h1',
          'name': 'Rohit P.',
          'sponsor': 'Favifix Pvt Ltd',
          'runs': 34,
          'balls': 14,
          'fours': 3,
          'sixes': 3,
          'strike_rate': 242.86,
          'dismissal': 'c Amit K. b Sonia R.',
        },
        {
          'player_id': 'h2',
          'name': 'Kiran M.',
          'sponsor': 'ZotoGames',
          'runs': 21,
          'balls': 9,
          'fours': 2,
          'sixes': 2,
          'strike_rate': 233.33,
          'dismissal': 'b Neha D.',
        },
        {
          'player_id': 'h3',
          'name': 'Vikram S.',
          'sponsor': 'Banjara Sports Store',
          'runs': 15,
          'balls': 7,
          'fours': 1,
          'sixes': 1,
          'strike_rate': 214.29,
          'status': 'not_out',
        },
        {
          'player_id': 'h4',
          'name': 'Faisal R.',
          'runs': 7,
          'balls': 3,
          'fours': 1,
          'sixes': 0,
          'strike_rate': 233.33,
          'status': 'not_out',
        },
      ],
      'yet_to_bat': [
        {'player_id': 'h5', 'name': 'Ajay T.'},
        {'player_id': 'h6', 'name': 'Sanjay L.'},
        {'player_id': 'h7', 'name': 'Bilal N.'},
      ],
      'fall_of_wickets': [
        {
          'player_id': 'h2',
          'name': 'Kiran M.',
          'score': 38,
          'wicket_number': 1,
          'over': '2.1',
        },
        {
          'player_id': 'h1',
          'name': 'Rohit P.',
          'score': 66,
          'wicket_number': 2,
          'over': '3.4',
        },
      ],
      'bowling': [
        {
          'player_id': 'hb1',
          'name': 'Sonia R.',
          'sponsor': 'Favifix Pvt Ltd',
          'overs': '2.0',
          'maidens': 0,
          'runs_conceded': 41,
          'wickets': 1,
          'economy_rate': 20.5,
        },
        {
          'player_id': 'hb2',
          'name': 'Neha D.',
          'sponsor': 'HydFit Sportswear',
          'overs': '1.0',
          'maidens': 0,
          'runs_conceded': 18,
          'wickets': 1,
          'economy_rate': 18.0,
        },
        {
          'player_id': 'hb3',
          'name': 'Pooja G.',
          'overs': '1.0',
          'maidens': 0,
          'runs_conceded': 21,
          'wickets': 0,
          'economy_rate': 21.0,
        },
      ],
    },
    // ---------------- Tab 2: Delhi Warriors (default) ----------------
    {
      'innings_number': 2,
      'batting_team': {'name': 'Delhi Warriors'},
      'score': '162',
      'wickets': '6',
      'overs': '20 overs',
      'extras': {'byes': 1, 'wides': 1, 'total': 2},
      'batting': [
        {
          'player_id': '1',
          'name': 'Sameer J.',
          'sponsor': 'ZotoGames',
          'runs': 12,
          'balls': 6,
          'fours': 1,
          'sixes': 1,
          'strike_rate': 200.0,
          'dismissal': 'c Devika b Priya M.',
        },
        {
          'player_id': '2',
          'name': 'Naveen B.',
          'sponsor': 'Favifix Pvt Ltd',
          'runs': 8,
          'balls': 3,
          'fours': 0,
          'sixes': 1,
          'strike_rate': 266.7,
          'dismissal': 'b Karthik S.',
        },
        {
          'player_id': '3',
          'name': 'Imran Q.',
          'sponsor': 'Favifix Pvt Ltd',
          'runs': 8,
          'balls': 0,
          'fours': 0,
          'sixes': 1,
          'strike_rate': 266.7,
          'dismissal': 'lbw b Priya M.',
        },
        {
          'player_id': '4',
          'name': 'Ravi T.',
          'sponsor': 'Favifix Pvt Ltd',
          'runs': 8,
          'balls': 0,
          'fours': 0,
          'sixes': 1,
          'strike_rate': 266.7,
          'dismissal': 'c Meena b Arjun R.',
        },
        {
          'player_id': '5',
          'name': 'Yusuf A.',
          'runs': 8,
          'balls': 0,
          'fours': 0,
          'sixes': 1,
          'strike_rate': 266.7,
          'dismissal': 'b Karthik S.',
        },
        {
          'player_id': '6',
          'name': 'Zaid H.',
          'runs': 8,
          'balls': 0,
          'fours': 0,
          'sixes': 1,
          'strike_rate': 266.7,
          'status': 'not_out',
        },
      ],
      'yet_to_bat': [
        {'player_id': '7', 'name': 'Asif M.'},
        {'player_id': '8', 'name': 'Tarun G.'},
        {'player_id': '9', 'name': 'Omar S.'},
      ],
      'fall_of_wickets': [
        {
          'player_id': '1',
          'name': 'Sameer J.',
          'score': 5,
          'wicket_number': 1,
          'over': '0.2',
        },
        {
          'player_id': '3',
          'name': 'Imran Q.',
          'score': 47,
          'wicket_number': 2,
          'over': '4.0',
        },
        {
          'player_id': '2',
          'name': 'Naveen B.',
          'score': 47,
          'wicket_number': 3,
          'over': '4.2',
        },
      ],
      'bowling': [
        {
          'player_id': 'b1',
          'name': 'Priya M.',
          'sponsor': 'Favifix Pvt Ltd',
          'overs': '2.0',
          'maidens': 0,
          'runs_conceded': 26,
          'wickets': 3,
          'economy_rate': 13.0,
        },
        {
          'player_id': 'b2',
          'name': 'Arjun R.',
          'sponsor': 'Banjara Sports Store',
          'overs': '2.0',
          'maidens': 0,
          'runs_conceded': 16,
          'wickets': 1,
          'economy_rate': 8.0,
        },
        {
          'player_id': 'b3',
          'name': 'Karthik S.',
          'overs': '1.0',
          'maidens': 0,
          'runs_conceded': 16,
          'wickets': 0,
          'economy_rate': 16.0,
        },
        {
          'player_id': 'b4',
          'name': 'Meena K.',
          'overs': '1.0',
          'maidens': 0,
          'runs_conceded': 16,
          'wickets': 0,
          'economy_rate': 16.0,
        },
        {
          'player_id': 'b5',
          'name': 'Rahul V.',
          'overs': '1.0',
          'maidens': 0,
          'runs_conceded': 16,
          'wickets': 0,
          'economy_rate': 16.0,
        },
        {
          'player_id': 'b6',
          'name': 'Devika N.',
          'sponsor': 'HydFit Sportswear',
          'overs': '1.0',
          'maidens': 0,
          'runs_conceded': 11,
          'wickets': 1,
          'economy_rate': 11.0,
        },
      ],
    },
  ];

  int get _selected {
    if (_effectiveInnings.isEmpty) return 0;

    if (_selectedInnings != null &&
        _selectedInnings! >= 0 &&
        _selectedInnings! < _effectiveInnings.length) {
      return _selectedInnings!;
    }

    final index = _effectiveInnings.indexWhere(
      (e) =>
          e['innings_number']?.toString() == widget.currentInnings.toString(),
    );

    return index < 0 ? 0 : index;
  }

  String _string(dynamic value, [String fallback = '0']) {
    if (value == null || value.toString() == 'null') {
      return fallback;
    }
    return value.toString();
  }

  int _int(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _double(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _decimal2(dynamic value) {
    return _double(value).toStringAsFixed(2);
  }

  List _mapList(dynamic value) {
    if (value is! List) return [];
    return value.whereType<Map>().toList();
  }

  String _inningsName(int index) {
    if (index < 0 || index >= _effectiveInnings.length) {
      return 'Innings ${index + 1}';
    }
    final inn = _effectiveInnings[index];
    final team = inn['batting_team'];
    final name = team is Map ? team['name'] : inn['team_name'];
    return name?.toString() ?? 'Innings ${index + 1}';
  }

  String _playerName(Map player) {
    return widget.resolveName(player['player_id'], player['name']);
  }

  bool _isCaptain(Map player) {
    return player['is_captain'] == true ||
        widget.isCaptain(player['player_id']);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _effectiveInnings.isEmpty ? null : _selected;

    return Container(
      color: _background,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          _summaryCard(),
          if (selected != null) ...[
            const SizedBox(height: 18),
            _inningsSelector(selected),
            const SizedBox(height: 18),
            ..._inningsBody(_effectiveInnings[selected]),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // MATCH SUMMARY
  // ============================================================

  Widget _summaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF593A32),
                  Color(0xFF102D23),
                  Color(0xFF343A16),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            widget.teamInitials,
                            style: const TextStyle(
                              color: Color(0xFF14253B),
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.teamName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  widget.battingScore,
                                  style: const TextStyle(
                                    color: _blue,
                                    fontSize: 37,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 9),
                                Text(
                                  widget.overs,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.inningsBadge,
                      style: const TextStyle(
                        color: _orange,
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 8),
                if (widget.otherTeamScore.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.otherTeamLabel}   ',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: widget.otherTeamScore,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                const _DashedLine(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _rateText('CRR', widget.crr),
                    _rateText('RRR', widget.rrr),
                  ],
                ),
              ],
            ),
          ),
          if (widget.statusText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Center(
                child: Text(
                  widget.statusText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _rateText(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INNINGS SELECTOR
  // ============================================================

  Widget _inningsSelector(int selected) {
    final count = _effectiveInnings.length;

    return Row(
      children: List.generate(count, (index) {
        final isSelected = selected == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == count - 1 ? 0 : 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedInnings = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: isSelected ? null : const Color(0xFF191F2A),
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFFFF8500), Color(0xFFD5A525)],
                        )
                      : null,
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.white10,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    _inningsName(index),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ============================================================
  // INNINGS BODY
  // ============================================================

  List<Widget> _inningsBody(Map<String, dynamic> innings) {
    final batting = _mapList(innings['batting']);
    final bowling = _mapList(innings['bowling']);
    final wickets = _mapList(innings['fall_of_wickets']);

    final total = _string(innings['score'] ?? innings['total']);
    final wicketCount = _string(innings['wickets']);
    final overs = _string(innings['overs']);

    final yetToBat = _mapList(
      innings['yet_to_bat'] ?? innings['yet_to_bat_players'],
    );

    return [
      Text(
        '$total/$wicketCount ($overs)',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),
      // Yet to bat now lives INSIDE the batting card
      _battingTable(batting, innings['extras'], yetToBat),
      if (wickets.isNotEmpty) ...[
        const SizedBox(height: 22),
        _fallOfWickets(wickets),
      ],
      if (bowling.isNotEmpty) ...[
        const SizedBox(height: 22),
        _bowlingTable(bowling),
      ],
    ];
  }

  // ============================================================
  // COMMON TABLE FRAME
  // ============================================================

  Widget _tableFrame(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFF273044), width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _tableTitle(String title) {
    return Container(
      width: double.infinity,
      color: _header,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // ============================================================
  // RESPONSIVE TABLE HEADER
  // ============================================================

  Widget _columnHeader(
    String title,
    List<String> columns,
    List<double> ratios,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - 32;

        return Container(
          color: _header,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),
              for (int i = 0; i < columns.length; i++)
                SizedBox(
                  width: availableWidth * ratios[i],
                  child: Text(
                    columns[i],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // PLAYER NAME
  // ============================================================

  Widget _playerNameBlock(
    String name, {
    String? sponsor,
    String? subtitle,
    bool captain = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (sponsor != null && sponsor.isNotEmpty && sponsor != 'null')
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                sponsor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _green,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty)
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // TABLE ROW
  // ============================================================

  Widget _tableRow(Widget child, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: _rowBackground,
        border: Border(
          bottom: BorderSide(
            color: last ? Colors.transparent : const Color(0xFF222B3C),
            width: 1,
          ),
        ),
      ),
      child: child,
    );
  }

  // ============================================================
  // BATTING TABLE
  // ============================================================

  Widget _battingTable(List batting, dynamic extras, List yetToBat) {
    const ratios = [0.11, 0.11, 0.11, 0.11, 0.16];

    return _tableFrame(
      Column(
        children: [
          _columnHeader('Batting', ['R', 'B', '4s', '6s', 'SR'], ratios),
          for (int i = 0; i < batting.length; i++)
            _tableRow(
              LayoutBuilder(
                builder: (context, constraints) {
                  final numberWidth = (constraints.maxWidth - 32);
                  final player = batting[i];

                  final runs = _string(player['runs']);
                  final balls = _string(player['balls']);
                  final fours = _string(player['fours']);
                  final sixes = _string(player['sixes']);
                  final sr = _decimal2(player['strike_rate']);

                  return Row(
                    children: [
                      _playerNameBlock(
                        _playerName(player),
                        sponsor: player['sponsor']?.toString(),
                        subtitle:
                            (player['dismissal'] ??
                                    player['how_out'] ??
                                    (player['status'] == 'not_out'
                                        ? 'not out'
                                        : ''))
                                .toString(),
                        captain: _isCaptain(player),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[0],
                        child: _centerCell(runs, strong: true),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[1],
                        child: _centerCell(balls),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[2],
                        child: _centerCell(fours),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[3],
                        child: _centerCell(sixes),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[4],
                        child: _centerCell(sr),
                      ),
                    ],
                  );
                },
              ),
              last: i == batting.length - 1,
            ),
          _extrasRow(extras),
          if (yetToBat.isNotEmpty) _yetToBatSection(yetToBat),
        ],
      ),
    );
  }

  Widget _centerCell(String value, {bool strong = false}) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: strong ? Colors.white : _muted,
        fontSize: 14,
        fontWeight: strong ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _extrasRow(dynamic extras) {
    return Container(
      color: _card,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Extras', style: TextStyle(color: _muted, fontSize: 16)),
          Text(
            _extrasText(extras),
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }

  String _extrasText(dynamic extras) {
    if (extras is! Map) return '0';

    final parts = <String>[];

    void add(String key, String label) {
      final value = _int(extras[key]);
      if (value > 0) {
        parts.add('$label $value');
      }
    }

    add('byes', 'b');
    add('leg_byes', 'lb');
    add('wides', 'w');
    add('no_balls', 'nb');

    final total = extras['total'] != null
        ? _int(extras['total'])
        : _int(extras['byes']) +
              _int(extras['leg_byes']) +
              _int(extras['wides']) +
              _int(extras['no_balls']);

    return parts.isEmpty ? '$total' : '$total (${parts.join(', ')})';
  }

  // ============================================================
  // YET TO BAT (inside the batting card, under Extras)
  // ============================================================

  Widget _yetToBatSection(List players) {
    final names = players.map((p) => _playerName(p as Map)).join(', ');

    return Container(
      width: double.infinity,
      color: _card,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Yet to bat: ',
              style: TextStyle(color: _muted, fontSize: 13),
            ),
            TextSpan(
              text: names,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FALL OF WICKETS
  // ============================================================

  Widget _fallOfWickets(List wickets) {
    return _tableFrame(
      Column(
        children: [
          _tableTitle('Fall of wickets'),
          for (int i = 0; i < wickets.length; i++)
            _tableRow(
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _playerName(wickets[i]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_string(wickets[i]['score'])}-'
                    '${_string(wickets[i]['wicket_number'] ?? i + 1)} '
                    '(${_string(wickets[i]['over'])})',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              last: i == wickets.length - 1,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // BOWLING TABLE
  // ============================================================

  Widget _bowlingTable(List bowling) {
    const ratios = [0.10, 0.09, 0.10, 0.09, 0.14];

    return _tableFrame(
      Column(
        children: [
          _columnHeader('Bowling', ['O', 'M', 'R', 'W', 'Econ'], ratios),
          for (int i = 0; i < bowling.length; i++)
            _tableRow(
              LayoutBuilder(
                builder: (context, constraints) {
                  final numberWidth = (constraints.maxWidth - 32);

                  return Row(
                    children: [
                      _playerNameBlock(
                        _playerName(bowling[i]),
                        sponsor: bowling[i]['sponsor']?.toString(),
                        captain: _isCaptain(bowling[i]),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[0],
                        child: _centerCell(
                          _string(bowling[i]['overs'], '0.0'),
                          strong: true,
                        ),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[1],
                        child: _centerCell(_string(bowling[i]['maidens'])),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[2],
                        child: _centerCell(
                          _string(bowling[i]['runs_conceded']),
                        ),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[3],
                        child: _centerCell(_string(bowling[i]['wickets'])),
                      ),
                      SizedBox(
                        width: numberWidth * ratios[4],
                        child: _centerCell(
                          _decimal2(bowling[i]['economy_rate']),
                        ),
                      ),
                    ],
                  );
                },
              ),
              last: i == bowling.length - 1,
            ),
        ],
      ),
    );
  }
}

// ============================================================
// DASHED LINE
// ============================================================

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / 9).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (index) => Container(height: 1, width: 4, color: Colors.white24),
          ),
        );
      },
    );
  }
}
