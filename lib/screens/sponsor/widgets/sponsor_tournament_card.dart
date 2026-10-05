import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/sponsor_info.dart';

class SponsorTournamentCard extends StatelessWidget {
  const SponsorTournamentCard({super.key, required this.tournament, this.onSponsor});

  final SponsorTournament tournament;
  final VoidCallback? onSponsor;

  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);

  String _inr(int value) => NumberFormat.decimalPattern('en_IN').format(value);

  @override
  Widget build(BuildContext context) {
    final t = tournament;
    return GestureDetector(
      onTap: onSponsor,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161222),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _pink.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: t.sport,
                  style: GoogleFonts.quicksand(
                    color: AppColors.mintGreen,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '  •  ${t.city}',
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: Colors.white38, size: 13),
              const SizedBox(width: 5),
              Text(
                t.dateLabel,
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.groups_outlined, color: Colors.white38, size: 15),
              const SizedBox(width: 4),
              Text(
                '${t.teams} Teams',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded, color: _gold, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${t.prizePool} Prize Pool',
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${t.sponsors} Sponsors',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: t.fundedRatio,
              minHeight: 7,
              backgroundColor: const Color(0xFF2A303C),
              color: _gold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${t.fundedPercent}% Funded',
                style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12.5),
              ),
              const Spacer(),
              Text(
                '₹${_inr(t.raised)} / ${t.prizePool}',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, color: _pink, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '₹${_inr(t.remaining)} remaining',
                  style: GoogleFonts.quicksand(
                    color: _pink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onSponsor,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _pink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        'Sponsor Now',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
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
