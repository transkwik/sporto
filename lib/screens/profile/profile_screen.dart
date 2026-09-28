import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/profile_info.dart';
import '../../routes/app_routes.dart';
import '../auth/providers/auth_provider.dart';
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

  void _openDetails(ProfileInfo profile) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfileDetailsScreen(profile: profile)),
    );
  }

  Future<void> _onMainMenuTap(ProfileMenuItem item) async {
    switch (item.label) {
      case 'My Sports':
        Navigator.of(context).pushNamed(AppRoutes.mySports);
      case 'My Teams':
        Navigator.of(context).pushNamed(AppRoutes.myTeams);
      case 'My Tournaments':
        Navigator.of(context).pushNamed(AppRoutes.myTournaments);
      case 'Notifications':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
      case 'Settings':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
      case 'Logout':
        final provider = context.read<AuthProvider>();
        
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        
        final success = await provider.logout();
        
        if (!mounted) return;
        Navigator.of(context).pop(); // remove dialog
        
        if (success) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage ?? 'Logout failed')),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userMap =
        authProvider.checkResponse?['user'] as Map<String, dynamic>?;
    final profileMap =
        userMap?['profile'] as Map<String, dynamic>?;

    final String fullName = profileMap?['full_name'] ?? 'Unknown User';
    final String userId = userMap?['id']?.toString() ?? 'N/A';
    final String spotoId =
        profileMap?['id']?.toString() ??
        'N/A'; // Or a custom ID logic if needed
    final String phone = userMap?['mobile_number'] ?? 'N/A';

    final String city = profileMap?['city'] ?? '';
    final String state = profileMap?['state'] ?? '';
    final String location = (city.isNotEmpty && state.isNotEmpty)
        ? '$city, $state'
        : (city.isNotEmpty ? city : state);

    final dynamicProfile = ProfileInfo(
      name: fullName,
      userId: 'SP-$userId',
      spotoId: 'SPOTO-$spotoId',
      phone: phone,
      location: location.isEmpty ? 'Unknown Location' : location,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        ProfileHeader(
          profile: dynamicProfile,
          onTap: () => _openDetails(dynamicProfile),
        ),
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
        for (final item in dummyProfileSupportMenu)
          ProfileSupportLink(item: item, onTap: () {}),
      ],
    );
  }
}
