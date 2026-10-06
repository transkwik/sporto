import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/globalefunction/global_functions.dart';
import '../home/providers/home_provider.dart';
import '../payment/tournament_registered_screen.dart';
import 'register_tournament.dart';
import 'widgets/team_card.dart';
import 'widgets/edit_team_dialog.dart';
import 'add_players_screen.dart';
import '../tournament/dummy_tournament_nav_data.dart';

int requiredPlayersForTournament(Map<String, dynamic> tournament) {
  final List<dynamic> allRules = [
    ...List<dynamic>.from(tournament['game_rules'] ?? []),
    ...List<dynamic>.from(tournament['sport_rules'] ?? []),
  ];
  int requiredPlayers = 5;
  for (final dynamic rule in allRules) {
    if (rule is Map &&
        rule['key']?.toString().toLowerCase() == 'minimum_players_per_team') {
      final overrideVal = rule['override_value']?.toString();
      final defaultVal = rule['default_value']?.toString();
      if (overrideVal != null &&
          overrideVal.trim().isNotEmpty &&
          overrideVal != '0' &&
          overrideVal != '0.0') {
        requiredPlayers = double.tryParse(overrideVal)?.toInt() ?? 5;
        break;
      } else if (defaultVal != null &&
          defaultVal.trim().isNotEmpty &&
          defaultVal != '0' &&
          defaultVal != '0.0') {
        requiredPlayers = double.tryParse(defaultVal)?.toInt() ?? 5;
        break;
      }
    }
  }
  if (requiredPlayers == 0) requiredPlayers = 5;
  return requiredPlayers;
}

/// Team picker shown after tapping "Create Team" on a tournament detail
/// screen: lets the user create a new team or select one of their
/// existing teams before confirming.
class SelectTeamScreen extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const SelectTeamScreen({super.key, required this.tournament});

  @override
  State<SelectTeamScreen> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  int _selectedIndex = 0;
  late Set<int> _selectedPlayerIndexes;

  @override
  void initState() {
    super.initState();
    _selectedPlayerIndexes = {
      for (var i = 0; i < dummyNavSquadPlayers.length; i++)
        if (dummyNavSquadPlayers[i]['selected'] == true) i,
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchTeams();
    });
  }

  void _openCreateTeam() {
    final required = requiredPlayersForTournament(widget.tournament);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterNewTeam(
          tournament: widget.tournament,
          maxPlayers: required,
        ),
      ),
    );
  }

  void _openAddPlayers(Map<String, dynamic> team) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddPlayersScreen(
          team: team,
          tournament: widget.tournament,
        ),
      ),
    );
  }

  void _handleDelete(Map<String, dynamic> team) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.authBackgroundBottom,
        title: Text(
          'Delete Team',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this team?',
          style: GoogleFonts.quicksand(color: Colors.white70),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.quicksand(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = Provider.of<HomeProvider>(
                context,
                listen: false,
              );
              final success = await provider.deleteTeam(team['id']);
              if (mounted) {
                if (success) {
                  MCP.showMessage(
                    context,
                    "Team deleted successfully.",
                    backgroundColor: Colors.green.shade600,
                    icon: Icons.check_circle_rounded,
                  );
                  if (_selectedIndex >= provider.teamsList.length) {
                    setState(() => _selectedIndex = 0);
                  }
                } else {
                  MCP.showMessage(
                    context,
                    provider.errorMessage ?? "Failed to delete team.",
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: GoogleFonts.quicksand(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleEdit(Map<String, dynamic> team) {
    showDialog(
      context: context,
      builder: (context) => EditTeamDialog(team: team),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requiredPlayers = requiredPlayersForTournament(widget.tournament);

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
                    Text(
                      'Select Your Team',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isFetchingTeams) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    final teams = provider.teamsList;
                    if (teams.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                        children: [
                          _CreateTeamButton(onTap: () => _openCreateTeam()),
                          const SizedBox(height: 40),
                          Text(
                            'No teams found.',
                            style: GoogleFonts.quicksand(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }

                    final safeIndex = _selectedIndex.clamp(0, teams.length - 1);
                    final selectedTeam = teams[safeIndex];
                    final selectedCount = int.tryParse(
                          selectedTeam['total_players']?.toString() ?? '0',
                        ) ??
                        0;
                    final isComplete = selectedCount >= requiredPlayers;

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                      children: [
                        if (isComplete) ...[
                          _CreateTeamButton(onTap: () => _openCreateTeam()),
                          const SizedBox(height: 24),
                          Text(
                            'Select Squad',
                            style: GoogleFonts.quicksand(
                              color: AppColors.amberAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                        ] else ...[
                          Text(
                            'Select Team',
                            style: GoogleFonts.quicksand(
                              color: AppColors.amberAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        ...teams.asMap().entries.map((entry) {
                          final i = entry.key;
                          final team = entry.value;
                          final count = int.tryParse(
                                team['total_players']?.toString() ?? '0',
                              ) ??
                              0;
                          final complete = count >= requiredPlayers;
                          return TeamCard(
                            team: team,
                            selected: safeIndex == i,
                            isComplete: complete,
                            requiredPlayers: requiredPlayers,
                            onAddPlayers: () => _openAddPlayers(team),
                            onSelect: () => setState(() => _selectedIndex = i),
                            onEdit: () => _handleEdit(team),
                            onDelete: () => _handleDelete(team),
                          );
                        }),
                        if (isComplete) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Players Available',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${_selectedPlayerIndexes.length}/$requiredPlayers',
                                style: GoogleFonts.quicksand(
                                  color: AppColors.mintGreen,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...dummyNavSquadPlayers.asMap().entries.map((entry) {
                            final i = entry.key;
                            final player = entry.value;
                            final selected = _selectedPlayerIndexes.contains(i);
                            return _SquadPlayerTile(
                              name: player['name']?.toString() ?? 'Player',
                              role: player['role']?.toString() ?? '',
                              selected: selected,
                              onTap: () {
                                setState(() {
                                  if (selected) {
                                    _selectedPlayerIndexes.remove(i);
                                  } else if (_selectedPlayerIndexes.length <
                                      requiredPlayers) {
                                    _selectedPlayerIndexes.add(i);
                                  }
                                });
                              },
                            );
                          }),
                        ],
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    final teams = provider.teamsList;
                    if (teams.isEmpty) return const SizedBox.shrink();
                    final safeIndex = _selectedIndex.clamp(0, teams.length - 1);
                    final team = teams[safeIndex];
                    final count = int.tryParse(
                          team['total_players']?.toString() ?? '0',
                        ) ??
                        0;
                    final isComplete = count >= requiredPlayers;
                    final label = isComplete ? 'Team Ready' : 'Add Team Players';

                    return GestureDetector(
                      onTap: () {
                        if (!isComplete) {
                          _openAddPlayers(team);
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TournamentRegisteredScreen(
                              tournament: widget.tournament,
                              team: team,
                            ),
                          ),
                        );
                      },
                      child: Container(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              label,
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
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

class _CreateTeamButton extends StatelessWidget {
  const _CreateTeamButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.mintGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: AppColors.mintGreen, size: 19),
            const SizedBox(width: 6),
            Text(
              'Create new team',
              style: GoogleFonts.quicksand(
                color: AppColors.mintGreen,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquadPlayerTile extends StatelessWidget {
  const _SquadPlayerTile({
    required this.name,
    required this.role,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String role;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141820),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF2A241C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  role,
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: selected ? null : Border.all(color: AppColors.glassBorderStrong),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected) ...[
                    const Icon(Icons.check_rounded, color: Colors.white, size: 15),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    selected ? 'Selected' : 'Select',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
