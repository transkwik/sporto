import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/tournament_info.dart';

/// Glass row card for a single entry in the "Browse Tournaments" list.
class TournamentCard extends StatelessWidget {
  const TournamentCard({super.key, required this.tournament, this.onTap});

  final TournamentInfo tournament;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${tournament.sport} • ${tournament.dateLabel}',
              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (tournament.avatarLetter != null) ...[
                  Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: tournament.avatarColor ?? const Color.fromARGB(114, 255, 76, 48),
                      // shape: BoxShape.circle,
                    ),
                    child: Text(
                      tournament.avatarLetter!,
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    tournament.title,
                    style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.amber, size: 20),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white54, size: 13),
                const SizedBox(width: 3),
                Text(tournament.location, style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12)),
                if (tournament.distanceKm != null) ...[
                  const SizedBox(width: 10),
                  const Icon(Icons.social_distance_rounded, color: Colors.white54, size: 13),
                  const SizedBox(width: 3),
                  Text(tournament.distanceKm!, style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12)),
                ],
              ],
            ),
            const SizedBox(height: 05),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tournament.prize,
                        style: GoogleFonts.quicksand(color: AppColors.amberAccent, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(tournament.statLabel, style: GoogleFonts.quicksand(color: Colors.white60, fontSize: 11.5)),
                    ],
                  ),
                ),
                Text(
                  tournament.footerLabel,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
