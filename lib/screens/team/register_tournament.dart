import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../onboarding/widgets/profile_text_field.dart';
import 'create_team_screen.dart';
import 'widgets/registration_stepper.dart';

/// Step 2 of tournament registration: name the team, then continue into
/// the full Create New Team (players) screen. Team API stays on Save Team.
class RegisterNewTeam extends StatefulWidget {
  const RegisterNewTeam({
    super.key,
    this.tournament,
    this.maxPlayers = 5,
  });

  final Map<String, dynamic>? tournament;
  final int maxPlayers;

  @override
  State<RegisterNewTeam> createState() => _RegisterNewTeamState();
}

class _RegisterNewTeamState extends State<RegisterNewTeam> {
  final TextEditingController _teamNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _teamNameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  void _continueToCreateTeam() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateTeamScreen(
          initialTeamName: _teamNameController.text.trim(),
          maxPlayers: widget.maxPlayers,
          tournament: widget.tournament,
        ),
      ),
    );
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
                padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: RegistrationStepper(currentStep: 2),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                  children: [
                    Text(
                      'Create Your Team',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 22),
                    ProfileTextField(
                      label: 'Team Name',
                      hint: 'Enter your team name',
                      controller: _teamNameController,
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: _continueToCreateTeam,
                      child: Container(
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: AppColors.bannerGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF7A1E).withValues(alpha: 0.45),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create Team',
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
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
