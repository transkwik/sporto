import 'package:flutter/material.dart';

class AchievementBadge {
  const AchievementBadge({
    required this.id,
    required this.label,
    required this.earned,
    required this.icon,
    this.glow = const Color(0xFF3A6A8A),
  });

  final String id;
  final String label;
  final bool earned;
  final IconData icon;
  final Color glow;
}

const List<AchievementBadge> dummyAchievements = [
  AchievementBadge(
    id: 'first-match',
    label: 'First Match',
    earned: true,
    icon: Icons.sports_rounded,
    glow: Color(0xFF2A6B8C),
  ),
  AchievementBadge(
    id: 'first-win',
    label: 'First Win',
    earned: true,
    icon: Icons.military_tech_rounded,
    glow: Color(0xFF8A6A18),
  ),
  AchievementBadge(id: 'champion', label: 'Champion', earned: false, icon: Icons.emoji_events_rounded),
  AchievementBadge(id: 'mvp', label: 'MVP', earned: false, icon: Icons.star_rounded),
  AchievementBadge(id: 'orange-cap', label: 'Orange Cap', earned: false, icon: Icons.workspace_premium_rounded),
  AchievementBadge(id: 'purple-cap', label: 'Purple Cap', earned: false, icon: Icons.workspace_premium_rounded),
  AchievementBadge(id: 'golden-boot', label: 'Golden Boot', earned: false, icon: Icons.sports_soccer_rounded),
  AchievementBadge(id: 'state', label: 'State Champion', earned: false, icon: Icons.flag_rounded),
  AchievementBadge(id: 'national', label: 'National Champion', earned: false, icon: Icons.public_rounded),
  AchievementBadge(id: 'legend', label: 'Legend', earned: false, icon: Icons.auto_awesome_rounded),
];
