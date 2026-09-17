import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/globalefunction/global_functions.dart';
import '../auth/providers/location_provider.dart';
import '../home/providers/home_provider.dart';
import '../home/widgets/home_search_bar.dart';
import '../team/team_detail_screen.dart';
import 'widgets/playground_browse_chrome.dart';
import 'widgets/playground_team_card.dart';

const _sports = [
  (Icons.sports_cricket_rounded, 'Cricket'),
  (Icons.sports_soccer_rounded, 'Football'),
];

const _roles = ['All', 'Bowler', 'Batter', 'All Rounder'];

class JoinTeamListScreen extends StatefulWidget {
  const JoinTeamListScreen({super.key});

  @override
  State<JoinTeamListScreen> createState() => _JoinTeamListScreenState();
}

class _JoinTeamListScreenState extends State<JoinTeamListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  int _sportIndex = 0;
  bool _isPlayer = true;
  bool _readyToPlay = true;
  int _roleIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      provider.fetchSports();
      if (!provider.isFetchingAvailableTeams && provider.availableTeamsList.isEmpty) {
        _fetchAvailableTeams(isRefresh: true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<HomeProvider>();
      if (!provider.isFetchingAvailableTeams && !provider.isFetchingMoreAvailableTeams) {
        _fetchAvailableTeams(isRefresh: false);
      }
    }
  }

  void _fetchAvailableTeams({bool isRefresh = false}) {
    final provider = context.read<HomeProvider>();
    final locProvider = context.read<LocationProvider>();
    final sportName = _sports[_sportIndex].$2.toLowerCase();
    int? sportId;
    for (final sport in provider.sportsList) {
      if ('${sport['name']}'.toLowerCase() == sportName) {
        sportId = sport['id'] as int?;
        break;
      }
    }

    provider.fetchAvailableTeams(
      isRefresh: isRefresh,
      sportId: sportId,
      latitude: locProvider.latitude != 0.0 ? locProvider.latitude : null,
      longitude: locProvider.longitude != 0.0 ? locProvider.longitude : null,
    );
  }

  List<Map<String, dynamic>> _visibleTeams(List<Map<String, dynamic>> teams) {
    final query = _searchController.text.trim().toLowerCase();
    final sport = _sports[_sportIndex].$2.toLowerCase();
    return teams.where((team) {
      final name = '${team['team_name'] ?? team['name'] ?? ''}'.toLowerCase();
      final sportName = '${team['sport']?['name'] ?? ''}'.toLowerCase();
      final matchesSport = sportName.isEmpty || sportName == sport;
      final matchesQuery = query.isEmpty || name.contains(query) || sportName.contains(query);
      return matchesSport && matchesQuery;
    }).toList();
  }

  void _openTeamDetail(Map<String, dynamic> team) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeamDetailScreen(team: team)),
    );
  }

  Future<void> _joinTeam(Map<String, dynamic> team) async {
    final provider = context.read<HomeProvider>();
    final teamId = team['id'] as int?;
    if (teamId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.mintGreen)),
    );

    final response = await provider.joinTeamRequest(teamId);
    final success = response != null && response['success'] == true;

    if (!mounted) return;
    Navigator.pop(context);
    if (success) {
      MCP.showMessage(
        context,
        'Join request sent successfully.',
        backgroundColor: Colors.green.shade600,
        icon: Icons.check_circle_rounded,
      );
    } else {
      Fluttertoast.showToast(
        msg: provider.errorMessage ?? 'Failed to send join request.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final location = context.watch<LocationProvider>().address;
    final city = location.isNotEmpty ? location : 'Kondapur, Hyderabad';
    final teams = _visibleTeams(homeProvider.availableTeamsList);
    final isLoading = homeProvider.isFetchingAvailableTeams;

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
                      'Join Team',
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
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    ReadyToPlayBanner(
                      enabled: _readyToPlay,
                      onChanged: (value) => setState(() => _readyToPlay = value),
                    ),
                    const SizedBox(height: 14),
                    LimeSportChips(
                      sports: _sports,
                      selectedIndex: _sportIndex,
                      onSelect: (index) {
                        setState(() => _sportIndex = index);
                        _fetchAvailableTeams(isRefresh: true);
                      },
                    ),
                    const SizedBox(height: 14),
                    PlayerCaptainToggle(
                      isPlayer: _isPlayer,
                      onChanged: (value) => setState(() => _isPlayer = value),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white54, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          city,
                          style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    HomeSearchBar(controller: _searchController),
                    const SizedBox(height: 16),
                    RoleUnderlineFilters(
                      roles: _roles,
                      selectedIndex: _roleIndex,
                      onSelect: (index) => setState(() => _roleIndex = index),
                    ),
                    const SizedBox(height: 16),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: CircularProgressIndicator(color: AppColors.mintGreen)),
                      )
                    else if (teams.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Text(
                          'No teams found.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13.5),
                        ),
                      )
                    else
                      for (final team in teams)
                        PlaygroundTeamCard(
                          team: team,
                          onTap: () => _openTeamDetail(team),
                          onJoin: () => _joinTeam(team),
                        ),
                    if (homeProvider.isFetchingMoreAvailableTeams)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator(color: AppColors.mintGreen)),
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
