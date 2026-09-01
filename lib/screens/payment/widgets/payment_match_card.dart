import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

/// Green gradient summary card recapping the tournament being paid for, 
/// showing the tournament details and the selected team.
class PaymentMatchCard extends StatelessWidget {
  const PaymentMatchCard({
    super.key,
    required this.tournament,
    required this.team,
  });

  final Map<String, dynamic> tournament;
  final Map<String, dynamic> team;

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown Date';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return 'Unknown Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = tournament['name'] ?? 'Tournament';
    final sportFormat = tournament['sport_format']?['name'] ?? '';
    final dateLabel = _formatDate(tournament['tournament_start_date']);
    final teamName = team['team_name'] ?? 'Your Team';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: AppColors.paymentSummaryGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(104, 255, 255, 255)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (sportFormat.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.mintGreen, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    sportFormat,
                    style: GoogleFonts.quicksand(color: Colors.black, fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                ),
              const Spacer(),
              Text(dateLabel, style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: GoogleFonts.quicksand(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Registering Team: ',
                style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Text(
                  teamName,
                  style: GoogleFonts.quicksand(color: AppColors.amberAccent, fontSize: 14, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
