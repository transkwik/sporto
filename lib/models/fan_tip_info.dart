import 'package:flutter/material.dart';

enum FanTipChannel { viaTeam, individual }

class FanTipShare {
  const FanTipShare({
    required this.name,
    required this.amountLabel,
    required this.initials,
    this.isYou = false,
  });

  final String name;
  final String amountLabel;
  final String initials;
  final bool isYou;
}

class FanTip {
  const FanTip({
    required this.id,
    required this.referenceId,
    required this.playerName,
    required this.teamLabel,
    required this.dateLabel,
    required this.amountLabel,
    required this.channel,
    required this.note,
    required this.tournamentTitle,
    this.tournamentSubtitle = '',
    this.sportIcon = Icons.sports_cricket_rounded,
    this.shares = const [],
  });

  final String id;
  final String referenceId;
  final String playerName;
  final String teamLabel;
  final String dateLabel;
  final String amountLabel;
  final FanTipChannel channel;
  final String note;
  final String tournamentTitle;
  final String tournamentSubtitle;
  final IconData sportIcon;
  final List<FanTipShare> shares;

  bool get isTeamPool => channel == FanTipChannel.viaTeam;

  String get headerSubtitle {
    if (isTeamPool) {
      final fans = shares.isEmpty ? 0 : shares.length;
      return 'Team tip pool · $fans fans';
    }
    return 'Tipped · $teamLabel';
  }
}

const _thunderShares = [
  FanTipShare(name: 'You', amountLabel: '₹500', initials: 'AR', isYou: true),
  FanTipShare(name: 'Rohit Naik', amountLabel: '₹500', initials: 'RN'),
  FanTipShare(name: 'Sandeep Rao', amountLabel: '₹400', initials: 'SR'),
];

const List<FanTip> dummyFanTips = [
  FanTip(
    id: 'tip-rohit',
    referenceId: 'FT-S1001',
    playerName: 'Rohit Naik',
    teamLabel: 'Team Thunder',
    dateLabel: '10 Aug 2026',
    amountLabel: '₹200',
    channel: FanTipChannel.individual,
    note: 'Player of the Match performance',
    tournamentTitle: 'Spoto Kondapur Super Over Cup',
    tournamentSubtitle: 'Winner · Split 6 ways',
  ),
  FanTip(
    id: 'tip-vishal',
    referenceId: 'FT-S1002',
    playerName: 'Vishal Kumar',
    teamLabel: 'Gachibowli Strikers',
    dateLabel: '6 Aug 2026',
    amountLabel: '₹500',
    channel: FanTipChannel.individual,
    note: 'Outstanding bowling spell',
    tournamentTitle: 'Spoto Ameerpet Winter League',
    tournamentSubtitle: 'Match 3',
  ),
  FanTip(
    id: 'tip-sandeep',
    referenceId: 'FT-S1003',
    playerName: 'Sandeep Rao',
    teamLabel: 'Hyd Highlanders',
    dateLabel: '4 Aug 2026',
    amountLabel: '₹150',
    channel: FanTipChannel.individual,
    note: 'Captain’s knock',
    tournamentTitle: 'Spoto Hyderabad Night T20',
    tournamentSubtitle: 'League — Match 2',
  ),
  FanTip(
    id: 'tip-team-thunder',
    referenceId: 'FT-S1001',
    playerName: 'Team Thunder',
    teamLabel: 'Team tip pool · 3 fans',
    dateLabel: '10 Aug 2026',
    amountLabel: '₹1,400',
    channel: FanTipChannel.viaTeam,
    note: '',
    tournamentTitle: 'Spoto Kondapur Super Over Cup',
    shares: _thunderShares,
  ),
  FanTip(
    id: 'tip-warriors',
    referenceId: 'FT-T2002',
    playerName: 'Warriors FC',
    teamLabel: 'Team tip pool · 2 fans',
    dateLabel: '3 Aug 2026',
    amountLabel: '₹300',
    channel: FanTipChannel.viaTeam,
    note: '',
    tournamentTitle: 'Spoto Bengaluru Penalty Kickout Cup',
    tournamentSubtitle: 'Semi Final',
    sportIcon: Icons.sports_soccer_rounded,
    shares: [
      FanTipShare(name: 'You', amountLabel: '₹150', initials: 'AR', isYou: true),
      FanTipShare(name: 'Rohit Naik', amountLabel: '₹150', initials: 'RN'),
    ],
  ),
];
