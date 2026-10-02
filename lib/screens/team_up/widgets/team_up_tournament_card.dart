import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/team_up_info.dart';

class TeamUpTournamentCard extends StatelessWidget {
  const TeamUpTournamentCard({super.key, required this.tournament, this.onTap});

  final TeamUpTournament tournament;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = tournament;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(t.sportIcon, color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t.listTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  t.dateLabel,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white38, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    t.venue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '₹${t.entryFee} ',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'Entry',
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${t.teamSize} players ',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'Team Size',
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Format  ${t.formatLine}   Reg. Closes: ${t.regClosesLabel}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.onboardingHeroCard,
                border: Border.all(color: AppColors. onboardingHeroCard ),
                // color: AppColors.mintGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: t.fillRatio,
                            minHeight: 7,
                            backgroundColor: const Color(0xFF2A303C),
                            color: const Color(0xFFE3A93D),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${t.registered}/${t.capacity} Registered   ${t.fillPercent}% full',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.amberAccent.withValues(alpha: 0.75)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Prize Pool',
                          style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 10),
                        ),
                        Text(
                          t.prizePool,
                          style: GoogleFonts.quicksand(
                            color: AppColors.amberAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
