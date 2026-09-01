import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/next_match_info.dart';

/// Dark navy gradient card spotlighting the user's next scheduled match,
/// with a stage tag, matchup, and a prize/registration info grid.
class NextMatchCard extends StatelessWidget {
  const NextMatchCard({super.key, required this.match, this.onTap});

  final NextMatchInfo match;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: AppColors.nextMatchGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(150, 255, 255, 255),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(208, 58, 223, 160),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    match.stage,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  match.dateLabel,
                  style: GoogleFonts.quicksand(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 05),
            Text(
              match.title,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white54,
                  size: 13,
                ),
                const SizedBox(width: 3),
                Text(
                  match.location,
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 05),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.teamA,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'vs',
                  style: GoogleFonts.quicksand(
                    color: Colors.white38,
                    fontSize: 15,
                  ),
                ),
                Expanded(
                  child: Text(
                    match.teamB,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 08),
            Container(height: 1, color: AppColors.glassBorder),
            const SizedBox(height: 08),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: '${match.prize}  ',
                      style: GoogleFonts.quicksand(
                        color: AppColors.amberAccent,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Max Players: ${match.maxPlayers}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.quicksand(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Reg Fee: ${match.regFee}',
                    style: GoogleFonts.quicksand(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Reg Ends: ${match.regEndsLabel}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.quicksand(
                      color: Colors.white60,
                      fontSize: 12,
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
