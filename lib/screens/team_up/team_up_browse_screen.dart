import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/my_tournament_info.dart';
import '../../models/team_up_info.dart';
import '../profile/my_tournament_details_screen.dart';
import 'widgets/team_up_featured_card.dart';

/// Team Up → View all tournament history for the selected sport.
class TeamUpBrowseScreen extends StatelessWidget {
  const TeamUpBrowseScreen({super.key, this.initialSport = 'Cricket'});

  final String initialSport;

  @override
  Widget build(BuildContext context) {
    final items = dummyTeamUpTournaments.where((t) => t.sport == initialSport).toList();

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
                        'Tournament History',
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
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No $initialSport Team Up events yet',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final t = items[index];
                          return TeamUpFeaturedCard(
                            tournament: t,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MyTournamentDetailsScreen(
                                    tournament: MyTournamentInfo(
                                      id: t.id,
                                      sport: t.sport,
                                      status: MyTournamentStatus.upcoming,
                                      roundLabel: 'Open',
                                      title: t.title.replaceAll('\n', ' '),
                                      location: t.venue,
                                      teamA: 'Your match',
                                      teamB: 'TBD',
                                      statusLine: t.dateLabel,
                                      dateRange: t.dateLabel,
                                      prizeEarned: t.prizePool,
                                      prizeCaption: 'Prize pool',
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
