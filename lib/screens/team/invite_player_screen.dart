import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../models/playground_player_info.dart';
import '../home/widgets/home_search_bar.dart';
import '../playground/widgets/playground_player_card.dart';

const _roleFilters = ['All', 'Bowler', 'Batter', 'All Rounder'];

/// Team Details → Invite Player: nearby available players to invite onto the squad.
class InvitePlayerScreen extends StatefulWidget {
  const InvitePlayerScreen({super.key, required this.team});

  final Map<String, dynamic> team;

  @override
  State<InvitePlayerScreen> createState() => _InvitePlayerScreenState();
}

class _InvitePlayerScreenState extends State<InvitePlayerScreen> {
  final _searchController = TextEditingController();
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
    final role = _roleFilters[_roleIndex];
    return dummyPlaygroundPlayers.where((player) {
      final matchesRole = role == 'All' ||
          player.role.toLowerCase() == role.toLowerCase() ||
          (role == 'All Rounder' && player.role.toLowerCase().contains('all'));
      final matchesQuery = query.isEmpty ||
          player.name.toLowerCase().contains(query) ||
          player.role.toLowerCase().contains(query) ||
          player.sport.toLowerCase().contains(query);
      return matchesRole && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final players = _filtered;
    final team = widget.team;
    final teamName = team['team_name'] ?? team['name'] ?? 'Unnamed Team';
    final sportName = team['sport']?['name'] ?? 'Cricket';
    final captainName = team['captain']?['name'] ?? 'Unknown Captain';
    final city = team['city'] ?? 'Hyderabad';
    final maxPlayers = team['total_players'] ?? 6;
    final playersCount = team['members']?['current_count'] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Invite Player',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.glassFillLighter,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    _TeamSummaryCard(
                      name: '$teamName',
                      sport: '$sportName',
                      captain: '$captainName',
                      city: '$city',
                      playersLabel: '$playersCount/$maxPlayers Players',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white54, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          city.toString().contains(',') ? '$city' : 'Kondapur, $city',
                          style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    HomeSearchBar(controller: _searchController),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _roleFilters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 18),
                        itemBuilder: (context, index) {
                          final selected = _roleIndex == index;
                          return GestureDetector(
                            onTap: () => setState(() => _roleIndex = index),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _roleFilters[index],
                                  style: GoogleFonts.quicksand(
                                    color: selected ? Colors.white : Colors.white54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2.5,
                                  width: selected ? 22 : 0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF8A1E),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Players Available Nearby',
                      style: GoogleFonts.quicksand(
                        color: Colors.white70,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (players.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          'No players match this filter.',
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13.5),
                        ),
                      )
                    else
                      for (final player in players)
                        PlaygroundPlayerCard(
                          player: player,
                          onInvite: _invited.contains(player.name + player.role)
                              ? null
                              : () {
                                  setState(() => _invited.add(player.name + player.role));
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

class _TeamSummaryCard extends StatelessWidget {
  const _TeamSummaryCard({
    required this.name,
    required this.sport,
    required this.captain,
    required this.city,
    required this.playersLabel,
  });

  final String name;
  final String sport;
  final String captain;
  final String city;
  final String playersLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A4A28), Color(0xFF3A4A18), Color(0xFF1A2010)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                playersLabel,
                style: GoogleFonts.quicksand(
                  color: AppColors.mintGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: sport,
                  style: GoogleFonts.quicksand(
                    color: AppColors.amberAccent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '  •  Captain: ',
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                ),
                TextSpan(
                  text: captain,
                  style: GoogleFonts.quicksand(
                    color: AppColors.mintGreen,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white54, size: 14),
              const SizedBox(width: 3),
              Text(city, style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5)),
              const SizedBox(width: 10),
              const Icon(Icons.social_distance_rounded, color: Colors.white54, size: 14),
              const SizedBox(width: 3),
              Text('4.5 km', style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5)),
            ],
          ),
        ],
      ),
    );
  }
}
