import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/sponsor_info.dart';

class SponsorTournamentBanner extends StatelessWidget {
  const SponsorTournamentBanner({super.key, required this.tournament});

  final SponsorTournament tournament;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A1848), Color(0xFF1A1028)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFE85AD4).withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tournament',
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
          ),
          const SizedBox(height: 4),
          Text(
            tournament.title,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tournament.sport,
            style: GoogleFonts.quicksand(
              color: AppColors.mintGreen,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
