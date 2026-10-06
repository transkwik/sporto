import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/prize_details_info.dart';

/// Home dashboard win card above Needs Your Attention.
class PrizeDetailsBanner extends StatelessWidget {
  const PrizeDetailsBanner({super.key, this.onTap, this.details = dummyPrizeDetails});

  final VoidCallback? onTap;
  final PrizeDetailsInfo details;

  static const _gold = Color(0xFFE3A93D);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3AD7E8).withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3AD7E8).withValues(alpha: 0.18),
              blurRadius: 16,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.prizeBackground,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.55, 0),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF071018),
                        const Color(0xF2081420),
                        const Color(0x990A1828),
                        Colors.black.withValues(alpha: 0.15),
                      ],
                      stops: const [0, 0.38, 0.58, 1],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events_rounded, color: _gold, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            'Tournament Completed!',
                            style: GoogleFonts.quicksand(
                              color: _gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(right: 72),
                      child: Text(
                        details.tournamentTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 72),
                      child: Text.rich(
                        TextSpan(
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                          children: [
                            const TextSpan(text: 'Your team '),
                            TextSpan(
                              text: details.winningTeamName,
                              style: GoogleFonts.quicksand(
                                color: _gold,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                            ),
                            const TextSpan(text: ' has won the tournament!'),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Your prize is being processed.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white70,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.infoBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Prize Details  >',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
