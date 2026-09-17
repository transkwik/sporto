import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/playground_player_info.dart';
import '../auth/providers/location_provider.dart';
import '../home/widgets/home_search_bar.dart';
import 'widgets/playground_browse_chrome.dart';
import 'widgets/playground_player_card.dart';

const _sports = [
  (Icons.sports_cricket_rounded, 'Cricket'),
  (Icons.sports_soccer_rounded, 'Football'),
];

const _roles = ['All', 'Bowler', 'Batter', 'All Rounder'];

/// Playground → Find Player: nearby players to invite, matching the browse mock.
class FindPlayerScreen extends StatefulWidget {
  const FindPlayerScreen({super.key});

  @override
  State<FindPlayerScreen> createState() => _FindPlayerScreenState();
}

class _FindPlayerScreenState extends State<FindPlayerScreen> {
  final _searchController = TextEditingController();
  int _sportIndex = 0;
  bool _isPlayer = true;
  int _roleIndex = 0;
  final Set<String> _invited = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PlaygroundPlayerInfo> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    final sport = _sports[_sportIndex].$2;
    final role = _roles[_roleIndex];
    return dummyPlaygroundPlayers.where((player) {
      final matchesSport = player.sport.toLowerCase() == sport.toLowerCase();
      final matchesRole = role == 'All' ||
          player.role.toLowerCase() == role.toLowerCase() ||
          (role == 'All Rounder' && player.role.toLowerCase().contains('all'));
      final matchesQuery = query.isEmpty ||
          player.name.toLowerCase().contains(query) ||
          player.role.toLowerCase().contains(query) ||
          player.sport.toLowerCase().contains(query);
      return matchesSport && matchesRole && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>().address;
    final city = location.isNotEmpty ? location : 'Kondapur, Hyderabad';
    final players = _filtered;

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
                      'Find Player',
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
                    LimeSportChips(
                      sports: _sports,
                      selectedIndex: _sportIndex,
                      onSelect: (index) => setState(() => _sportIndex = index),
                    ),
                    const SizedBox(height: 14),
                    PlayerCaptainToggle(
                      isPlayer: _isPlayer,
                      playerLabel: 'Player',
                      captainLabel: 'Captain',
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
                    if (players.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Text(
                          'No players nearby for this filter.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13.5),
                        ),
                      )
                    else
                      for (final player in players)
                        PlaygroundPlayerCard(
                          player: player,
                          onInvite: () {
                            final key = '${player.name}-${player.role}';
                            setState(() => _invited.add(key));
                            MCP.showMessage(context, 'Invite sent to ${player.name}');
                          },
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
