import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Static design-time model for a single row in a team's squad list on the
/// Team Details screen.
class SquadMemberInfo {
  const SquadMemberInfo({required this.name, this.isCaptain = false});

  final String name;
  final bool isCaptain;
}

/// Static design-time model for a "team looking for players" card on the
/// Playground screen, and the richer Team Details screen it opens into. No
/// persistence/network layer — purely for UI presentation.
class PlaygroundTeamInfo {
  const PlaygroundTeamInfo({
    required this.name,
    required this.avatarInitials,
    required this.avatarColor,
    required this.cardGradient,
    required this.sport,
    required this.captainName,
    required this.captainShortName,
    required this.location,
    required this.distanceKm,
    required this.wins,
    required this.playersCount,
    required this.maxPlayers,
    required this.neededCount,
    required this.neededPosition,
    required this.captainWinRate,
    required this.captainTournaments,
    required this.squad,
    required this.playerShareFee,
    required this.totalFee,
  });

  final String name;
  final String avatarInitials;
  final Color avatarColor;
  final Gradient cardGradient;
  final String sport;
  final String captainName;
  final String captainShortName;
  final String location;
  final String distanceKm;
  final int wins;
  final int playersCount;
  final int maxPlayers;
  final int neededCount;
  final String neededPosition;
  final String captainWinRate;
  final int captainTournaments;
  final List<SquadMemberInfo> squad;
  final String playerShareFee;
  final String totalFee;
}

const List<PlaygroundTeamInfo> dummyPlaygroundTeams = [
  PlaygroundTeamInfo(
    name: 'Thunder Titans',
    avatarInitials: 'TT',
    avatarColor: Color(0xFF1F4A3A),
    cardGradient: AppColors.playgroundCricketCardGradient,
    sport: 'Cricket',
    captainName: 'Shravan Prajapati',
    captainShortName: 'Shrvn Prajapati',
    location: 'Hyderabad',
    distanceKm: '4.5 km',
    wins: 12,
    playersCount: 5,
    maxPlayers: 6,
    neededCount: 1,
    neededPosition: 'Bowler',
    captainWinRate: '92%',
    captainTournaments: 18,
    squad: [
      SquadMemberInfo(name: 'Shrvn Prajapati', isCaptain: true),
      SquadMemberInfo(name: 'Amit Kumar'),
      SquadMemberInfo(name: 'Manish K'),
      SquadMemberInfo(name: 'Sumit Nai'),
      SquadMemberInfo(name: 'Mayank S'),
    ],
    playerShareFee: '₹99',
    totalFee: '₹99',
  ),
  PlaygroundTeamInfo(
    name: 'Royal Smashers',
    avatarInitials: 'D',
    avatarColor: Color(0xFF8A4A22),
    cardGradient: AppColors.playgroundFootballCardGradient,
    sport: 'Football',
    captainName: 'Praveen Reddy',
    captainShortName: 'Praveen Reddy',
    location: 'Hyderabad',
    distanceKm: '4.5 km',
    wins: 9,
    playersCount: 5,
    maxPlayers: 6,
    neededCount: 1,
    neededPosition: 'Goalkeeper',
    captainWinRate: '85%',
    captainTournaments: 14,
    squad: [
      SquadMemberInfo(name: 'Praveen Reddy', isCaptain: true),
      SquadMemberInfo(name: 'Karthik Rao'),
      SquadMemberInfo(name: 'Vikram Singh'),
      SquadMemberInfo(name: 'Naveen Kumar'),
      SquadMemberInfo(name: 'Ajay Verma'),
    ],
    playerShareFee: '₹79',
    totalFee: '₹79',
  ),
];
