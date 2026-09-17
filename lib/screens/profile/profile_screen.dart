import 'package:flutter/material.dart';
import '../../models/profile_info.dart';
import '../../routes/app_routes.dart';
import 'profile_details_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'widgets/championship_journey_card.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/profile_sport_chips.dart';
import 'widgets/profile_stats_row.dart';

/// Profile tab: user summary, sport chips, career stats, championship
/// journey progress, main menu tiles, and support links. Tapping the
/// header opens the full Profile Details screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedSport = 0;

  void _openDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileDetailsScreen()),
    );
  }

  void _onMainMenuTap(ProfileMenuItem item) {
    switch (item.label) {
      case 'My Sports':
        Navigator.of(context).pushNamed(AppRoutes.mySports);
      case 'My Teams':
        Navigator.of(context).pushNamed(AppRoutes.myTeams);
      case 'My Tournaments':
        Navigator.of(context).pushNamed(AppRoutes.myTournaments);
      case 'Notifications':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
      case 'Settings':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        ProfileHeader(profile: dummyProfile, onTap: _openDetails),
        const SizedBox(height: 18),
        ProfileSportChips(
          sports: dummyProfileSports,
          selectedIndex: _selectedSport,
          onSelect: (index) => setState(() => _selectedSport = index),
        ),
        const SizedBox(height: 16),
        const ProfileStatsRow(stats: dummyProfileStats),
        const SizedBox(height: 16),
        const ChampionshipJourneyCard(),
        const SizedBox(height: 16),
        for (final item in dummyProfileMainMenu) ...[
          ProfileMenuTile(item: item, onTap: () => _onMainMenuTap(item)),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
        for (final item in dummyProfileSupportMenu) ProfileSupportLink(item: item, onTap: () {}),
      ],
    );
  }
}
