import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

/// Green gradient summary card recapping the tournament being paid for.
class PaymentMatchCard extends StatelessWidget {
  const PaymentMatchCard({
    super.key,
    required this.tournament,
    required this.team,
  });

  final Map<String, dynamic> tournament;
  final Map<String, dynamic> team;

  @override
  Widget build(BuildContext context) {
    final title = tournament['name'] ?? 'Tournament';
    final stage = tournament['tournament_type']?['name']?.toString() ??
        tournament['sport_format']?['name']?.toString() ??
        'Tournament';
    final teamA = tournament['featured_team_a']?.toString() ??
        tournament['team_a']?['name']?.toString() ??
        'TBD';
    final teamB = tournament['featured_team_b']?.toString() ??
        tournament['team_b']?['name']?.toString() ??
        'TBD';
    String dateLabel = '';
    try {
      final raw = tournament['tournament_start_at'] ?? tournament['tournament_start_date'];
      if (raw != null) {
        dateLabel = DateFormat('d MMM, hh:mm a').format(DateTime.parse(raw.toString()));
      }
    } catch (_) {}

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.paymentSummaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  stage,
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                dateLabel,
                style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  teamA,
                  style: GoogleFonts.quicksand(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'Vs',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
              ),
              Expanded(
                child: Text(
                  teamB,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.quicksand(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
