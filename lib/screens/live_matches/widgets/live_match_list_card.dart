import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/match_info.dart';
import 'dashed_divider.dart';

/// Single live match row on the "Live Matches" tab: sport + tournament
/// title, a team-vs-team score line, and a status + "Check Live Score"
/// call to action — tinted with a gradient specific to the sport.
class LiveMatchListCard extends StatelessWidget {
  const LiveMatchListCard({super.key, required this.match, required this.onTap});

  final MatchInfo match;
  final VoidCallback onTap;

  Gradient get _gradient {
    switch (match.sport) {
      case 'Football':
        return AppColors.liveFootballCardGradient;
      case 'Badminton':
        return AppColors.liveBadmintonCardGradient;
      default:
        return AppColors.liveCardGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(gradient: _gradient, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(match.sport, style: const TextStyle(color: Colors.white60, fontSize: 12.5)),
            const SizedBox(height: 2),
            Text(
              match.title,
              style: GoogleFonts.quicksand(color: AppColors.amberAccent, fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.teamA,
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                const Text('Vs', style: TextStyle(color: Colors.white54, fontSize: 12.5)),
                Expanded(
                  child: Text(
                    match.teamB,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.scoreA,
                    style: GoogleFonts.quicksand(color: AppColors.mintGreen, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: Text(
                    match.scoreB,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const DashedDivider(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.status,
                    style: const TextStyle(color: Colors.white60, fontSize: 12.5),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 08),
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 252, 131, 25), borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    'Check Live Score',
                    style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
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
