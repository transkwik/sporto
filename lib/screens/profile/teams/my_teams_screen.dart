import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../models/profile_info.dart';
import '../../team/create_team_screen.dart';
import '../../team/widgets/add_player_sheet.dart';
import 'team_history_screen.dart';
import 'widgets/my_team_card.dart';
import '../widgets/profile_sport_chips.dart';
import '../../../core/apiServices/user_api.dart';
import 'dart:developer';

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

  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _allTeams = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && !_isFetchingMore && _currentPage < _lastPage) {
        _fetchTeams(isRefresh: false);
      }
    }
  }

  Future<void> _fetchTeams({bool isRefresh = true}) async {
    if (isRefresh) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
      });
    } else {
      setState(() => _isFetchingMore = true);
    }

    try {
      final response = await UserApis().getMyTeams(_currentPage, 20);
      if (response != null && response['success'] == true) {
        final data = response['data'] as List<dynamic>?;
        if (data != null) {
          final mappedData = data.map((e) => e as Map<String, dynamic>).toList();

          setState(() {
            if (isRefresh) _allTeams.clear();
            _allTeams.addAll(mappedData);
            _currentPage++;
            _lastPage = response['meta']?['last_page'] ?? 1;
          });
        }
      }
    } catch (e) {
      log('Error fetching teams: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  List<Map<String, dynamic>> get _teamsForSport => _allTeams.where((team) {
    final sport = team['sport']?['name']?.toString() ?? '';
    return sport == _sportLabel;
  }).toList();

  List<Map<String, dynamic>> get _complete => _teamsForSport.where((t) => t['completion']?['is_complete'] == true).toList();
  List<Map<String, dynamic>> get _incomplete => _teamsForSport.where((t) => t['completion']?['is_complete'] != true).toList();

  Future<void> _openCreate({String? name}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreateTeamScreen(initialTeamName: name ?? '')),
    );
  }

  void _completeTeam(Map<String, dynamic> team) {
    final teamId = team['id'] as int?;
    if (teamId == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => AddPlayerSheet(
        playerNumber: (team['players']?['current'] ?? 0) + 1,
        onSend: (name, phone) => _submitCompletePlayer(teamId, name, phone),
      ),
    );
  }

  Future<void> _submitCompletePlayer(int teamId, String name, String phone) async {
    setState(() => _isLoading = true);
    try {
      final response = await UserApis().inviteTeamPlayer(teamId, {
        "mobile_number": phone,
        "country_code": "+91",
        "name": name,
      });

      if (response != null && response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Player invited successfully.')),
          );
        }
        await _fetchTeams(isRefresh: true);
      } else {
        throw Exception(response?['message'] ?? 'Failed to add player');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openHistory(Map<String, dynamic> team) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeamHistoryScreen(team: team)),
    );
  }

  void _showTeamMenu(Map<String, dynamic> team) {
    final completion = team['completion'] ?? {};
    final showCompleteButton = completion['action'] == 'COMPLETE_TEAM';
    final actionLabel = completion['action_label']?.toString() ?? 'Complete Team';
    final teamName = team['team_name']?.toString() ?? '';
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
                    _openCreate(name: teamName);
                  },
                ),
                if (showCompleteButton)
                  ListTile(
                    leading: const Icon(Icons.group_add_outlined, color: AppColors.mintGreen),
                    title: Text(actionLabel, style: const TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(ctx);
                      _completeTeam(team);
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
                if (_isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => _fetchTeams(isRefresh: true),
                      color: AppColors.mintGreen,
                      backgroundColor: const Color(0xFF161A24),
                      child: complete.isEmpty && incomplete.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                                Center(
                                  child: Text(
                                    'No $_sportLabel teams yet.\nTap Create team to start one.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14, height: 1.5),
                                  ),
                                ),
                              ],
                            )
                          : ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
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
                                onTap: () => _openHistory(team),
                                onComplete: () => _completeTeam(team),
                                onMenu: () => _showTeamMenu(team),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                          if (_isFetchingMore)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        ],
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
