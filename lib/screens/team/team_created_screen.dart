import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_player_info.dart';
import 'widgets/squad_member_status_card.dart';
import 'widgets/team_created_success_card.dart';

/// Full-page celebration shown right after a new team is saved: a success
/// card with the squad's membership validity, and a list of every player
/// added along with their invite status.
class TeamCreatedScreen extends StatelessWidget {
  const TeamCreatedScreen({
    super.key,
    required this.players,
    this.validUntilLabel = '31 Dec 2025',
    this.daysRemaining = 30,
  });

  final List<TeamPlayerInfo> players;
  final String validUntilLabel;
  final int daysRemaining;

  @override
  Widget build(BuildContext context) {
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
                    GlassBackButton(onTap: () => Navigator.of(context).popUntil((route) => route.isFirst)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  children: [
                    TeamCreatedSuccessCard(validUntilLabel: validUntilLabel, daysRemaining: daysRemaining),
                    const SizedBox(height: 26),
                    const Text(
                      'Your Squads',
                      style: TextStyle(color: AppColors.mintGreen, fontSize: 15.5, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    SquadMemberStatusCard(players: players),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
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
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
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
