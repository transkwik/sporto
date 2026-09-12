import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../auth/providers/location_provider.dart';
import '../home/providers/home_provider.dart';
import 'widgets/playground_filter_chip.dart';
import 'widgets/playground_team_card.dart';
import '../team/team_detail_screen.dart';
import '../../core/globalefunction/global_functions.dart';

class JoinTeamListScreen extends StatefulWidget {
  const JoinTeamListScreen({super.key});

  @override
  State<JoinTeamListScreen> createState() => _JoinTeamListScreenState();
}

class _JoinTeamListScreenState extends State<JoinTeamListScreen> {
  int _selectedFilter = 0; // 0 = All, 1.. = sport index + 1
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

    int? sportId;
    if (_selectedFilter > 0) {
      final sports = provider.sportsList;
      if (_selectedFilter - 1 < sports.length) {
        sportId = sports[_selectedFilter - 1]['id'] as int?;
      }
    }

    double? lat = locProvider.latitude != 0.0 ? locProvider.latitude : null;
    double? lng = locProvider.longitude != 0.0 ? locProvider.longitude : null;

    provider.fetchAvailableTeams(
      isRefresh: isRefresh,
      sportId: sportId,
      latitude: lat,
      longitude: lng,
    );
  }

  void _openTeamDetail(BuildContext context, Map<String, dynamic> team) {
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

    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      if (success) {
        MCP.showMessage(
          context,
          "Join request sent successfully.",
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
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final isLoading = homeProvider.isFetchingAvailableTeams;
    final teams = homeProvider.availableTeamsList;

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
                      'Join Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    PlaygroundFilterChip(
                      label: 'All',
                      selected: _selectedFilter == 0,
                      onTap: () {
                        setState(() => _selectedFilter = 0);
                        _fetchAvailableTeams(isRefresh: true);
                      },
                    ),
                    if (homeProvider.isFetchingSports)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(color: AppColors.mintGreen, strokeWidth: 2),
                          ),
                        ),
                      )
                    else
                      for (var i = 0; i < homeProvider.sportsList.length; i++) ...[
                        const SizedBox(width: 10),
                        PlaygroundFilterChip(
                          label: homeProvider.sportsList[i]['name'] ?? '',
                          icon: Icons.sports_rounded,
                          selected: _selectedFilter == i + 1,
                          onTap: () {
                            setState(() => _selectedFilter = i + 1);
                            _fetchAvailableTeams(isRefresh: true);
                          },
                        ),
                      ],
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
                    : teams.isEmpty
                        ? const Center(
                            child: Text(
                              'No teams found.',
                              style: TextStyle(color: Colors.white54, fontSize: 13),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                            itemCount: teams.length + (homeProvider.isFetchingMoreAvailableTeams ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == teams.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(color: AppColors.mintGreen),
                                  ),
                                );
                              }
                              final team = teams[index];
                              return PlaygroundTeamCard(
                                team: team,
                                onTap: () => _openTeamDetail(context, team),
                                onJoin: () => _joinTeam(team),
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
