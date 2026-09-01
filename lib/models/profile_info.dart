import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Static design-time model for a single stat tile on the profile screen.
class ProfileStat {
  const ProfileStat({required this.icon, required this.iconColor, required this.value, required this.label});

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
}

/// Static design-time model for a profile menu row with optional subtitle.
class ProfileMenuItem {
  const ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
}

/// Static design-time model for a sport + role pill on the profile details page.
class ProfileSportRole {
  const ProfileSportRole({required this.icon, required this.sport, required this.role});

  final IconData icon;
  final String sport;
  final String role;
}

/// Static design-time model for the profile header / details summary.
class ProfileInfo {
  const ProfileInfo({
    required this.name,
    required this.userId,
    required this.spotoId,
    required this.phone,
    required this.location,
    this.verified = true,
  });

  final String name;
  final String userId;
  final String spotoId;
  final String phone;
  final String location;
  final bool verified;
}

const ProfileInfo dummyProfile = ProfileInfo(
  name: 'Arjun Reddy',
  userId: 'SP-04471',
  spotoId: 'SPOTO-HYD-04471',
  phone: '+91 98765XXXXX',
  location: 'Hyderabad, Telangana',
);

const List<(IconData icon, String label)> dummyProfileSports = [
  (Icons.sports_cricket_rounded, 'Cricket'),
  (Icons.sports_soccer_rounded, 'Football'),
  (Icons.sports_tennis_rounded, 'Badminton'),
  (Icons.sports_rounded, 'Kabaddi'),
];

const List<ProfileStat> dummyProfileStats = [
  ProfileStat(icon: Icons.sports_cricket_rounded, iconColor: Colors.white70, value: '12', label: 'Matches'),
  ProfileStat(icon: Icons.emoji_events_rounded, iconColor: AppColors.amberAccent, value: '12', label: 'Wins'),
  ProfileStat(icon: Icons.emoji_events_rounded, iconColor: AppColors.amberAccent, value: '12', label: 'Titles'),
  ProfileStat(icon: Icons.track_changes_rounded, iconColor: Color(0xFFFF7A5C), value: '12', label: 'MVP'),
];

const List<ProfileStat> dummyProfileDetailStats = [
  ProfileStat(icon: Icons.sports_cricket_rounded, iconColor: Colors.white70, value: '34', label: 'MATCHES'),
  ProfileStat(icon: Icons.emoji_events_rounded, iconColor: AppColors.amberAccent, value: '24', label: 'WINS'),
  ProfileStat(icon: Icons.emoji_events_rounded, iconColor: AppColors.amberAccent, value: '3', label: 'TITLES'),
  ProfileStat(icon: Icons.track_changes_rounded, iconColor: Color(0xFFFF7A5C), value: '4', label: 'MVPS'),
];

const List<ProfileSportRole> dummyProfileSportRoles = [
  ProfileSportRole(icon: Icons.sports_cricket_rounded, sport: 'CRICKET', role: 'ALL-ROUNDER'),
  ProfileSportRole(icon: Icons.sports_soccer_rounded, sport: 'FOOTBALL', role: 'FORWARD'),
];

const List<ProfileMenuItem> dummyProfileMainMenu = [
  ProfileMenuItem(
    icon: Icons.star_rounded,
    iconColor: AppColors.amberAccent,
    label: 'My Sports',
    subtitle: '2 sports · roles set',
  ),
  ProfileMenuItem(
    icon: Icons.groups_rounded,
    iconColor: Color(0xFF9B7BFF),
    label: 'My Teams',
    subtitle: '2 teams',
  ),
  ProfileMenuItem(
    icon: Icons.emoji_events_rounded,
    iconColor: AppColors.amberAccent,
    label: 'My Tournaments',
    subtitle: 'Upcoming, live & completed',
  ),
  ProfileMenuItem(
    icon: Icons.favorite_rounded,
    iconColor: Color(0xFFE85A6B),
    label: 'My Sponsorships',
    subtitle: '3 transactions',
  ),
  ProfileMenuItem(
    icon: Icons.account_balance_wallet_rounded,
    iconColor: Color(0xFFE0399E),
    label: 'Wallet & Transactions',
    subtitle: 'Payments, tips, refunds',
  ),
  ProfileMenuItem(
    icon: Icons.military_tech_rounded,
    iconColor: AppColors.amberAccent,
    label: 'Achievements',
    subtitle: '5 of 10 earned',
  ),
  ProfileMenuItem(
    icon: Icons.notifications_rounded,
    iconColor: AppColors.amberAccent,
    label: 'Notifications',
  ),
  ProfileMenuItem(
    icon: Icons.settings_rounded,
    iconColor: Colors.white70,
    label: 'Settings',
  ),
];

const List<ProfileMenuItem> dummyProfileSupportMenu = [
  ProfileMenuItem(icon: Icons.info_outline_rounded, iconColor: Colors.white54, label: 'About Sporto'),
  ProfileMenuItem(icon: Icons.error_outline_rounded, iconColor: Colors.white54, label: 'Terms & Condition'),
  ProfileMenuItem(icon: Icons.privacy_tip_outlined, iconColor: Colors.white54, label: 'Privacy Policy'),
  ProfileMenuItem(icon: Icons.headset_mic_outlined, iconColor: Colors.white54, label: 'Help Center'),
];
