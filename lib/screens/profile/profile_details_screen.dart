import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/profile_info.dart';
import '../../routes/app_routes.dart';
import 'widgets/championship_journey_card.dart';
import 'widgets/profile_detail_stats_row.dart';
import 'widgets/profile_id_card.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/profile_role_chips.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

/// Full-screen profile details: Sports ID card, career stats, sport roles,
/// championship journey, and the main account menu.
class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key, this.profile = dummyProfile});

  final ProfileInfo profile;

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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Profile',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.glassFillLighter,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: const Icon(Icons.settings_rounded, color: Colors.white70, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: [
                    ProfileIdCard(profile: profile),
                    const SizedBox(height: 14),
                    const ProfileDetailStatsRow(stats: dummyProfileDetailStats),
                    const SizedBox(height: 14),
                    const ProfileRoleChips(roles: dummyProfileSportRoles),
                    const SizedBox(height: 20),
                    ChampionshipJourneyCard(compact: false, onView: () {}),
                    const SizedBox(height: 16),
                    for (final item in dummyProfileMainMenu) ...[
                      ProfileMenuTile(
                        item: item,
                        onTap: () {
                          switch (item.label) {
                            case 'My Sports':
                              Navigator.of(context).pushNamed(AppRoutes.mySports);
                            case 'My Teams':
                              Navigator.of(context).pushNamed(AppRoutes.myTeams);
                            case 'My Tournaments':
                              Navigator.of(context).pushNamed(AppRoutes.myTournaments);
                            case 'Notifications':
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const NotificationsScreen(),
                                ),
                              );
                            case 'Settings':
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SettingsScreen()),
                              );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
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
