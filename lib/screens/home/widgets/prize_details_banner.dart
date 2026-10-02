import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/prize_details_info.dart';

/// Home dashboard win card above Needs Your Attention.
class PrizeDetailsBanner extends StatelessWidget {
  const PrizeDetailsBanner({super.key, this.onTap, this.details = dummyPrizeDetails});

  final VoidCallback? onTap;
  final PrizeDetailsInfo details;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1C1608), Color(0xFF2A220C), Color(0xFF1A1408)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF5A4A18).withValues(alpha: 0.7)),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -8,
                top: 8,
                bottom: 8,
                child: Icon(
                  Icons.emoji_events_rounded,
                  size: 120,
                  color: const Color(0xFFE3A93D).withValues(alpha: 0.18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded, color: Color(0xFFE3A93D), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'TOURNAMENT COMPLETED!',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.abrilFatface(
                              color: const Color(0xFFE3A93D),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              // letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      details.tournamentTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.abrilFatface(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'Your team '),
                          TextSpan(
                            text: details.winningTeamName,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const TextSpan(text: ' has won the tournament!'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your prize is being processed.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14.5),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.infoBlue),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.circle, size: 8, color: AppColors.infoBlue),
                              const SizedBox(width: 6),
                              Text(
                                'Processing',
                                style: GoogleFonts.quicksand(
                                  color: AppColors.infoBlue,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          child: Text(
                            'View Prize Details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: GoogleFonts.quicksand(
                              color: const Color(0xFFE3A93D),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Color(0xFFE3A93D), size: 20),
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
