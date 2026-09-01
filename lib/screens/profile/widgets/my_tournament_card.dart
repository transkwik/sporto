import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/my_tournament_info.dart';

/// Tournament row on My Tournaments. Live cards use the warm match gradient.
class MyTournamentCard extends StatelessWidget {
  const MyTournamentCard({super.key, required this.tournament, this.onTap, this.onCta});

  final MyTournamentInfo tournament;
  final VoidCallback? onTap;
  final VoidCallback? onCta;

  bool get _isLive => tournament.status == MyTournamentStatus.live;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: _isLive ? AppColors.liveCardGradient : null,
        color: _isLive ? null : const Color(0xFF1A1E28),
        border: Border.all(
          color: _isLive ? const Color(0x66E07A3A) : AppColors.glassBorder,
        ),
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
              if (_isLive) ...[
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
              ] else
                Text(
                  tournament.status == MyTournamentStatus.upcoming ? 'Upcoming' : 'Completed',
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tournament.title,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white54, size: 14),
              const SizedBox(width: 3),
              Text(
                tournament.location,
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
          const SizedBox(height: 12),
          Text(
            '${tournament.teamA}   vs   ${tournament.teamB}',
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  tournament.statusLine,
                  style: GoogleFonts.quicksand(color: Colors.white60, fontSize: 12),
                ),
              ),
              if (tournament.ctaLabel != null)
                GestureDetector(
                  onTap: onCta,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: _isLive ? AppColors.bannerGradient : null,
                      color: _isLive ? null : AppColors.glassFillLight,
                      borderRadius: BorderRadius.circular(12),
                      border: _isLive ? null : Border.all(color: AppColors.glassBorderStrong),
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
          ),
        ],
      ),
      ),
    );
  }
}
