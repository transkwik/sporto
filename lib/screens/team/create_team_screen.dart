import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_player_info.dart';
import '../home/providers/home_provider.dart';
import '../onboarding/widgets/profile_photo_picker.dart';
import '../onboarding/widgets/profile_text_field.dart';
import 'team_created_screen.dart';
import 'widgets/add_player_sheet.dart';
import 'widgets/player_entry_card.dart';
import 'widgets/remove_player_dialog.dart';

const int _kMaxPlayers = 5;

/// Form for building out a team's squad: name, logo, and up to five
/// players (the first being the captain), matching the "Create New Team"
/// reference design.
class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key, this.initialTeamName});

  final String? initialTeamName;

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  late final TextEditingController _teamNameController = TextEditingController(
    text: widget.initialTeamName ?? 'Thunder Titans',
  );
  late final TextEditingController _cityController = TextEditingController();
  bool _hasPhoto = false;

  final List<TeamPlayerInfo> _players = const [
    TeamPlayerInfo(
      name: 'Amit Kumar',
      phone: '+91 9008007006',
      isCaptain: true,
    ),
  ].toList();

  @override
  void initState() {
    super.initState();
    _teamNameController.addListener(_handleTeamNameChanged);
    _cityController.addListener(_handleTeamNameChanged);
  }

  void _handleTeamNameChanged() => setState(() {});

  void _addPlayer() {
    if (_players.length >= _kMaxPlayers) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => AddPlayerSheet(
        playerNumber: _players.length + 1,
        onSend: (name, phone) {
          setState(
            () => _players.add(TeamPlayerInfo(name: name, phone: phone)),
          );
        },
      ),
    );
  }

  void _editPlayer(int index) {
    final player = _players[index];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => AddPlayerSheet(
        playerNumber: index + 1,
        isEdit: true,
        initialName: player.name,
        initialPhone: player.phone,
        onSend: (name, phone) {
          setState(
            () => _players[index] = TeamPlayerInfo(
              name: name,
              phone: phone,
              isCaptain: player.isCaptain,
            ),
          );
        },
      ),
    );
  }

  Future<void> _removePlayer(int index) async {
    if (_players[index].isCaptain) return;
    final player = _players[index];
    final teamName = _teamNameController.text.trim().isEmpty
        ? 'your team'
        : _teamNameController.text.trim();
    final confirmed = await RemovePlayerDialog.show(
      context,
      playerName: player.name,
      teamName: teamName,
    );
    if (confirmed) setState(() => _players.removeAt(index));
  }

  Future<void> _handleSaveTeam() async {
    if (!_isTeamReady) return;

    final provider = Provider.of<HomeProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.mintGreen),
      ),
    );

    final params = {
      "sport_id": 1, // Defaulting to 1
      "team_name": _teamNameController.text.trim(),
      "city": _cityController.text.trim(),
      "visibility": 1,
    };

    final response = await provider.createTeam(params);
    final teamId = response?['data']?['id'] as int?;

    if (teamId == null) {
      if (mounted) {
        Navigator.pop(context); // Close dialog
        MCP.showMessage(
          context,
          provider.errorMessage ?? "Failed to create team.",
        );
      }
      return;
    }

    // Now add all players (including captain if they are in the list)
    for (final player in _players) {
      try {
        await UserApis().addTeamPlayer(teamId, {
          "player_name": player.name,
          "mobile_number": player.phone,
          "country_code": "+91", // defaulting country code
        });
      } catch (e) {
        debugPrint('Failed to add player: ${player.name}');
      }
    }

    if (mounted) {
      Navigator.pop(context); // Close dialog
      MCP.showMessage(
        context,
        "Team created successfully!",
        backgroundColor: Colors.green.shade600,
        icon: Icons.check_circle_rounded,
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TeamCreatedScreen(players: _players)),
      );
    }
  }

  bool get _isTeamReady =>
      _players.length == _kMaxPlayers &&
      _teamNameController.text.trim().isNotEmpty &&
      _cityController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _teamNameController.removeListener(_handleTeamNameChanged);
    _teamNameController.dispose();
    _cityController.removeListener(_handleTeamNameChanged);
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      'Create New Team',
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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  children: [
                    Text(
                      '$_kMaxPlayers Players Per Team',
                      style: GoogleFonts.quicksand(
                        color: AppColors.mintGreen,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Build your team Play together.',
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 26),
                    ProfileTextField(
                      label: 'Team Name',
                      hint: 'Enter your team name',
                      controller: _teamNameController,
                    ),
                    // const SizedBox(height: 18),
                    // ProfileTextField(
                    //   label: 'City',
                    //   hint: 'Enter your city',
                    //   controller: _cityController,
                    // ),
                    const SizedBox(height: 24),
                    Text(
                      'Team Logo or Photo',
                      style: GoogleFonts.quicksand(
                        color: Colors.white60,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ProfilePhotoPicker(
                      hasPhoto: _hasPhoto,
                      onUpload: () => setState(() => _hasPhoto = true),
                      onClear: () => setState(() => _hasPhoto = false),
                    ),
                    const SizedBox(height: 26),
                    for (var i = 0; i < _players.length; i++) ...[
                      Row(
                        children: [
                          Text(
                            _players[i].isCaptain
                                ? 'Player ${i + 1} Captain'
                                : 'Player ${i + 1}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_players[i].isCaptain) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.mintGreen.withValues(
                                  alpha: 0.16,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.mintGreen.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Active',
                                style: GoogleFonts.quicksand(
                                  color: AppColors.mintGreen,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      PlayerEntryCard(
                        player: _players[i],
                        onEdit: () => _editPlayer(i),
                        onRemove: () => _removePlayer(i),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Text(
                          '${_players.length}/$_kMaxPlayers',
                          style: GoogleFonts.quicksand(
                            color: Colors.white54,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _addPlayer,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 08,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryLight.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  color: AppColors.primaryLight,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Add New Player',
                                  style: GoogleFonts.quicksand(
                                    color: AppColors.primaryLight,
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GestureDetector(
                  onTap: _isTeamReady ? _handleSaveTeam : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: _isTeamReady ? AppColors.bannerGradient : null,
                      color: _isTeamReady ? null : AppColors.glassFillLighter,
                      borderRadius: BorderRadius.circular(16),
                      border: _isTeamReady
                          ? null
                          : Border.all(color: AppColors.glassBorder),
                      boxShadow: _isTeamReady
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF7A1E,
                                ).withValues(alpha: 0.4),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      'Save Team',
                      style: GoogleFonts.quicksand(
                        color: _isTeamReady ? Colors.white : Colors.white38,
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
