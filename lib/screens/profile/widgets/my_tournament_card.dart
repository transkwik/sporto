import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/my_tournament_info.dart';

/// Tournament row on My Tournaments. Live / upcoming / completed each have
/// their own card layout. Data still comes from [MyTournamentInfo].
class MyTournamentCard extends StatelessWidget {
  const MyTournamentCard({super.key, required this.tournament, this.onTap, this.onCta});

  final MyTournamentInfo tournament;
  final VoidCallback? onTap;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    switch (tournament.status) {
      case MyTournamentStatus.upcoming:
        return _UpcomingCard(tournament: tournament, onTap: onTap);
      case MyTournamentStatus.completed:
        return _CompletedCard(tournament: tournament, onTap: onTap);
      case MyTournamentStatus.live:
        return _LiveCard(tournament: tournament, onTap: onTap, onCta: onCta);
    }
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.tournament, this.onTap});

  final MyTournamentInfo tournament;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2230),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.85)),
                  ),
                  child: Text(
                    tournament.roundLabel,
                    style: GoogleFonts.quicksand(
                      color: AppColors.mintGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tournament.statusLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tournament.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white38, size: 14),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    tournament.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    tournament.teamA,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Vs',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    tournament.teamB,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedCard extends StatelessWidget {
  const _CompletedCard({required this.tournament, this.onTap});

  final MyTournamentInfo tournament;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final champion = tournament.championTeam.isNotEmpty ? tournament.championTeam : tournament.teamA;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2230),
          borderRadius: BorderRadius.circular(18),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  tournament.dateRange,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white38, size: 14),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    tournament.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
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
                          'Champions',
                          style: GoogleFonts.quicksand(
                            color: const Color(0xFFE3A93D),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          champion,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveCard extends StatelessWidget {
  const _LiveCard({required this.tournament, this.onTap, this.onCta});

  final MyTournamentInfo tournament;
  final VoidCallback? onTap;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: AppColors.liveCardGradient,
          border: Border.all(color: const Color(0x66E07A3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tournament.roundLabel,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  'Live Now',
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFFE53935),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tournament.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white54, size: 14),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    tournament.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
            const SizedBox(height: 12),
            Text(
              '${tournament.teamA}   vs   ${tournament.teamB}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    tournament.statusLine,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white60, fontSize: 12),
                  ),
                ),
                if (tournament.ctaLabel != null) ...[
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onCta,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: AppColors.bannerGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tournament.ctaLabel!,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
