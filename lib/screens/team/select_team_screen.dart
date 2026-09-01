import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/globalefunction/global_functions.dart';
import '../home/providers/home_provider.dart';
import '../payment/payment_method_screen.dart';
import 'create_team_screen.dart';
import 'register_tournament.dart';
import 'widgets/team_card.dart';
import 'widgets/registration_stepper.dart';
import 'widgets/edit_team_dialog.dart';

/// Team picker shown after tapping "Create Team" on a tournament detail
/// screen: lets the user create a new team or select one of their
/// existing teams before confirming.
class SelectTeamScreen extends StatefulWidget {
  final Map<String, dynamic> tournament;

  const SelectTeamScreen({super.key, required this.tournament});

  @override
  State<SelectTeamScreen> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchTeams();
    });
  }

  void _handleDelete(Map<String, dynamic> team) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.authBackgroundBottom,
        title: Text('Delete Team', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete this team?', style: GoogleFonts.quicksand(color: Colors.white70)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.quicksand(color: Colors.white54))),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = Provider.of<HomeProvider>(context, listen: false);
              final success = await provider.deleteTeam(team['id']);
              if (mounted) {
                if (success) {
                  MCP.showMessage(
                    context,
                    "Team deleted successfully.",
                    backgroundColor: Colors.green.shade600,
                    icon: Icons.check_circle_rounded,
                  );
                  if (_selectedIndex >= provider.teamsList.length) {
                    setState(() => _selectedIndex = 0);
                  }
                } else {
                  MCP.showMessage(context, provider.errorMessage ?? "Failed to delete team.");
                }
              }
            },
            child: Text('Delete', style: GoogleFonts.quicksand(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleEdit(Map<String, dynamic> team) {
    showDialog(
      context: context,
      builder: (context) => EditTeamDialog(team: team),
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
                      'Select Your Team',
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
                child: Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isFetchingTeams) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    final teams = provider.teamsList;

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                      children: [
                        _CreateTeamButton(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterNewTeam(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Select Team',
                          style: GoogleFonts.quicksand(
                            color: AppColors.amberAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (teams.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'No teams found.',
                              style: GoogleFonts.quicksand(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          for (int i = 0; i < teams.length; i++)
                            TeamCard(
                              team: teams[i],
                              selected: _selectedIndex == i,
                              onSelect: () =>
                                  setState(() => _selectedIndex = i),
                              onEdit: () => _handleEdit(teams[i]),
                              onDelete: () => _handleDelete(teams[i]),
                            ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    final teams = provider.teamsList;
                    final bool hasTeams = teams.isNotEmpty;
                    return GestureDetector(
                      onTap: !hasTeams ? null : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PaymentMethodScreen(
                              tournament: widget.tournament,
                              team: teams[_selectedIndex],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: hasTeams ? AppColors.bannerGradient : null,
                          color: hasTeams ? null : AppColors.glassFillLighter,
                          borderRadius: BorderRadius.circular(16),
                          border: hasTeams ? null : Border.all(color: AppColors.glassBorder),
                          boxShadow: hasTeams ? [
                            BoxShadow(
                              color: const Color(
                                0xFFFF7A1E,
                              ).withValues(alpha: 0.45),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ] : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Team Ready',
                              style: GoogleFonts.quicksand(
                                color: hasTeams ? Colors.white : Colors.white38,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: hasTeams ? Colors.white : Colors.white38,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateTeamButton extends StatelessWidget {
  const _CreateTeamButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.mintGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: AppColors.mintGreen, size: 19),
            const SizedBox(width: 6),
            Text(
              'Create new team',
              style: GoogleFonts.quicksand(
                color: AppColors.mintGreen,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
