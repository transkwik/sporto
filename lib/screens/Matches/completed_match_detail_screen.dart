import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/completed_match_detail_info.dart';

/// Completed match details: header, result cards, winner, and match summary.
class CompletedMatchDetailScreen extends StatelessWidget {
  const CompletedMatchDetailScreen({super.key, required this.match});

  final CompletedMatchDetailInfo match;

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            match.tournamentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.white38, size: 13),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  '${match.location}  •  ${match.dateShort}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                                ),
                              ),
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    _HeaderCard(match: match),
                    const SizedBox(height: 12),
                    _ScoreCard(match: match),
                    const SizedBox(height: 12),
                    _WinnerStrip(winnerName: match.winnerName),
                    const SizedBox(height: 22),
                    Text(
                      'Match Summary',
                      style: GoogleFonts.quicksand(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SummaryTable(match: match),
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.match});

  final CompletedMatchDetailInfo match;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141820),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A3A32)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                match.timeLabel,
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF5AC8FA),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: Text(
                  match.roundLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    color: AppColors.mintGreen,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF5AC8FA).withValues(alpha: 0.7)),
                ),
                child: Text(
                  'Completed',
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFF5AC8FA),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A241C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  match.initials,
                  style: GoogleFonts.quicksand(
                    color: AppColors.mintGreen,
                    fontSize: 14,
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
                      match.tournamentName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            match.sport,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: AppColors.amberAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '  •  ',
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
                        ),
                        const Icon(Icons.location_on_rounded, color: Color(0xFF5AC8FA), size: 12),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            match.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: const Color(0xFF5AC8FA),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({required this.match});

  final CompletedMatchDetailInfo match;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141820),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A3A32)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batting',
                  style: GoogleFonts.quicksand(
                    color: AppColors.mintGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  match.battingTeam,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  match.battingScore,
                  style: GoogleFonts.quicksand(
                    color: Colors.white70,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Vs',
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Bowling',
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFF5AC8FA),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  match.bowlingTeam,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  match.bowlingScore,
                  style: GoogleFonts.quicksand(
                    color: Colors.white70,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WinnerStrip extends StatelessWidget {
  const _WinnerStrip({required this.winnerName});

  final String winnerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2414), Color(0xFF1A1210), Color(0xFF2A1A10)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: const Color(0x33E3A93D)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE3A93D), width: 1.4),
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFE3A93D), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Winner',
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFFE3A93D),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  winnerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTable extends StatelessWidget {
  const _SummaryTable({required this.match});

  final CompletedMatchDetailInfo match;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Player of the Match', match.playerOfTheMatch),
      ('Venue', match.venue),
      ('Date', match.dateFull),
      ('Referee', match.referee),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF141820),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A3A32)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Name',
                    style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  'R (B)',
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 14),
                Text(
                  '4s',
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 14),
                Text(
                  '6s',
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 14),
                Text(
                  'SR',
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0x14FFFFFF)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      rows[i].$1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      rows[i].$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
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
