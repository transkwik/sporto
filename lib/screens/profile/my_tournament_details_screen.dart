import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/my_tournament_info.dart';
import '../tournament/widgets/tournament_stat_box.dart';
import 'match_result_details_screen.dart';
import 'widgets/squad_player_stat_card.dart';

/// User's tournament recap: summary, prize, squad stats, and match results.
class MyTournamentDetailsScreen extends StatefulWidget {
  const MyTournamentDetailsScreen({super.key, required this.tournament});

  final MyTournamentInfo tournament;

  @override
  State<MyTournamentDetailsScreen> createState() => _MyTournamentDetailsScreenState();
}

class _MyTournamentDetailsScreenState extends State<MyTournamentDetailsScreen> {
  int _tab = 0;

  MyTournamentInfo get t => widget.tournament;

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
                    _SummaryCard(tournament: t),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TournamentStatBox(value: '${t.played}', label: 'Played')),
                        const SizedBox(width: 8),
                        Expanded(child: TournamentStatBox(value: '${t.won}', label: 'Won')),
                        const SizedBox(width: 8),
                        Expanded(child: TournamentStatBox(value: '${t.lost}', label: 'Lost')),
                        const SizedBox(width: 8),
                        Expanded(child: TournamentStatBox(value: t.finalRank > 0 ? '${t.finalRank}' : '—', label: 'Final Rank')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _PrizeBar(amount: t.prizeEarned, caption: t.prizeCaption),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _TabLabel(label: 'Squad Performance', selected: _tab == 0, onTap: () => setState(() => _tab = 0)),
                        const SizedBox(width: 22),
                        _TabLabel(label: 'Match Results', selected: _tab == 1, onTap: () => setState(() => _tab = 1)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (_tab == 0)
                      for (final player in t.squad) ...[
                        SquadPlayerStatCard(player: player),
                        const SizedBox(height: 10),
                      ]
                    else
                      for (final match in t.matchResults) ...[
                        _MatchResultCard(
                          match: match,
                          onView: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MatchResultDetailsScreen(match: match),
                              ),
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
  const _TabLabel({required this.label, required this.selected, required this.onTap});

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
  const _SummaryCard({required this.tournament});

  final MyTournamentInfo tournament;

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
                  tournament.title,
                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                tournament.dateRange,
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white54, size: 14),
              const SizedBox(width: 3),
              Text(
                tournament.location,
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          if (tournament.championTeam.isNotEmpty) ...[
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
                  const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 22),
                  const SizedBox(width: 10),
                  Column(
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
                        tournament.championTeam,
                        style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
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
                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  caption,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 20),
          const SizedBox(width: 6),
          Text(
            amount,
            style: GoogleFonts.quicksand(color: AppColors.amberAccent, fontSize: 18, fontWeight: FontWeight.w800),
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
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
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
                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      match.teamB,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  match.matchLabel,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Results',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 18),
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
