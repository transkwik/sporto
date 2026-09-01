import 'package:flutter/material.dart';

/// Static design-time model representing a sport quick-filter icon on the
/// home dashboard. No persistence/network layer — purely for UI
/// presentation.
class SportCategory {
  const SportCategory({
    required this.label, 
    required this.icon,
    this.id,
    this.iconUrl,
  });

  final String label;
  final IconData icon;
  final int? id;
  final String? iconUrl;

  factory SportCategory.fromJson(Map<String, dynamic> json) {
    return SportCategory(
      id: json['id'],
      label: json['name'] ?? 'Unknown',
      iconUrl: json['icon_url'],
      icon: _getIconForSport(json['name'] ?? ''),
    );
  }

  static IconData _getIconForSport(String name) {
    switch (name.toLowerCase()) {
      case 'cricket': return Icons.sports_cricket_rounded;
      case 'football': return Icons.sports_soccer_rounded;
      case 'basketball': return Icons.sports_basketball_rounded;
      case 'volleyball': return Icons.sports_volleyball_rounded;
      case 'badminton': return Icons.sports_tennis_rounded;
      case 'tennis': return Icons.sports_tennis_rounded;
      case 'kabaddi': return Icons.sports_martial_arts_rounded;
      case 'hockey': return Icons.sports_hockey_rounded;
      case 'baseball': return Icons.sports_baseball_rounded;
      case 'golf': return Icons.sports_golf_rounded;
      case 'esports': return Icons.sports_esports_rounded;
      default: return Icons.sports_rounded;
    }
  }
}

const List<SportCategory> dummySportCategories = [
  SportCategory(label: 'Cricket', icon: Icons.sports_cricket_rounded, id: 1),
  SportCategory(label: 'Football', icon: Icons.sports_soccer_rounded, id: 2),
  SportCategory(label: 'Badminton', icon: Icons.sports_tennis_rounded, id: 5),
  SportCategory(label: 'Kabaddi', icon: Icons.sports_martial_arts_rounded, id: 8),
  SportCategory(label: 'Darts', icon: Icons.track_changes_rounded),
];
