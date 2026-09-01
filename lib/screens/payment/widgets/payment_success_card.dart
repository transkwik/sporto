import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Glass card with a green success ring shown after a payment completes:
/// a glowing checkmark badge, a bold "REGISTERED!" title, and a short
/// confirmation message naming the team and tournament.
class PaymentSuccessCard extends StatelessWidget {
  const PaymentSuccessCard({super.key, required this.team, required this.tournament});

  final Map<String, dynamic> team;
  final Map<String, dynamic> tournament;

  @override
  Widget build(BuildContext context) {
    final teamName = team['team_name'] ?? 'Your Team';
    final tournamentName = tournament['name'] ?? 'Tournament';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2430),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(color: AppColors.mintGreen.withValues(alpha: 0.18), blurRadius: 30, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 92,
            height: 92,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CD97B), Color(0xFF1FA85A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: AppColors.mintGreen.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 1),
                ],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(height: 22),
            Text(
            'REGISTERED!',
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
          const SizedBox(height: 10),
          Text(
            '$teamName is confirmed for\n$tournamentName',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(color: Colors.white60, fontSize: 13.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}
