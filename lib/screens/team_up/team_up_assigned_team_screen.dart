import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/my_tournament_info.dart';
import '../../models/team_up_info.dart';
import '../profile/tournaments/my_tournament_details_screen.dart';

/// Generate Teams → assigned squad reveal.
class TeamUpAssignedTeamScreen extends StatelessWidget {
  const TeamUpAssignedTeamScreen({
    super.key,
    required this.tournament,
    this.team = dummyTeamUpAssignedTeam,
  });

  final TeamUpTournament tournament;
  final TeamUpAssignedTeam team;

  void _viewMyTeam(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MyTournamentDetailsScreen(
          tournament: MyTournamentInfo(
            id: tournament.id,
            sport: tournament.sport,
            status: MyTournamentStatus.upcoming,
            roundLabel: 'Open',
            title: tournament.title.replaceAll('\n', ' '),
            location: tournament.venue,
            teamA: team.name,
            teamB: 'TBD',
            statusLine: tournament.dateLabel,
            ctaLabel: 'View Details',
            dateRange: tournament.dateLabel,
            prizeEarned: tournament.prizePool,
            prizeCaption: 'Prize pool',
            squad: [
              for (final p in team.players)
                MyTournamentPlayerStat(
                  name: p.isYou ? 'You' : p.name,
                  role: p.role,
                  runs: p.rating,
                  wickets: 0,
                  isYou: p.isYou,
                ),
            ],
          ),
        ),
      ),
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GlassBackButton(onTap: () => Navigator.of(context).pop()),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'YOUR TEAM IS...',
                            style: GoogleFonts.quicksand(
                              color: Colors.white38,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            team.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: 'Squad Rating: ',
                              style: GoogleFonts.quicksand(
                                color: Colors.white54,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: '${team.squadRating}',
                                  style: GoogleFonts.quicksand(
                                    color: AppColors.mintGreen,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    for (final player in team.players) ...[
                      _PlayerRow(player: player),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GestureDetector(
                  onTap: () => _viewMyTeam(context),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: const Color(0xFF5EC8F8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5EC8F8).withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'View My Team',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({required this.player});

  final TeamUpAssignedPlayer player;

  @override
  Widget build(BuildContext context) {
    final you = player.isYou;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: you ? AppColors.mintGreen.withValues(alpha: 0.45) : AppColors.glassBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF12151C),
              border: Border.all(
                color: you ? AppColors.mintGreen : AppColors.glassBorderStrong,
                width: you ? 1.6 : 1,
              ),
            ),
            child: Text(
              player.initials,
              style: GoogleFonts.quicksand(
                color: you ? AppColors.mintGreen : Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  player.role,
                  style: GoogleFonts.quicksand(
                    color: Colors.white38,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${player.rating}',
            style: GoogleFonts.quicksand(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
