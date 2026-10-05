import 'package:flutter/material.dart';

enum CelebrateSupportStatus { open, closed }

class CelebrateFanMessage {
  const CelebrateFanMessage({
    required this.name,
    required this.note,
    required this.amountLabel,
  });

  final String name;
  final String note;
  final String amountLabel;
}

class CelebrateChampionPlayer {
  const CelebrateChampionPlayer({
    required this.name,
    required this.role,
    this.mvpAwards = 3,
    this.awardLabel,
    this.runs = 0,
    this.wickets = 0,
    this.catches = 0,
  });

  final String name;
  final String role;
  final int mvpAwards;
  final String? awardLabel;
  final int runs;
  final int wickets;
  final int catches;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final one = parts.first;
      return one.substring(0, one.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class CelebrateCampaign {
  const CelebrateCampaign({
    required this.id,
    required this.teamName,
    required this.sport,
    required this.sportIcon,
    required this.tournamentTitle,
    required this.venue,
    required this.fans,
    required this.amountLabel,
    required this.status,
    this.badge = 'Champion',
    this.remainingLabel,
    this.championships = 0,
    this.tournamentWins = 0,
    this.mvpAwards = 0,
    this.totalSupportShort = '',
    this.tipsCount = 0,
    this.messages = const [],
    this.players = const [],
    this.placeLabel = 'Champion',
    this.placePrize = '₹5,000',
  });

  final String id;
  final String teamName;
  final String sport;
  final IconData sportIcon;
  final String tournamentTitle;
  final String venue;
  final int fans;
  final String amountLabel;
  final CelebrateSupportStatus status;
  final String badge;
  final String? remainingLabel;
  final int championships;
  final int tournamentWins;
  final int mvpAwards;
  final String totalSupportShort;
  final int tipsCount;
  final List<CelebrateFanMessage> messages;
  final List<CelebrateChampionPlayer> players;
  final String placeLabel;
  final String placePrize;

  bool get isOpen => status == CelebrateSupportStatus.open;
}

class CelebrateTipDraft {
  const CelebrateTipDraft({
    required this.campaign,
    required this.isPlayer,
    required this.amount,
    required this.showName,
    required this.displayName,
    this.player,
    this.message = '',
  });

  final CelebrateCampaign campaign;
  final bool isPlayer;
  final int amount;
  final bool showName;
  final String displayName;
  final CelebrateChampionPlayer? player;
  final String message;

  String get recipientName => player?.name ?? campaign.teamName;
}

const dummyCelebrateSports = [
  (null, 'All'),
  (Icons.sports_cricket_rounded, 'Cricket'),
  (Icons.sports_soccer_rounded, 'Football'),
  (Icons.sports_tennis_rounded, 'Badminton'),
  (Icons.sports_rounded, 'Kabaddi'),
];

const dummyCelebratePlayers = [
  CelebrateChampionPlayer(
    name: 'Rahul Sharma',
    role: 'Bowler',
    awardLabel: 'Player of the Final',
    runs: 78,
    wickets: 0,
    catches: 2,
  ),
  CelebrateChampionPlayer(
    name: 'Arjun Mehta',
    role: 'Fast Bowler',
    awardLabel: 'Best Bowler',
    runs: 12,
    wickets: 4,
    catches: 1,
  ),
  CelebrateChampionPlayer(name: 'Kiran Verma', role: 'All-Rounder', runs: 54, wickets: 2, catches: 1),
  CelebrateChampionPlayer(name: 'Suresh Naik', role: 'Wicketkeeper', runs: 31, wickets: 0, catches: 3),
  CelebrateChampionPlayer(name: 'Vivek Rao', role: 'Batsman', runs: 62, wickets: 0, catches: 0),
];

const dummyCelebrateCampaigns = [
  CelebrateCampaign(
    id: 'cel-zoto',
    teamName: 'Zoto Warrior',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    tournamentTitle: 'SPOTO Random Cricket',
    venue: 'Kompally Turf Arena, Hyderabad',
    fans: 47,
    amountLabel: '₹12,500',
    status: CelebrateSupportStatus.open,
    remainingLabel: '33h 57m remaining',
    championships: 3,
    tournamentWins: 8,
    mvpAwards: 4,
    totalSupportShort: '₹12.5K',
    tipsCount: 52,
    messages: [
      CelebrateFanMessage(name: 'Rahul', note: 'Outstanding performance!', amountLabel: '₹500'),
      CelebrateFanMessage(name: 'Anonymous Fan', note: 'Well deserved!', amountLabel: '₹250'),
      CelebrateFanMessage(name: 'Anonymous Fan', note: 'Well deserved!', amountLabel: '₹1000'),
    ],
    players: dummyCelebratePlayers,
  ),
  CelebrateCampaign(
    id: 'cel-blaze',
    teamName: 'Blaze United',
    sport: 'Football',
    sportIcon: Icons.sports_soccer_rounded,
    tournamentTitle: 'Hyderabad Penalty Cup',
    venue: 'Kompally Turf Arena, Hyderabad',
    fans: 31,
    amountLabel: '₹8,480',
    status: CelebrateSupportStatus.closed,
    championships: 2,
    tournamentWins: 5,
    mvpAwards: 3,
    totalSupportShort: '₹8.5K',
    tipsCount: 28,
    messages: [
      CelebrateFanMessage(name: 'Anonymous Fan', note: 'Well deserved!', amountLabel: '₹400'),
      CelebrateFanMessage(name: 'Kiran', note: 'Great final!', amountLabel: '₹300'),
    ],
    players: dummyCelebratePlayers,
  ),
];
