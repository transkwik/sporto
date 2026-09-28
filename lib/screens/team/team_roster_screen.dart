import 'package:flutter/material.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_info.dart';
import 'add_players_screen.dart';
import 'widgets/team_roster_card.dart';

/// Shown when a selected team's roster isn't full yet: recaps the team and
/// prompts the user to add the remaining players before continuing.
class TeamRosterScreen extends StatefulWidget {
  const TeamRosterScreen({
    super.key,
    required this.team,
    required this.tournament,
  });

  final Map<String, dynamic> team;
  final Map<String, dynamic> tournament;

  @override
  State<TeamRosterScreen> createState() => _TeamRosterScreenState();
}

class _TeamRosterScreenState extends State<TeamRosterScreen> {
  late Map<String, dynamic> _team;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _team = Map<String, dynamic>.from(widget.team);
    _fetchTeamDetails();
  }

  Future<void> _fetchTeamDetails() async {
    final teamId = _team['id'] as int?;
    if (teamId == null) return;

    if (mounted) setState(() => _isFetching = true);
    try {
      final response = await UserApis().getTeamDetails(teamId);
      if (response != null && response['success'] == true) {
        if (mounted) {
          setState(() {
            final data = response['data'] as Map<String, dynamic>?;
            if (data != null && data['team'] != null) {
              final newTeamData = Map<String, dynamic>.from(data['team']);

              if (newTeamData['players'] is List) {
                final playersList = List<dynamic>.from(newTeamData['players']);
                final activePlayers = playersList
                    .where(
                      (p) =>
                          p is Map &&
                          p['status'] == 1 &&
                          p['removed_at'] == null &&
                          !(p['joined_at'] == null && p['accepted_at'] == null && p['rejected_at'] == null),
                    )
                    .toList();
                newTeamData['total_players'] = activePlayers.length;
                newTeamData['player_count'] = activePlayers.length;
              }

              _team = newTeamData;
            }
          });
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  void _openCreateTeam(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            AddPlayersScreen(team: _team, tournament: widget.tournament),
      ),
    );
    // Refresh when coming back
    _fetchTeamDetails();
  }

  @override
  Widget build(BuildContext context) {
    final playersCountStr =
        _team['total_players']?.toString() ??
        _team['player_count']?.toString() ??
        '0';
    final int playersCount = int.tryParse(playersCountStr) ?? 0;

    final List<dynamic> gameRules = List<dynamic>.from(
      widget.tournament['game_rules'] ?? [],
    );
    final List<dynamic> sportRules = List<dynamic>.from(
      widget.tournament['sport_rules'] ?? [],
    );
    final List<dynamic> allRules = [...gameRules, ...sportRules];

    int requiredPlayers = 11;
    for (final dynamic rule in allRules) {
      if (rule is Map &&
          rule['key']?.toString().toLowerCase() == 'minimum_players_per_team') {
        final overrideVal = rule['override_value']?.toString();
        final defaultVal = rule['default_value']?.toString();

        if (overrideVal != null &&
            overrideVal.trim().isNotEmpty &&
            overrideVal != '0' &&
            overrideVal != '0.0') {
          requiredPlayers = double.tryParse(overrideVal)?.toInt() ?? 11;
          break;
        } else if (defaultVal != null &&
            defaultVal.trim().isNotEmpty &&
            defaultVal != '0' &&
            defaultVal != '0.0') {
          requiredPlayers = double.tryParse(defaultVal)?.toInt() ?? 11;
          break;
        }
      }
    }
    if (requiredPlayers == 0) requiredPlayers = 11;

    final bool isFull = playersCount >= requiredPlayers;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
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
                      style: TextStyle(
                        color: AppColors.amberAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TeamRosterCard(
                      team: _team,
                      requiredPlayers: requiredPlayers,
                      onMenuTap: () {},
                      onCompleteTap: isFull
                          ? null
                          : () => _openCreateTeam(context),
                    ),
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
                                color: const Color(
                                  0xFFFF7A1E,
                                ).withValues(alpha: 0.45),
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst),
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
                                color: const Color(
                                  0xFFFF7A1E,
                                ).withValues(alpha: 0.45),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Go to Dashboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _openCreateTeam(context),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.black54, Colors.black45],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Remove / Manage Players',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
