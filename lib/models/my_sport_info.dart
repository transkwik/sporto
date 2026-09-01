import 'package:flutter/material.dart';

/// One sport the user can follow on the My Sports preferences screen.
class MySportInfo {
  const MySportInfo({
    required this.id,
    required this.name,
    required this.icon,
    this.roleLabel,
    this.nearbyTournaments = 0,
    this.selected = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final String? roleLabel;
  final int nearbyTournaments;
  final bool selected;

  MySportInfo copyWith({
    String? roleLabel,
    bool? selected,
  }) {
    return MySportInfo(
      id: id,
      name: name,
      icon: icon,
      roleLabel: roleLabel ?? this.roleLabel,
      nearbyTournaments: nearbyTournaments,
      selected: selected ?? this.selected,
    );
  }
}

const List<MySportInfo> dummyMySports = [
  MySportInfo(
    id: 'cricket',
    name: 'Cricket',
    icon: Icons.sports_cricket_rounded,
    roleLabel: 'Captain: Shravan Prajapati',
    nearbyTournaments: 4,
    selected: true,
  ),
  MySportInfo(
    id: 'football',
    name: 'Football',
    icon: Icons.sports_soccer_rounded,
    roleLabel: 'Role: Forward',
    nearbyTournaments: 3,
    selected: true,
  ),
  MySportInfo(
    id: 'volleyball',
    name: 'Volleyball',
    icon: Icons.sports_volleyball_rounded,
    nearbyTournaments: 2,
  ),
  MySportInfo(
    id: 'basketball',
    name: 'Basketball',
    icon: Icons.sports_basketball_rounded,
    nearbyTournaments: 3,
  ),
  MySportInfo(
    id: 'athletics',
    name: 'Athletics',
    icon: Icons.directions_run_rounded,
    nearbyTournaments: 5,
  ),
];
