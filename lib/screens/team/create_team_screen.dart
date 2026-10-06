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
  const CreateTeamScreen({
    super.key,
    this.initialTeamName,
    this.maxPlayers = 5,
    this.tournament,
  });

  final String? initialTeamName;
  final int maxPlayers;
  final Map<String, dynamic>? tournament;

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
      
      final fullName = profileMap?['full_name'] ?? userMap?['name'];
      final phone = userMap?['mobile_number']?.toString() ?? '';
      if (fullName == null || fullName.toString().trim().isEmpty) return;

      setState(() {
        _players.add(
          TeamPlayerInfo(
            name: fullName.toString(),
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

  void _addPlayer({bool asCaptain = false}) {
    if (_players.length >= widget.maxPlayers) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => AddPlayerSheet(
        playerNumber: asCaptain ? 1 : _players.length + 1,
        onSend: (name, phone) async {
          if (_createdTeamId == null) {
            setState(
              () => _players.add(
                TeamPlayerInfo(name: name, phone: phone, isCaptain: asCaptain),
              ),
            );
            return;
          }
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
              setState(() => _players.add(TeamPlayerInfo(name: name, phone: phone, isCaptain: asCaptain)));
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
    if (confirmed) {
      if (_createdTeamId != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.mintGreen)),
        );
        try {
          setState(() => _players.removeAt(index));
          if (mounted) {
            Navigator.pop(context);
            MCP.showMessage(context, "Player removed", backgroundColor: Colors.green.shade600);
          }
        } catch (e) {
          if (mounted) Navigator.pop(context);
        }
      } else {
        setState(() => _players.removeAt(index));
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

  Future<void> _handleSaveTeam() async {
    if (_players.length < widget.maxPlayers) return;
    if (_createdTeamId != null) {
      _finishFlow();
      return;
    }
    await _handleCreateTeam();
    if (_createdTeamId != null) {
      _finishFlow();
    } else if (mounted) {
      _finishFlow();
    }
  }

  bool get _isSquadFull => _players.length >= widget.maxPlayers;

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
                    Text(
                      '${widget.maxPlayers} Players Per Team',
                      style: GoogleFonts.quicksand(
                        color: AppColors.mintGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Build your team Play together.',
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
                    Text(
                      'Captain',
                      style: GoogleFonts.quicksand(
                        color: Colors.white60,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if (_players.any((p) => p.isCaptain)) return;
                        _addPlayer(asCaptain: true);
                      },
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFC45AD4).withValues(alpha: 0.7)),
                        ),
                        child: Text(
                          '+ Add Captain',
                          style: GoogleFonts.quicksand(
                            color: const Color(0xFFC45AD4),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.mintGreen.withValues(alpha: 0.4),
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
                        if (_isSquadFull) ...[
                          const Icon(Icons.check_rounded, color: AppColors.mintGreen, size: 16),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          '${_players.length}/${widget.maxPlayers}',
                          style: GoogleFonts.quicksand(
                            color: Colors.white54,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_isSquadFull) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              'Team Completed',
                              style: GoogleFonts.quicksand(
                                color: AppColors.mintGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (!_isSquadFull)
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
                                  color: AppColors.primaryLight.withValues(alpha: 0.6),
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
                                  const SizedBox(width: 4),
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
                  onTap: _isSquadFull && _isTeamReady ? _handleSaveTeam : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: (_isSquadFull && _isTeamReady)
                          ? AppColors.bannerGradient
                          : null,
                      color: (_isSquadFull && _isTeamReady)
                          ? null
                          : AppColors.glassFillLighter,
                      borderRadius: BorderRadius.circular(16),
                      border: (_isSquadFull && _isTeamReady)
                          ? null
                          : Border.all(color: AppColors.glassBorder),
                      boxShadow: (_isSquadFull && _isTeamReady)
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
                      'Save Team',
                      style: GoogleFonts.quicksand(
                        color: (_isSquadFull && _isTeamReady)
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
