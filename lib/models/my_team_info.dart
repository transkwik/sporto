import 'package:flutter/material.dart';

/// Why a team still needs work on the My Teams list.
enum MyTeamIssue { none, captainMissing, missingPlayers }

/// One of the user's teams on Profile → My Teams.
class MyTeamInfo {
  const MyTeamInfo({
    required this.id,
    required this.name,
    required this.sport,
    required this.avatarInitials,
    required this.avatarColor,
    required this.captainName,
    required this.wins,
    required this.titles,
    required this.playersCount,
    required this.maxPlayers,
    required this.tournamentsPlayed,
    this.issue = MyTeamIssue.none,
    this.highlighted = false,
  });

  final String id;
  final String name;
  final String sport;
  final String avatarInitials;
  final Color avatarColor;
  final String captainName;
  final int wins;
  final int titles;
  final int playersCount;
  final int maxPlayers;
  final int tournamentsPlayed;
  final MyTeamIssue issue;
  final bool highlighted;

  bool get isComplete => issue == MyTeamIssue.none;

  String get warningLabel {
    switch (issue) {
      case MyTeamIssue.captainMissing:
        return 'Captain Missing';
      case MyTeamIssue.missingPlayers:
        final missing = maxPlayers - playersCount;
        return missing <= 1 ? 'Missing 1 Player' : 'Missing $missing Players';
      case MyTeamIssue.none:
        return '';
    }
  }
}

const List<MyTeamInfo> dummyMyTeams = [
  MyTeamInfo(
    id: 'zoto-warrior',
    name: 'Zoto Warrior',
    sport: 'Cricket',
    avatarInitials: 'ZW',
    avatarColor: Color(0xFF5C3A2E),
    captainName: 'Shravan Prajapati',
    wins: 18,
    titles: 3,
    playersCount: 5,
    maxPlayers: 5,
    tournamentsPlayed: 12,
    highlighted: true,
  ),
  MyTeamInfo(
    id: 'thunder-titans',
    name: 'Thunder Titans',
    sport: 'Cricket',
    avatarInitials: 'TT',
    avatarColor: Color(0xFF2E3340),
    captainName: 'Shravan Prajapati',
    wins: 18,
    titles: 3,
    playersCount: 5,
    maxPlayers: 5,
    tournamentsPlayed: 12,
  ),
  MyTeamInfo(
    id: 'royal-smashers',
    name: 'Royal Smashers',
    sport: 'Cricket',
    avatarInitials: 'RS',
    avatarColor: Color(0xFF3A3530),
    captainName: '-',
    wins: 0,
    titles: 0,
    playersCount: 4,
    maxPlayers: 5,
    tournamentsPlayed: 12,
    issue: MyTeamIssue.captainMissing,
  ),
  MyTeamInfo(
    id: 'delhi-warriors',
    name: 'Delhi Warriors',
    sport: 'Cricket',
    avatarInitials: 'DW',
    avatarColor: Color(0xFF2E3340),
    captainName: 'Shravan Prajapati',
    wins: 0,
    titles: 0,
    playersCount: 4,
    maxPlayers: 5,
    tournamentsPlayed: 12,
    issue: MyTeamIssue.missingPlayers,
  ),
];
