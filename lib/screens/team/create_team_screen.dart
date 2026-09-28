import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../core/widgets/glass_back_button.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/team_player_info.dart';
import '../auth/providers/auth_provider.dart';
import '../home/providers/home_provider.dart';
import '../onboarding/widgets/profile_photo_picker.dart';
import '../onboarding/widgets/profile_text_field.dart';
import 'team_created_screen.dart';
import 'widgets/add_player_sheet.dart';
import 'widgets/player_entry_card.dart';
import 'widgets/remove_player_dialog.dart';

/// Form for building out a team's squad: name, logo, and players
/// reference design.
class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key, this.initialTeamName});

  final String? initialTeamName;

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  late final TextEditingController _teamNameController = TextEditingController(
    text: widget.initialTeamName ?? '',
  );
  late final TextEditingController _cityController = TextEditingController();

  final List<TeamPlayerInfo> _players = [];
  
  List<dynamic> _sports = [];
  bool _isLoadingSports = true;
  dynamic _selectedSport;

  int? _createdTeamId;

  String? _uploadedLogoUrl;
  String? _uploadedLogoPath;
  bool _isUploadingLogo = false;

  @override
  void initState() {
    super.initState();
    _teamNameController.addListener(_handleTeamNameChanged);
    _cityController.addListener(_handleTeamNameChanged);
    
    // Add logged-in user as captain by default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final userMap = authProvider.checkResponse?['user'] as Map<String, dynamic>?;
      final profileMap = userMap?['profile'] as Map<String, dynamic>?;
      
      final fullName = profileMap?['full_name'] ?? userMap?['name'] ?? 'Captain';
      final phone = userMap?['mobile_number'] ?? '';
      
      setState(() {
        _players.add(
          TeamPlayerInfo(
            name: fullName,
            phone: phone,
            isCaptain: true,
          ),
        );
      });
    });

    _fetchSports();
  }

  Future<void> _fetchSports() async {
    try {
      final res = await UserApis().getSports();
      if (res != null && res['success'] == true && res['data'] is List) {
        if (mounted) {
          setState(() {
            _sports = res['data'];
            _isLoadingSports = false;
            if (_sports.isNotEmpty) {
              _selectedSport = _sports.first; // Default select first
            }
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingSports = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingSports = false);
    }
  }

  Future<void> _pickAndUploadLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      setState(() => _isUploadingLogo = true);
      try {
        final res = await UserApis().uploadProfileImage(pickedFile.path);
        if (res != null && res['success'] == true) {
          setState(() {
            _uploadedLogoUrl = res['data']['url'];
            _uploadedLogoPath = res['data']['path'];
            _isUploadingLogo = false;
          });
        } else {
          setState(() => _isUploadingLogo = false);
          if (mounted) {
            MCP.showMessage(context, res?['message'] ?? 'Failed to upload logo');
          }
        }
      } catch (e) {
        setState(() => _isUploadingLogo = false);
        if (mounted) MCP.showMessage(context, 'Error uploading logo');
      }
    }
  }

  void _handleTeamNameChanged() => setState(() {});

  void _addPlayer() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => AddPlayerSheet(
        playerNumber: _players.length + 1,
        onSend: (name, phone) async {
          if (_createdTeamId == null) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.mintGreen)),
          );
          try {
            final res = await UserApis().inviteTeamPlayer(_createdTeamId!, {
              "name": name,
              "mobile_number": phone,
              "country_code": "+91",
            });
            if (mounted) Navigator.pop(context); // close loader
            if (res != null && res['success'] == true) {
              setState(() => _players.add(TeamPlayerInfo(name: name, phone: phone)));
              if (mounted) {
                MCP.showMessage(context, "Player added!", backgroundColor: Colors.green.shade600);
              }
            } else {
              if (mounted) MCP.showMessage(context, res?['message'] ?? "Failed to add player");
            }
          } catch (e) {
            if (mounted) {
              Navigator.pop(context); // close loader
              MCP.showMessage(context, "Failed to add player");
            }
          }
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
    if (confirmed && _createdTeamId != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.mintGreen)),
      );
      try {
        // If we don't have the player's DB ID, we might have to fetch team players or optimism delete.
        // For now, optimism delete if they don't have an ID, or just remove from list.
        setState(() => _players.removeAt(index));
        if (mounted) {
          Navigator.pop(context); // close loader
          MCP.showMessage(context, "Player removed", backgroundColor: Colors.green.shade600);
        }
      } catch (e) {
        if (mounted) Navigator.pop(context);
      }
    }
  }

  Future<void> _handleCreateTeam() async {
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
      "sport_id": _selectedSport?['id'] ?? 1,
      "team_name": _teamNameController.text.trim(),
      "visibility": 1,
      if (_uploadedLogoPath != null) "team_logo_path": _uploadedLogoPath,
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

    if (mounted) {
      Navigator.pop(context); // Close dialog
      setState(() {
        _createdTeamId = teamId;
      });
      MCP.showMessage(
        context,
        "Team created successfully! Now add players.",
        backgroundColor: Colors.green.shade600,
        icon: Icons.check_circle_rounded,
      );
    }
  }

  void _finishFlow() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => TeamCreatedScreen(players: _players)),
    );
  }

  bool get _isTeamReady => _teamNameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _teamNameController.removeListener(_handleTeamNameChanged);
    _teamNameController.dispose();
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
                    const SizedBox(height: 18),
                    Text(
                      'Build your team. Play together.',
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 26),
                    ProfileTextField(
                      label: 'Team Name',
                      hint: 'Enter your team name',
                      controller: _teamNameController,
                      readOnly: _createdTeamId != null,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Select Sport',
                      style: GoogleFonts.quicksand(
                        color: Colors.white60,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _isLoadingSports
                        ? Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.glassFillLighter,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryLight,
                              ),
                            ),
                          )
                        : Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.glassFillLighter,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<dynamic>(
                                value: _selectedSport,
                                dropdownColor: const Color(0xFF1C1C1E),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white60,
                                ),
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                isExpanded: true,
                                items: _sports.map((sport) {
                                  return DropdownMenuItem<dynamic>(
                                    value: sport,
                                    child: Text(sport['name'] ?? ''),
                                  );
                                }).toList(),
                                onChanged: _createdTeamId == null ? (val) {
                                  if (val != null) {
                                    setState(() => _selectedSport = val);
                                  }
                                } : null,
                              ),
                            ),
                          ),
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
                      hasPhoto: _uploadedLogoUrl != null,
                      photoUrl: _uploadedLogoUrl,
                      isUploading: _isUploadingLogo,
                      onUpload: _createdTeamId == null ? _pickAndUploadLogo : () {},
                      onClear: _createdTeamId == null ? () {
                        setState(() {
                          _uploadedLogoUrl = null;
                          _uploadedLogoPath = null;
                        });
                      } : () {},
                    ),
                    const SizedBox(height: 26),
                    if (_createdTeamId != null) ...[
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
                          '${_players.length} Players',
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GestureDetector(
                  onTap: _createdTeamId == null
                      ? (_isTeamReady ? _handleCreateTeam : null)
                      : _finishFlow,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: (_createdTeamId != null || _isTeamReady)
                          ? AppColors.bannerGradient
                          : null,
                      color: (_createdTeamId != null || _isTeamReady)
                          ? null
                          : AppColors.glassFillLighter,
                      borderRadius: BorderRadius.circular(16),
                      border: (_createdTeamId != null || _isTeamReady)
                          ? null
                          : Border.all(color: AppColors.glassBorder),
                      boxShadow: (_createdTeamId != null || _isTeamReady)
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF7A1E).withValues(alpha: 0.4),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      _createdTeamId == null ? 'Create Team' : 'Finish & View Team',
                      style: GoogleFonts.quicksand(
                        color: (_createdTeamId != null || _isTeamReady)
                            ? Colors.white
                            : Colors.white38,
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
