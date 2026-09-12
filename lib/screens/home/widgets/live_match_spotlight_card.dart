import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/match_info.dart';

/// Warm gradient "hero" card for the currently live match, with a live
/// scoreboard layout and a "Watch Live Now" call to action.
class LiveMatchSpotlightCard extends StatelessWidget {
  const LiveMatchSpotlightCard({
    super.key,
    required this.match,
    this.onWatch,
    this.onTap,
  });

  final MatchInfo match;
  final VoidCallback? onWatch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: AppColors.liveCardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  match.sport,
                  style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              match.title,
              style: GoogleFonts.quicksand(
                color: Colors. amber,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.teamA,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    match.teamB,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.scoreA,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                 Text(
                  'vs',
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Text(
                    match.scoreB,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.status,
                    style: GoogleFonts.quicksand(
                      color: Colors.white70,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
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
