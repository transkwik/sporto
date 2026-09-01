import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/live_match_detail_info.dart';
import 'widgets/foil_badge_minted_sheet.dart';
import 'widgets/match_status_pills.dart';
import 'widgets/stadium_zone_card.dart';
import 'widgets/team_matchup_row.dart';
import 'predictor_leaderboard_screen.dart';

/// Stadium zone check-in screen: pick a seating zone at the venue to claim
/// this match's badge. Reuses the match header chrome from the live
/// scorecard so the viewer stays oriented.
class StadiumCheckInScreen extends StatelessWidget {
  const StadiumCheckInScreen({super.key, required this.match});

  final LiveMatchDetailInfo match;

  static const List<(String name, String occupancy, int serial)> _zones = [
    ('Front Row', '84 here', 185),
    ('Shade Block', '61 here', 212),
    ('Family Corner', '37 here', 98),
    ('Ultras Corner', '122 here', 341),
  ];

  void _openLeaderboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PredictorLeaderboardScreen(match: match)),
    );
  }

  void _openBadgeSheet(BuildContext context, String zoneName, int serial) {
    FoilBadgeMintedSheet.show(
      context,
      roundLabel: match.roundLabel,
      teamAName: match.teamAName,
      teamBName: match.teamBName,
      zoneName: zoneName,
      serialNumber: serial,
      onNice: () => _openLeaderboard(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            match.tournamentName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.white38, size: 12),
                              const SizedBox(width: 3),
                              Text(match.location, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                  children: [
                    const Text(
                      'Stadium & Check In',
                      style: TextStyle(color: AppColors.amberAccent, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Pick a zone and check in to claim this match's badge.",
                      style: TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      decoration: BoxDecoration(
                        color: AppColors.glassFillLighter,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MatchStatusPills(roundLabel: match.roundLabel),
                          const SizedBox(height: 16),
                          TeamMatchupRow(
                            teamAName: match.teamAName,
                            teamARole: match.teamARole,
                            teamBName: match.teamBName,
                            teamBRole: match.teamBRole,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    for (final zone in _zones) ...[
                      StadiumZoneCard(
                        zoneName: zone.$1,
                        occupancyLabel: zone.$2,
                        onCheckIn: () => _openBadgeSheet(context, zone.$1, zone.$3),
                      ),
                      const SizedBox(height: 14),
                    ],
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
