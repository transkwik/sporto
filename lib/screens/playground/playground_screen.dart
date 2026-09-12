import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../models/playground_player_info.dart';
import '../../models/playground_team_info.dart'; // Still used for dummy players
import '../auth/providers/location_provider.dart';
import '../home/providers/home_provider.dart';
import '../home/widgets/home_search_bar.dart';
import '../team/create_team_screen.dart';
import '../team/team_detail_screen.dart';
import 'join_team_list_screen.dart';
import 'my_team_screen.dart';
import 'widgets/playground_action_button.dart';
import 'widgets/playground_filter_chip.dart';
import 'widgets/playground_header.dart';
import 'widgets/playground_player_card.dart';
import 'widgets/playground_team_card.dart';

/// Playground tab: discover teams looking for players and players available
/// nearby, plus quick actions for creating/joining a team.
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
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

  List<Map<String, dynamic>> _getFilteredTeams(HomeProvider provider) {
    return provider.availableTeamsList;
  }

  void _openTeamDetail(BuildContext context, Map<String, dynamic> team) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => TeamDetailScreen(team: team)));
  }

  Future<void> _joinTeam(Map<String, dynamic> team) async {
    final provider = context.read<HomeProvider>();
    final teamId = team['id'] as int?;
    if (teamId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.mintGreen),
      ),
    );

    final response = await provider.joinTeamRequest(teamId);
    final success = response != null && response['success'] == true;

    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      if (success) {
        Fluttertoast.showToast(
          msg: "Join request sent successfully.",
          backgroundColor: Colors.green,
          textColor: Colors.white,
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
    final filteredTeams = _getFilteredTeams(homeProvider);

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        PlaygroundHeader(
          location: 'Kondapur, Hyderabad',
          walletBalance: '₹ 500',
          onLocationTap: () {},
          onAddFunds: () {},
          onNotificationsTap: () {},
        ),
        const SizedBox(height: 18),
        const HomeSearchBar(
          hintText: 'Search players, teams or tournaments...',
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: PlaygroundActionButton(
                icon: Icons.add_rounded,
                label: 'Create Team',
                isPrimary: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateTeamScreen()),
                ),
              ),
            ),
            Expanded(
              child: PlaygroundActionButton(
                icon: Icons.group_add_rounded,
                label: 'Join Team',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const JoinTeamListScreen()),
                ),
              ),
            ),
            Expanded(
              child: PlaygroundActionButton(
                icon: Icons.groups_rounded,
                label: 'My Team',
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const MyTeamScreen())),
              ),
            ),
            Expanded(
              child: PlaygroundActionButton(
                icon: Icons.person_search_rounded,
                label: 'Find Player',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
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
        const SizedBox(height: 26),
        const Text(
          'Teams Looking for Players',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(color: AppColors.mintGreen),
          )
        else if (filteredTeams.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No teams found for the selected filter.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ),
          )
        else
          for (final team in filteredTeams)
            PlaygroundTeamCard(
              team: team,
              onTap: () => _openTeamDetail(context, team),
              onJoin: () => _joinTeam(team),
            ),
        if (homeProvider.isFetchingMoreAvailableTeams)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.mintGreen),
            ),
          ),
        const SizedBox(height: 12),
        const Text(
          'Players Available Nearby',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        for (final player in dummyPlaygroundPlayers)
          PlaygroundPlayerCard(player: player, onInvite: () {}),
      ],
    );
  }
}
