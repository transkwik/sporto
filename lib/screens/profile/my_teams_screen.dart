import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/my_team_info.dart';
import '../../models/profile_info.dart';
import '../team/create_team_screen.dart';
import 'team_history_screen.dart';
import 'widgets/my_team_card.dart';
import 'widgets/profile_sport_chips.dart';

/// Profile → My Teams: sport filter, complete squads, and action-required teams.
class MyTeamsScreen extends StatefulWidget {
  const MyTeamsScreen({super.key});

  @override
  State<MyTeamsScreen> createState() => _MyTeamsScreenState();
}

class _MyTeamsScreenState extends State<MyTeamsScreen> {
  int _selectedSport = 0;

  static const _filters = dummyProfileSports;

  String get _sportLabel => _filters[_selectedSport].$2;

  List<MyTeamInfo> get _teamsForSport =>
      dummyMyTeams.where((team) => team.sport == _sportLabel).toList();

  List<MyTeamInfo> get _complete => _teamsForSport.where((t) => t.isComplete).toList();
  List<MyTeamInfo> get _incomplete => _teamsForSport.where((t) => !t.isComplete).toList();

  Future<void> _openCreate({String? name}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateTeamScreen(initialTeamName: name ?? '')),
    );
  }

  void _openHistory(MyTeamInfo team) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeamHistoryScreen(team: team)),
    );
  }

  void _showTeamMenu(MyTeamInfo team) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1A1E28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: Colors.white70),
                  title: const Text('Edit team', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openCreate(name: team.name);
                  },
                ),
                if (!team.isComplete)
                  ListTile(
                    leading: const Icon(Icons.group_add_outlined, color: AppColors.mintGreen),
                    title: const Text('Complete team', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _openCreate(name: team.name);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final complete = _complete;
    final incomplete = _incomplete;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'My Teams',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _openCreate(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.55)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_rounded, color: AppColors.mintGreen, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Create team',
                              style: GoogleFonts.quicksand(
                                color: AppColors.mintGreen,
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
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProfileSportChips(
                  sports: _filters,
                  selectedIndex: _selectedSport,
                  onSelect: (index) => setState(() => _selectedSport = index),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: complete.isEmpty && incomplete.isEmpty
                    ? Center(
                        child: Text(
                          'No $_sportLabel teams yet.\nTap Create team to start one.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14, height: 1.5),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                        children: [
                          for (final team in complete) ...[
                            MyTeamCard(
                              team: team,
                              onTap: () => _openHistory(team),
                              onMenu: () => _showTeamMenu(team),
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (incomplete.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Action Required',
                              style: GoogleFonts.quicksand(
                                color: Colors.white54,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (final team in incomplete) ...[
                              MyTeamCard(
                                team: team,
                                onTap: () => _openCreate(name: team.name),
                                onComplete: () => _openCreate(name: team.name),
                                onMenu: () => _showTeamMenu(team),
                              ),
                              const SizedBox(height: 12),
                            ],
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
