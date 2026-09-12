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

}

const List<SportCategory> dummySportCategories = [
  SportCategory(label: 'Cricket', icon: Icons.sports_cricket_rounded, id: 1),
  SportCategory(label: 'Football', icon: Icons.sports_soccer_rounded, id: 2),
  SportCategory(label: 'Badminton', icon: Icons.sports_tennis_rounded, id: 5),
  SportCategory(label: 'Kabaddi', icon: Icons.sports_martial_arts_rounded, id: 8),
  SportCategory(label: 'Darts', icon: Icons.track_changes_rounded),
];
