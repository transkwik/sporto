import 'package:flutter/material.dart';

/// Static design-time model for a "player available nearby" card on the
/// Playground screen. No persistence/network layer — purely for UI
/// presentation.
class PlaygroundPlayerInfo {
  const PlaygroundPlayerInfo({
    required this.name,
    required this.avatarInitials,
    required this.avatarColor,
    required this.sport,
    required this.role,
    required this.mvpAwards,
    required this.location,
    required this.distanceKm,
    required this.availableNow,
  });

  final String name;
  final String avatarInitials;
  final Color avatarColor;
  final String sport;
  final String role;
  final int mvpAwards;
  final String location;
  final String distanceKm;
  final bool availableNow;
}

const List<PlaygroundPlayerInfo> dummyPlaygroundPlayers = [
  PlaygroundPlayerInfo(
    name: 'Rahul Sharma',
    avatarInitials: 'RS',
    avatarColor: Color(0xFF3A3D4A),
    sport: 'Cricket',
    role: 'Bowler',
    mvpAwards: 3,
    location: 'Hyderabad',
    distanceKm: '4.5 km',
    availableNow: true,
  ),
  PlaygroundPlayerInfo(
    name: 'Rahul Sharma',
    avatarInitials: 'D',
    avatarColor: Color(0xFF3A3D4A),
    sport: 'Cricket',
    role: 'Striker',
    mvpAwards: 3,
    location: 'Hyderabad',
    distanceKm: '4.5 km',
    availableNow: true,
  ),
];
