import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/my_tournament_info.dart';

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
    _BatterLine('A. Patel', 'run out', 24, 19),
    _BatterLine('K. Mehta', 'b Sharma', 18, 14),
    _BatterLine('R. Iyer', 'c wk b Sharma', 16, 12),
    _BatterLine('V. Nair', 'not out', 12, 11),
    _BatterLine('S. Rao', 'b Khan', 10, 8),
  ],
  bowling: [
    _BowlerLine('R. Sharma', '4', 26, 3),
    _BowlerLine('A. Khan', '4', 31, 1),
    _BowlerLine('M. Singh', '4', 28, 1),
    _BowlerLine('P. Verma', '4', 33, 0),
    _BowlerLine('T. Das', '4', 20, 1),
  ],
);

const _awayInnings = _Innings(
  score: '148/9',
  oversLabel: '20 overs',
  extras: 11,
  batting: [
    _BatterLine('R. Sharma', 'c & b Patel', 41, 29),
    _BatterLine('A. Khan', 'b Iyer', 22, 18),
    _BatterLine('M. Singh', 'run out', 19, 16),
    _BatterLine('P. Verma', 'c wk b Rao', 17, 14),
    _BatterLine('T. Das', 'b Patel', 14, 12),
    _BatterLine('S. Gill', 'not out', 9, 8),
  ],
  bowling: [
    _BowlerLine('You', '4', 22, 2),
    _BowlerLine('S. Rao', '4', 24, 2),
    _BowlerLine('A. Patel', '4', 27, 1),
    _BowlerLine('R. Iyer', '4', 30, 1),
    _BowlerLine('K. Mehta', '4', 34, 1),
  ],
);

/// Full match scorecard opened from a My Tournaments match-result card.
class MatchResultDetailsScreen extends StatefulWidget {
  const MatchResultDetailsScreen({super.key, required this.match});

  final MyTournamentMatchResult match;

  @override
  State<MatchResultDetailsScreen> createState() => _MatchResultDetailsScreenState();
}

class _MatchResultDetailsScreenState extends State<MatchResultDetailsScreen> {
  int _teamIndex = 0;

  MyTournamentMatchResult get match => widget.match;

  _Innings get _innings => _teamIndex == 0 ? _homeInnings : _awayInnings;

  @override
  Widget build(BuildContext context) {
    final innings = _innings;

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
                        color: Colors.white54,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Match Results',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(Icons.close_rounded, color: Colors.white70, size: 22),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _ScoreSummary(match: match),
                          const SizedBox(height: 16),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Batting',
                            style: GoogleFonts.quicksand(
                              color: AppColors.infoBlue,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const _StatHeader(left: 'Batter', right: ['R', 'B']),
                          const SizedBox(height: 8),
                          for (final batter in innings.batting) ...[
                            _BatterRow(batter: batter),
                            const SizedBox(height: 10),
                          ],
                          _ExtrasRow(extras: innings.extras),
                          const SizedBox(height: 18),
                          Text(
                            'Bowling',
                            style: GoogleFonts.quicksand(
                              color: AppColors.infoBlue,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const _StatHeader(left: 'Bowler', right: ['O', 'R', 'W']),
                          const SizedBox(height: 8),
                          for (final bowler in innings.bowling) ...[
                            _BowlerRow(bowler: bowler),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
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

class _ScoreSummary extends StatelessWidget {
  const _ScoreSummary({required this.match});

  final MyTournamentMatchResult match;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
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
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(match.scoreA, style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
              Text('Vs', style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w600)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      match.teamB,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(match.scoreB, style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.bannerGradient : null,
          color: selected ? null : const Color(0xFF2A2E38),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
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
          child: Text(left, style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
        ),
        for (final label in right)
          SizedBox(
            width: 36,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
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
                  fontSize: 14,
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
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${batter.balls}',
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
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
          child: Text('Extras', style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          width: 72,
          child: Text(
            '$extras',
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
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
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(bowler.overs, textAlign: TextAlign.right, style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5)),
        ),
        SizedBox(
          width: 36,
          child: Text('${bowler.runs}', textAlign: TextAlign.right, style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5)),
        ),
        SizedBox(
          width: 36,
          child: Text('${bowler.wickets}', textAlign: TextAlign.right, style: GoogleFonts.quicksand(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
