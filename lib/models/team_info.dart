import 'package:flutter/material.dart';

/// Static design-time model for a single team row on the "Select Your
/// Team" screen. No persistence/network layer — purely for UI
/// presentation.
class TeamInfo {
  const TeamInfo({
    required this.name,
    required this.avatarInitials,
    required this.avatarColor,
    required this.captainName,
    required this.playersCount,
    required this.maxPlayers,
    required this.tournamentsPlayed,
    required this.updatedLabel,
  });

  final String name;
  final String avatarInitials;
  final Color avatarColor;
  final String captainName;
  final int playersCount;
  final int maxPlayers;
  final int tournamentsPlayed;
  final String updatedLabel;
}

const List<TeamInfo> dummyTeams = [
  TeamInfo(
    name: 'Zoto Warrior',
    avatarInitials: 'ZW',
    avatarColor: Color(0xFFFF4D30),
    captainName: 'Shravan Prajapati',
    playersCount: 5,
    maxPlayers: 5,
    tournamentsPlayed: 12,
    updatedLabel: '2 hours ago',
  ),
  TeamInfo(
    name: 'Thunder Titans',
    avatarInitials: 'TT',
    avatarColor: Color(0xFF3A3D4A),
    captainName: 'Shravan Prajapati',
    playersCount: 4,
    maxPlayers: 5,
    tournamentsPlayed: 12,
    updatedLabel: '2 hours ago',
  ),
];
