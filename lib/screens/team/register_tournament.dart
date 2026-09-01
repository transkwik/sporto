import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/globalefunction/global_functions.dart';
import '../home/providers/home_provider.dart';
import '../onboarding/widgets/profile_photo_picker.dart';
import '../onboarding/widgets/profile_text_field.dart';

import 'widgets/registration_stepper.dart';

/// Simplified form for building out a team: name and logo only.
class RegisterNewTeam extends StatefulWidget {
  const RegisterNewTeam({super.key});

  @override
  State<RegisterNewTeam> createState() => _RegisterNewTeamState();
}

class _RegisterNewTeamState extends State<RegisterNewTeam> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  bool _hasPhoto = false;
  bool _isUploadingPhoto = false;
  String? _uploadedPhotoUrl;
  String? _uploadedPhotoPath;

  @override
  void initState() {
    super.initState();
    _teamNameController.addListener(_handleInputChanged);
    _cityController.addListener(_handleInputChanged);
  }

  void _handleInputChanged() => setState(() {});

  bool get _isTeamReady => 
      _teamNameController.text.trim().isNotEmpty && 
      _cityController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _teamNameController.removeListener(_handleInputChanged);
    _teamNameController.dispose();
    _cityController.removeListener(_handleInputChanged);
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      setState(() {
        _isUploadingPhoto = true;
      });

      try {
        final response = await UserApis().uploadProfileImage(pickedFile.path);

        if (response != null && response['success'] == true) {
          setState(() {
            _uploadedPhotoUrl = response['data']['url'];
            _uploadedPhotoPath = response['data']['path'];
            _hasPhoto = true;
            _isUploadingPhoto = false;
          });
        } else {
          setState(() {
            _isUploadingPhoto = false;
          });
          if (mounted) {
            MCP.showMessage(
              context,
              response?['message'] ?? 'Failed to upload image',
            );
          }
        }
      } catch (e) {
        setState(() {
          _isUploadingPhoto = false;
        });
        if (mounted) {
          MCP.showMessage(context, 'Error: $e');
        }
      }
    }
  }

  Future<void> _handleSaveTeam() async {
    if (!_isTeamReady) return;

    final provider = Provider.of<HomeProvider>(context, listen: false);

    // Construct required payload
    final params = {
      "sport_id": 1, // Defaulting to 1 as requested in mock
      "team_name": _teamNameController.text.trim(),
      "city": _cityController.text.trim(),
      "visibility": 1, // Static value 1 as requested
      if (_uploadedPhotoPath != null) "team_logo_path": _uploadedPhotoPath,
    };

    final success = await provider.createTeam(params);

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        MCP.showMessage(
          context,
          "Team created successfully!",
          backgroundColor: Colors.green.shade600,
          icon: Icons.check_circle_rounded,
        );
      } else {
        MCP.showMessage(
          context,
          provider.errorMessage ?? "Failed to create team.",
        );
      }
    }
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
                      'Register Tournament',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: RegistrationStepper(currentStep: 2),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  children: [
                    ProfileTextField(
                      label: 'Team Name',
                      hint: 'Enter your team name',
                      controller: _teamNameController,
                    ),
                    const SizedBox(height: 20),
                    ProfileTextField(
                      label: 'City',
                      hint: 'Enter your city',
                      controller: _cityController,
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
                      hasPhoto: _hasPhoto,
                      photoUrl: _uploadedPhotoUrl,
                      isUploading: _isUploadingPhoto,
                      onUpload: _pickAndUploadImage,
                      onClear: () => setState(() {
                        _hasPhoto = false;
                        _uploadedPhotoUrl = null;
                        _uploadedPhotoPath = null;
                      }),
                    ),
                  ],
                ),
              ),
              Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  final isLoading = provider.isCreatingTeam;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: GestureDetector(
                      onTap: _isTeamReady && !isLoading
                          ? _handleSaveTeam
                          : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: _isTeamReady && !isLoading
                              ? AppColors.bannerGradient
                              : null,
                          color: _isTeamReady && !isLoading
                              ? null
                              : AppColors.glassFillLighter,
                          borderRadius: BorderRadius.circular(16),
                          border: _isTeamReady && !isLoading
                              ? null
                              : Border.all(color: AppColors.glassBorder),
                          boxShadow: _isTeamReady && !isLoading
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
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save Team',
                                style: GoogleFonts.quicksand(
                                  color: _isTeamReady
                                      ? Colors.white
                                      : Colors.white38,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
