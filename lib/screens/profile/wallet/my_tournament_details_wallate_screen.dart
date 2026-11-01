import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sporto/screens/profile/tournaments/match_result_details_screen.dart';
import 'package:sporto/screens/profile/tournaments/widgets/squad_player_stat_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../models/my_tournament_info.dart';
import '../../tournament/widgets/tournament_stat_box.dart';

/// User's tournament recap: summary, prize, squad stats, and match results.
class MyTournamentDetailswallateScreen extends StatefulWidget {
  const MyTournamentDetailswallateScreen({super.key});

  @override
  State<MyTournamentDetailswallateScreen> createState() =>
      _MyTournamentDetailswallateScreenState();
}

class _MyTournamentDetailswallateScreenState
    extends State<MyTournamentDetailswallateScreen> {
  int _tab = 0;

  // Static demo data. Replace these values whenever you want to test
  // different tournament, squad, or match details.
  final List<MyTournamentPlayerStat> _squad = [
    MyTournamentPlayerStat(
      name: 'Suyog Dhobe',
      role: 'Captain • Thunder Strikers',
      runs: 248,
      wickets: 8,
      isYou: true,
    ),
    MyTournamentPlayerStat(
      name: 'Rahul Sharma',
      role: 'Player • Thunder Strikers',
      runs: 186,
      wickets: 5,
      isYou: false,
    ),
    MyTournamentPlayerStat(
      name: 'Amit Patil',
      role: 'Player • Thunder Strikers',
      runs: 142,
      wickets: 12,
      isYou: false,
    ),
    MyTournamentPlayerStat(
      name: 'Kunal More',
      role: 'Player • Thunder Strikers',
      runs: 96,
      wickets: 9,
      isYou: false,
    ),
    MyTournamentPlayerStat(
      name: 'Pratik Jadhav',
      role: 'Player • Thunder Strikers',
      runs: 74,
      wickets: 3,
      isYou: false,
    ),
  ];

  final List<MyTournamentMatchResult> _matches = [
    MyTournamentMatchResult(
      matchLabel: 'League Stage — Match 1',
      teamA: 'Thunder Strikers',
      teamB: 'Royal Challengers',
      scoreA: '156/6 (20)',
      scoreB: '142/8 (20)',
      rawMatch: {
        'id': 1001,
        'match_number': 1,
        'status_key': 'COMPLETED',
        'status_label': 'Completed',
        'round': {'name': 'League Stage'},
        'team_a': {
          'id': '1',
          'name': 'Thunder Strikers',
          'score': '156/6',
          'overs': '20',
        },
        'team_b': {
          'id': '2',
          'name': 'Royal Challengers',
          'score': '142/8',
          'overs': '20',
        },
        'result': {
          'winner_team_id': '1',
          'result_text': 'Thunder Strikers won by 14 runs',
        },
      },
    ),
    MyTournamentMatchResult(
      matchLabel: 'League Stage — Match 4',
      teamA: 'Thunder Strikers',
      teamB: 'Kings XI',
      scoreA: '178/5 (20)',
      scoreB: '169/9 (20)',
      rawMatch: {
        'id': 1002,
        'match_number': 4,
        'status_key': 'COMPLETED',
        'status_label': 'Completed',
        'round': {'name': 'League Stage'},
        'team_a': {
          'id': '1',
          'name': 'Thunder Strikers',
          'score': '178/5',
          'overs': '20',
        },
        'team_b': {
          'id': '3',
          'name': 'Kings XI',
          'score': '169/9',
          'overs': '20',
        },
        'result': {
          'winner_team_id': '1',
          'result_text': 'Thunder Strikers won by 9 runs',
        },
      },
    ),
    MyTournamentMatchResult(
      matchLabel: 'Semi Final — Match 7',
      teamA: 'Thunder Strikers',
      teamB: 'Warriors Club',
      scoreA: '134/7 (20)',
      scoreB: '130/9 (20)',
      rawMatch: {
        'id': 1003,
        'match_number': 7,
        'status_key': 'COMPLETED',
        'status_label': 'Completed',
        'round': {'name': 'Semi Final'},
        'team_a': {
          'id': '1',
          'name': 'Thunder Strikers',
          'score': '134/7',
          'overs': '20',
        },
        'team_b': {
          'id': '4',
          'name': 'Warriors Club',
          'score': '130/9',
          'overs': '20',
        },
        'result': {
          'winner_team_id': '1',
          'result_text': 'Thunder Strikers won by 4 runs',
        },
      },
    ),
    MyTournamentMatchResult(
      matchLabel: 'Final — Match 10',
      teamA: 'Thunder Strikers',
      teamB: 'Super Kings',
      scoreA: '192/4 (20)',
      scoreB: '181/8 (20)',
      rawMatch: {
        'id': 1004,
        'match_number': 10,
        'status_key': 'COMPLETED',
        'status_label': 'Completed',
        'round': {'name': 'Final'},
        'team_a': {
          'id': '1',
          'name': 'Thunder Strikers',
          'score': '192/4',
          'overs': '20',
        },
        'team_b': {
          'id': '5',
          'name': 'Super Kings',
          'score': '181/8',
          'overs': '20',
        },
        'result': {
          'winner_team_id': '1',
          'result_text': 'Thunder Strikers won by 11 runs',
        },
      },
    ),
  ];

  String _resolveTitle() => '1011 T Cricket League';

  String _resolveDateRange() => 'Aug 10 – Aug 19, 2026';

  String _resolveLocation() => 'Pune, Maharashtra';

  String _resolveChampionTeam() => 'Thunder Strikers';

  String _resolvePrizeAmount() => '₹60,000';

  String _resolvePrizeCaption() => 'Total Prize Pool • Winner: ₹60,000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Text(
                      'Tournaments Details',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    _SummaryCard(
                      title: _resolveTitle(),
                      dateRange: _resolveDateRange(),
                      location: _resolveLocation(),
                      championTeam: _resolveChampionTeam(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TournamentStatBox(value: '4', label: 'Played'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TournamentStatBox(value: '4', label: 'Won'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TournamentStatBox(value: '0', label: 'Lost'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TournamentStatBox(
                            value: '#1',
                            label: 'Final Rank',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _PrizeBar(
                      amount: _resolvePrizeAmount(),
                      caption: _resolvePrizeCaption(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _TabLabel(
                          label: 'Squad Performance',
                          selected: _tab == 0,
                          onTap: () => setState(() => _tab = 0),
                        ),
                        const SizedBox(width: 22),
                        _TabLabel(
                          label: 'Match Results',
                          selected: _tab == 1,
                          onTap: () => setState(() => _tab = 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (_tab == 0)
                      for (final player in _squad) ...[
                        SquadPlayerStatCard(player: player),
                        const SizedBox(height: 10),
                      ]
                    else
                      for (final match in _matches) ...[
                        _MatchResultCard(
                          match: match,
                          onView: () {
                            MatchResultDetailsScreen.show(
                              context,
                              match: match,
                              tournamentTitle: _resolveTitle(),
                              dateRange: _resolveDateRange(),
                            );
                          },
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

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.quicksand(
              color: selected ? Colors.white : Colors.white54,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2.5,
            width: selected ? 28 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A1E),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.dateRange,
    required this.location,
    required this.championTeam,
  });

  final String title;
  final String dateRange;
  final String location;
  final String championTeam;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2233),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                dateRange,
                style: GoogleFonts.quicksand(
                  color: Colors.white54,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white54,
                size: 14,
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  location,
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (championTeam.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.amberAccent,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Champions',
                          style: GoogleFonts.quicksand(
                            color: const Color(0xFFFF8A1E),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          championTeam,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrizeBar extends StatelessWidget {
  const _PrizeBar({required this.amount, required this.caption});

  final String amount;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B3A2A), Color(0xFF15241C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prize Money Earned',
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  caption,
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.emoji_events_rounded,
            color: AppColors.amberAccent,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            amount,
            style: GoogleFonts.quicksand(
              color: AppColors.amberAccent,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchResultCard extends StatelessWidget {
  const _MatchResultCard({required this.match, this.onView});

  final MyTournamentMatchResult match;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onView,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2128),
          borderRadius: BorderRadius.circular(16),
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
                        style: GoogleFonts.quicksand(
                          color: Colors.white54,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Vs',
                  style: GoogleFonts.quicksand(
                    color: Colors.white38,
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
                        style: GoogleFonts.quicksand(
                          color: Colors.white54,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.matchLabel,
                    style: GoogleFonts.quicksand(
                      color: Colors.white54,
                      fontSize: 12.5,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Results',
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white54,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
