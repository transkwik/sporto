import 'package:flutter/material.dart';
import '../../models/playground_player_info.dart';
import '../../models/playground_team_info.dart';
import '../home/widgets/home_search_bar.dart';
import '../team/create_team_screen.dart';
import '../team/team_detail_screen.dart';
import 'widgets/playground_action_button.dart';
import 'widgets/playground_filter_chip.dart';
import 'widgets/playground_header.dart';
import 'widgets/playground_player_card.dart';
import 'widgets/playground_team_card.dart';

const List<String> _kSportFilters = ['Cricket', 'Football', 'Badminton', 'Kabaddi'];

/// Playground tab: discover teams looking for players and players available
/// nearby, plus quick actions for creating/joining a team.
class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  int _selectedFilter = 0; // 0 = Nearby, 1 = All, 2.. = sport index + 2

  void _openTeamDetail(BuildContext context, PlaygroundTeamInfo team) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeamDetailScreen(team: team)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        const HomeSearchBar(hintText: 'Search players, teams or tournaments...'),
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
              child: PlaygroundActionButton(icon: Icons.group_add_rounded, label: 'Join Team', onTap: () {}),
            ),
            Expanded(
              child: PlaygroundActionButton(icon: Icons.groups_rounded, label: 'My Team', onTap: () {}),
            ),
            Expanded(
              child: PlaygroundActionButton(icon: Icons.person_search_rounded, label: 'Find Player', onTap: () {}),
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
                label: 'Nearby',
                icon: Icons.location_on_outlined,
                selected: _selectedFilter == 0,
                onTap: () => setState(() => _selectedFilter = 0),
              ),
              const SizedBox(width: 10),
              PlaygroundFilterChip(
                label: 'All',
                selected: _selectedFilter == 1,
                onTap: () => setState(() => _selectedFilter = 1),
              ),
              for (var i = 0; i < _kSportFilters.length; i++) ...[
                const SizedBox(width: 10),
                PlaygroundFilterChip(
                  label: _kSportFilters[i],
                  icon: Icons.sports_rounded,
                  selected: _selectedFilter == i + 2,
                  onTap: () => setState(() => _selectedFilter = i + 2),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Text(
          'Teams Looking for Players',
          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        for (final team in dummyPlaygroundTeams)
          PlaygroundTeamCard(
            team: team,
            onTap: () => _openTeamDetail(context, team),
            onJoin: () => _openTeamDetail(context, team),
          ),
        const SizedBox(height: 12),
        const Text(
          'Players Available Nearby',
          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        for (final player in dummyPlaygroundPlayers) PlaygroundPlayerCard(player: player, onInvite: () {}),
      ],
    );
  }
}
