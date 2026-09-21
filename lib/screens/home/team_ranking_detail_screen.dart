import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/ranking_info.dart';
import '../team/team_detail_screen.dart';
import 'widgets/ranking_detail_bits.dart';

class TeamRankingDetailScreen extends StatelessWidget {
  const TeamRankingDetailScreen({super.key, required this.detail});

  final TeamRankingDetail detail;

  @override
  Widget build(BuildContext context) {
    final entry = detail.entry;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Team Ranking',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1E28),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFE3A93D).withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                rankingInitials(entry.name),
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFFE3A93D),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -6,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE3A93D),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '#${entry.rank}',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'pts ',
                                    style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                                  ),
                                  Text(
                                    '${entry.points}',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  RankingDeltaText(delta: entry.delta),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${entry.sport}  •  ${detail.city}  •  ${entry.matches} Matches',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    RankingDarkCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: detail.captainName,
                                        style: GoogleFonts.quicksand(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  •  Captain',
                                        style: GoogleFonts.quicksand(
                                          color: const Color(0xFFE3A93D),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${entry.matches} Matches',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                                      ),
                                    ),
                                    Text('  •  ', style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
                                    const Icon(Icons.emoji_events_rounded, color: Color(0xFFE3A93D), size: 13),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${entry.awards} Awards',
                                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          RankingDeltaText(delta: entry.delta),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    RankingDarkCard(
                      child: Column(
                        children: [
                          RankingStatRow(
                            label: 'Recent Form',
                            value: detail.recentForm.join('  •  '),
                            labelColor: const Color(0xFFE3A93D),
                          ),
                          RankingStatRow(label: 'Played', value: '${entry.matches}'),
                          RankingStatRow(label: 'Won', value: '${detail.won}'),
                          RankingStatRow(label: 'Lost', value: '${detail.lost}'),
                          RankingStatRow(label: 'Net Run Rate', value: detail.netRunRate),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Achievements',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    RankingDarkCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < detail.achievements.length; i++) ...[
                            if (i > 0) const SizedBox(height: 8),
                            Text(
                              detail.achievements[i],
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RankingProfileButton(
                      label: 'View Full Team Profile  >',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TeamDetailScreen(
                              team: {
                                'name': entry.name,
                                'sport': {'name': entry.sport},
                                'total_players': 11,
                                'members': {'current_count': 11},
                                'captain': {'name': detail.captainName},
                                'city': detail.city,
                              },
                            ),
                          ),
                        );
                      },
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
