import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

import 'package:intl/intl.dart';

/// Glass row card for a single entry in the "Browse Tournaments" list.
class TournamentCard extends StatelessWidget {
  const TournamentCard({super.key, required this.tournament, this.onTap});

  final Map<String, dynamic> tournament;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = tournament['title'] ?? tournament['name'] ?? 'Unnamed Tournament';
    final sportName = tournament['sport']?['name'] ?? 'Sport';
    final location = tournament['location'] ?? 'Unknown Location';
    final startString = tournament['tournament_start_at'] ?? tournament['start_date'];
    final regEndString = tournament['registration_end_at'] ?? tournament['end_date'];
    
    String dateLabel = 'TBA';
    try {
      if (startString != null) {
        final parsed = DateTime.parse(startString);
        dateLabel = 'Starts ${DateFormat('MMM dd, yyyy').format(parsed)}';
      }
    } catch (_) {}

    String footerLabel = 'Last Date: TBA';
    try {
      if (regEndString != null) {
        final parsed = DateTime.parse(regEndString);
        footerLabel = 'Reg Ends: ${DateFormat('MMM dd, yyyy').format(parsed)}';
      }
    } catch (_) {}

    final prizeAmount = tournament['prize_amount'] ?? 0;
    final prize = prizeAmount > 0 ? '₹$prizeAmount Prize Pool' : 'No Prize Pool';
    
    final maxTeams = tournament['maximum_teams'] ?? 0;
    final regTeams = tournament['registered_teams'] ?? 0;
    final statLabel = '$regTeams / $maxTeams Teams Registered';
    
    String initials = '?';
    if (title.isNotEmpty) {
      initials = title.substring(0, 1).toUpperCase();
    }

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
              '$sportName • $dateLabel',
              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (initials != '?') ...[
                  Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(114, 255, 76, 48),
                      // shape: BoxShape.circle,
                    ),
                    child: Text(
                      initials,
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    title,
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
                Text(location, style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12)),
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
                        prize,
                        style: GoogleFonts.quicksand(color: AppColors.amberAccent, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 3),
                      Text(statLabel, style: GoogleFonts.quicksand(color: Colors.white60, fontSize: 11.5)),
                    ],
                  ),
                ),
                Text(
                  footerLabel,
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
