import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_info.dart';
import 'add_players_screen.dart';
import 'widgets/team_roster_card.dart';

/// Shown when a selected team's roster isn't full yet: recaps the team and
/// prompts the user to add the remaining players before continuing.
class TeamRosterScreen extends StatelessWidget {
  const TeamRosterScreen({super.key, required this.team, required this.tournament});

  final Map<String, dynamic> team;
  final Map<String, dynamic> tournament;

  void _openCreateTeam(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddPlayersScreen(
        team: team,
        tournament: tournament,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playersCountStr = team['total_players']?.toString() ?? team['player_count']?.toString() ?? '0';
    final maxPlayersStr = team['sport']?['max_players']?.toString() ?? tournament['sport']?['max_players']?.toString() ?? '11';
    final int playersCount = int.tryParse(playersCountStr) ?? 0;
    final int maxPlayers = int.tryParse(maxPlayersStr) ?? 11;
    final bool isFull = playersCount >= maxPlayers;

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
                    const Text(
                      'Select Your Team',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  children: [
                    const Text(
                      'Select Team',
                      style: TextStyle(color: AppColors.amberAccent, fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 14),
                    TeamRosterCard(team: team, onMenuTap: () {}, onCompleteTap: isFull ? null : () => _openCreateTeam(context)),
                    if (!isFull) ...[
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => _openCreateTeam(context),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: AppColors.bannerGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF7A1E).withValues(alpha: 0.45),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add Team Players',
                                style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
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
