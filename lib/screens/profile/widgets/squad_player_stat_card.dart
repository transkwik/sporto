import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/my_tournament_info.dart';

/// One player row on Tournament Details → Squad Performance.
class SquadPlayerStatCard extends StatelessWidget {
  const SquadPlayerStatCard({super.key, required this.player});

  final MyTournamentPlayerStat player;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: player.isYou ? const Color(0xFF1B3328) : const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: player.isYou ? AppColors.mintGreen.withValues(alpha: 0.35) : AppColors.glassBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  player.role,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${player.runs}  Runs',
                style: GoogleFonts.quicksand(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 3),
              Text(
                '${player.wickets}  Wickets',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
