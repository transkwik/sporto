import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/my_team_info.dart';
import 'team_tournament_matches_screen.dart';

/// Profile → My Teams → team card: recap of titles, prize money, and past cups.
class TeamHistoryScreen extends StatelessWidget {
  const TeamHistoryScreen({super.key, required this.team});

  final MyTeamInfo team;

  void _openTournament(BuildContext context, TeamHistoryTournament item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeamTournamentMatchesScreen(tournament: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prize = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0)
        .format(team.prizeEarned);

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
                    Text(
                      'Team History',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    _TeamHeroCard(team: team),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _StatTile(value: '${team.titles}', label: 'Titles')),
                        const SizedBox(width: 8),
                        Expanded(child: _StatTile(value: '${team.wins}', label: 'Wins')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatTile(value: '${team.tournamentsPlayed}', label: 'Tournaments'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: _StatTile(value: '${team.matchesCount}', label: 'Matches')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _PrizeBar(amount: prize),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text(
                          'Tournament History',
                          style: GoogleFonts.quicksand(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: team.history.isEmpty
                              ? null
                              : () => _openTournament(context, team.history.first),
                          child: Text(
                            'View all  >',
                            style: GoogleFonts.quicksand(
                              color: Colors.white38,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (team.history.isEmpty)
                      Text(
                        'No tournaments yet.',
                        style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13.5),
                      )
                    else
                      for (final item in team.history) ...[
                        _HistoryCard(
                          item: item,
                          onTap: () => _openTournament(context, item),
                        ),
                        const SizedBox(height: 12),
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

class _TeamHeroCard extends StatelessWidget {
  const _TeamHeroCard({required this.team});

  final MyTeamInfo team;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5A2B), Color(0xFF2A1810)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: const Color(0xFFE3A93D), width: 1.4),
            ),
            alignment: Alignment.center,
            child: Text(
              team.avatarInitials,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 14,
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
                  team.name,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (team.city.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.white38, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        team.city,
                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  '${team.playersCount}/${team.maxPlayers} Players  •  Captain: ${team.captainName}',
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2420), Color(0xFF1A1E28)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _PrizeBar extends StatelessWidget {
  const _PrizeBar({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF143322), Color(0xFF1F6A3A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total Prize Money Earned',
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.quicksand(
              color: AppColors.mintGreen,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, this.onTap});

  final TeamHistoryTournament item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF141820),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Icon(Icons.sports_cricket_rounded, color: Colors.white70, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white38, size: 13),
                        const SizedBox(width: 2),
                        Text(
                          item.location,
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                item.dateRange,
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFF3A2418), Color(0xFF1A1E28)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Color(0xFFE3A93D), size: 18),
                const SizedBox(width: 8),
                Text(
                  item.resultLabel,
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFFFF8A1E),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  item.championTeam,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
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
