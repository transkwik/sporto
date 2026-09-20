import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_player_info.dart';
import 'widgets/add_player_sheet.dart';
import 'widgets/player_entry_card.dart';
import 'widgets/team_roster_card.dart';

class AddPlayersScreen extends StatefulWidget {
  const AddPlayersScreen({
    super.key,
    required this.team,
    required this.tournament,
  });

  final Map<String, dynamic> team;
  final Map<String, dynamic> tournament;

  @override
  State<AddPlayersScreen> createState() => _AddPlayersScreenState();
}

class _AddPlayersScreenState extends State<AddPlayersScreen> {
  List<TeamPlayerInfo> _players = [];
  bool _isLoading = false;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    final teamId = widget.team['id'] as int?;
    if (teamId == null) return;

    setState(() => _isFetching = true);
    try {
      final response = await UserApis().getTeamPlayers(teamId);
      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        setState(() {
          _players = data.map((p) {
            String name = p['player_name'] ?? '';
            String phone = p['mobile_number'] ?? '';
            
            if (p['user'] != null) {
              if (name == 'Captain' || name.isEmpty) {
                name = p['user']['profile']?['full_name'] ?? p['user']['name'] ?? name;
              }
              if (phone.isEmpty) {
                phone = p['user']['mobile_number'] ?? '';
              }
            }

            return TeamPlayerInfo(
              id: p['id'],
              name: name.isEmpty ? 'Unknown' : name,
              phone: phone,
              isCaptain: p['is_captain'] == 1 || p['is_captain'] == true,
            );
          }).toList();

          // Ensure the captain is always Player 1 (index 0)
          _players.sort((a, b) {
            if (a.isCaptain && !b.isCaptain) return -1;
            if (!a.isCaptain && b.isCaptain) return 1;
            return 0;
          });

          // Keep the top card in sync with actual fetched players
          widget.team['total_players'] = _players.length;
          widget.team['player_count'] = _players.length;
        });
      }
    } catch (e) {
      // Ignore errors silently for now or show toast
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  void _addPlayer() {
    final int maxPlayers = int.tryParse(widget.team['sport']?['max_players']?.toString() ?? '11') ?? 11;
    if (_players.length >= maxPlayers) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => AddPlayerSheet(
        playerNumber: _players.length + 1,
        onSend: (name, phone) => _submitPlayer(name, phone),
      ),
    );
  }

  Future<void> _submitPlayer(String name, String phone) async {
    final teamId = widget.team['id'] as int?;
    if (teamId == null) return;

    setState(() => _isLoading = true);
    try {
      final response = await UserApis().addTeamPlayer(teamId, {
        "player_name": name,
        "mobile_number": phone,
        "country_code": "+91",
      });

      if (response != null && response['success'] == true) {
        await _fetchPlayers();
        if (mounted) {
          MCP.showMessage(
            context,
            response['message'] ?? 'Player invited successfully.',
            backgroundColor: Colors.green.shade600,
            icon: Icons.check_circle_rounded,
          );
        }
      } else {
        throw Exception(response?['message'] ?? 'Failed to add player');
      }
    } catch (e) {
      if (mounted) {
        MCP.showMessage(context, e.toString().replaceAll("Exception: ", ""));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _removePlayer(int? playerId) async {
    if (playerId == null) return;
    final teamId = widget.team['id'] as int?;
    if (teamId == null) return;

    setState(() => _isLoading = true);
    try {
      final response = await UserApis().removeTeamPlayer(teamId, playerId);
      if (response != null && response['success'] == true) {
        await _fetchPlayers();
        if (mounted) {
          MCP.showMessage(
            context,
            response['message'] ?? 'Player removed successfully.',
            backgroundColor: Colors.green.shade600,
            icon: Icons.check_circle_rounded,
          );
        }
      } else {
        throw Exception(response?['message'] ?? 'Failed to remove player');
      }
    } catch (e) {
      if (mounted) {
        MCP.showMessage(context, e.toString().replaceAll("Exception: ", ""));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> gameRules = List<dynamic>.from(widget.tournament['game_rules'] ?? []);
    final List<dynamic> sportRules = List<dynamic>.from(widget.tournament['sport_rules'] ?? []);
    final List<dynamic> allRules = [...gameRules, ...sportRules];

    int requiredPlayers = 11;
    for (final dynamic rule in allRules) {
      if (rule is Map && rule['key']?.toString().toLowerCase() == 'minimum_players_per_team') {
        final overrideVal = rule['override_value']?.toString();
        final defaultVal = rule['default_value']?.toString();
        
        if (overrideVal != null && overrideVal.trim().isNotEmpty && overrideVal != '0' && overrideVal != '0.0') {
          requiredPlayers = double.tryParse(overrideVal)?.toInt() ?? 11;
          break;
        } else if (defaultVal != null && defaultVal.trim().isNotEmpty && defaultVal != '0' && defaultVal != '0.0') {
          requiredPlayers = double.tryParse(defaultVal)?.toInt() ?? 11;
          break;
        }
      }
    }
    if (requiredPlayers == 0) requiredPlayers = 11;

    final int totalCount = _players.length;
    final bool isFull = totalCount >= requiredPlayers;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
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
                      'Add Team Players',
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  children: [
                    TeamRosterCard(team: widget.team, requiredPlayers: requiredPlayers),
                    const SizedBox(height: 24),
                    Text(
                      'Team Players',
                      style: GoogleFonts.quicksand(color: Colors.white60, fontSize: 13.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    if (_isFetching && _players.isEmpty)
                      const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(color: AppColors.primaryLight),
                      ))
                    else if (_players.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'No players found.',
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13),
                        ),
                      ),
                    for (var i = 0; i < _players.length; i++) ...[
                      Row(
                        children: [
                          Text(
                            _players[i].isCaptain ? 'Player ${i + 1} Captain' : 'Player ${i + 1}',
                            style: const TextStyle(color: Colors.white60, fontSize: 13.5, fontWeight: FontWeight.w500),
                          ),
                          if (_players[i].isCaptain) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.mintGreen.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                'Active',
                                style: GoogleFonts.quicksand(color: AppColors.mintGreen, fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      PlayerEntryCard(
                        player: _players[i],
                        onEdit: () {}, 
                        onRemove: _players[i].isCaptain ? null : () => _removePlayer(_players[i].id),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Text(
                          '$totalCount/$requiredPlayers Players',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        if (!isFull)
                          GestureDetector(
                            onTap: _isLoading ? null : _addPlayer,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.6)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isLoading)
                                    const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(color: AppColors.primaryLight, strokeWidth: 2),
                                    )
                                  else
                                    Icon(Icons.add_rounded, color: AppColors.primaryLight, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Add New Player',
                                    style: GoogleFonts.quicksand(color: AppColors.primaryLight, fontSize: 12.5, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
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
                          color: const Color(0xFFFF7A1E).withValues(alpha: 0.4),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      isFull ? 'Done' : 'Finish Later',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
