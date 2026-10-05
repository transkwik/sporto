import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/celebrate_info.dart';

class CelebrateTournamentBanner extends StatelessWidget {
  const CelebrateTournamentBanner({super.key, required this.campaign});

  final CelebrateCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A1848), Color(0xFF161A22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFE85AD4).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tournament',
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            campaign.tournamentTitle,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            campaign.sport,
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

class CelebrateTipSummaryCard extends StatelessWidget {
  const CelebrateTipSummaryCard({super.key, required this.draft});

  final CelebrateTipDraft draft;

  @override
  Widget build(BuildContext context) {
    final c = draft.campaign;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          _row('Recipient', draft.recipientName),
          const SizedBox(height: 12),
          _row('Team', c.teamName),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded, color: Color(0xFFE3A93D), size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  c.placeLabel,
                  style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
                ),
              ),
              Text(
                c.placePrize,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF2A2E38), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Tip Amount',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '₹${draft.amount}',
                style: GoogleFonts.quicksand(
                  color: const Color(0xFFE3A93D),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
