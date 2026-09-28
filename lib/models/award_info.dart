import 'package:flutter/material.dart';

enum AwardKind { teamSplit, individual }

class AwardSquadShare {
  const AwardSquadShare({
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

class AwardPrize {
  const AwardPrize({
    required this.id,
    required this.sport,
    required this.sportIcon,
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.kind,
    required this.referenceId,
    required this.dateLabel,
    required this.sponsorName,
    required this.sponsorActive,
    required this.sponsorshipId,
    required this.transactionRef,
    this.poolLabel,
    this.teamPoolAmount,
    this.disbursedDate,
    this.squad = const [],
  });

  final String id;
  final String sport;
  final IconData sportIcon;
  final String title;
  final String subtitle;
  final String amountLabel;
  final AwardKind kind;
  final String? poolLabel;
  final String referenceId;
  final String dateLabel;
  final String sponsorName;
  final bool sponsorActive;
  final String sponsorshipId;
  final String transactionRef;
  final String? teamPoolAmount;
  final String? disbursedDate;
  final List<AwardSquadShare> squad;

  bool get isPaid => disbursedDate != null;
}

const dummyAwardsBalance = '₹ 25,000';

const List<(IconData? icon, String label)> dummyAwardSports = [
  (null, 'All'),
  (Icons.sports_cricket_rounded, 'Cricket'),
  (Icons.sports_soccer_rounded, 'Football'),
  (Icons.sports_basketball_rounded, 'Basketball'),
  (Icons.sports_tennis_rounded, 'Badminton'),
  (Icons.sports_rounded, 'Kabaddi'),
];

const _kondapurSquad = [
  AwardSquadShare(name: 'You', amountLabel: '₹1,000', initials: 'AR', isYou: true),
  AwardSquadShare(name: 'Rohit Naik', amountLabel: '₹800', initials: 'RN'),
  AwardSquadShare(name: 'Sandeep Rao', amountLabel: '₹800', initials: 'SR'),
  AwardSquadShare(name: 'Vikram Chowdary', amountLabel: '₹800', initials: 'VC'),
  AwardSquadShare(name: 'Kiran Varma', amountLabel: '₹800', initials: 'KV'),
];

const List<AwardPrize> dummyAwards = [
  AwardPrize(
    id: 'award-kondapur-split',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    title: 'Spoto Kondapur Super Over Cup',
    subtitle: 'Winner · Split 6 ways',
    amountLabel: '₹5,000',
    poolLabel: 'of ₹15,000 pool',
    kind: AwardKind.teamSplit,
    referenceId: 'SP-441207',
    dateLabel: '10 Aug 2026',
    sponsorName: 'Deccan Sports Traders',
    sponsorActive: false,
    sponsorshipId: 'SP-441207',
    transactionRef: 'TXN-88301',
    teamPoolAmount: '₹15,000',
    disbursedDate: 'Aug 9, 2026',
    squad: _kondapurSquad,
  ),
  AwardPrize(
    id: 'award-bengaluru-split',
    sport: 'Football',
    sportIcon: Icons.sports_soccer_rounded,
    title: 'Spoto Bengaluru Penalty Kickout Cup',
    subtitle: 'Runner-Up Bonus · Split 6 ways',
    amountLabel: '₹5,000',
    poolLabel: 'of ₹15,000 pool',
    kind: AwardKind.teamSplit,
    referenceId: 'SP-441208',
    dateLabel: '4 Aug 2026',
    sponsorName: 'Deccan Sports Traders',
    sponsorActive: false,
    sponsorshipId: 'SP-441208',
    transactionRef: 'TXN-88312',
    teamPoolAmount: '₹15,000',
    disbursedDate: 'Aug 3, 2026',
    squad: _kondapurSquad,
  ),
  AwardPrize(
    id: 'award-hyderabad-split',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    title: 'Spoto Hyderabad Night T20',
    subtitle: 'Winner · Split 5 ways',
    amountLabel: '₹8,000',
    poolLabel: 'of ₹40,000 pool',
    kind: AwardKind.teamSplit,
    referenceId: 'SP-441210',
    dateLabel: '22 Jul 2026',
    sponsorName: 'Hyderabad Sport Co.',
    sponsorActive: false,
    sponsorshipId: 'SP-441210',
    transactionRef: 'TXN-88290',
    teamPoolAmount: '₹40,000',
    disbursedDate: 'Jul 21, 2026',
    squad: [
      AwardSquadShare(name: 'You', amountLabel: '₹8,000', initials: 'AR', isYou: true),
      AwardSquadShare(name: 'Rohit Naik', amountLabel: '₹8,000', initials: 'RN'),
      AwardSquadShare(name: 'Sandeep Rao', amountLabel: '₹8,000', initials: 'SR'),
      AwardSquadShare(name: 'Vikram Chowdary', amountLabel: '₹8,000', initials: 'VC'),
      AwardSquadShare(name: 'Kiran Varma', amountLabel: '₹8,000', initials: 'KV'),
    ],
  ),
  AwardPrize(
    id: 'award-ace-split',
    sport: 'Badminton',
    sportIcon: Icons.sports_tennis_rounded,
    title: 'Spoto Ace Smashers Open',
    subtitle: 'Winner · Split 2 ways',
    amountLabel: '₹4,000',
    poolLabel: 'of ₹8,000 pool',
    kind: AwardKind.teamSplit,
    referenceId: 'SP-441211',
    dateLabel: '18 Jul 2026',
    sponsorName: 'Ace Arena Partners',
    sponsorActive: false,
    sponsorshipId: 'SP-441211',
    transactionRef: 'TXN-88281',
    teamPoolAmount: '₹8,000',
    disbursedDate: 'Jul 17, 2026',
    squad: [
      AwardSquadShare(name: 'You', amountLabel: '₹4,000', initials: 'AR', isYou: true),
      AwardSquadShare(name: 'Kiran Varma', amountLabel: '₹4,000', initials: 'KV'),
    ],
  ),
  AwardPrize(
    id: 'award-mvp-vijayawada',
    sport: 'Basketball',
    sportIcon: Icons.sports_basketball_rounded,
    title: 'Best Athlete (MVP)',
    subtitle: 'Vijayawada 3v3 Basketball Rapid Fire',
    amountLabel: '₹1,000',
    kind: AwardKind.individual,
    referenceId: 'SP-441207',
    dateLabel: '10 Aug 2026',
    sponsorName: 'Vijayawada SportsMart',
    sponsorActive: true,
    sponsorshipId: 'SP-338821',
    transactionRef: 'TXN-88301',
  ),
  AwardPrize(
    id: 'award-best-batsman',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    title: 'Best Batsman of the Tournament',
    subtitle: 'Spoto Kondapur Super Over Cup',
    amountLabel: '₹2,000',
    kind: AwardKind.individual,
    referenceId: 'SP-441220',
    dateLabel: '10 Aug 2026',
    sponsorName: 'Deccan Sports Traders',
    sponsorActive: false,
    sponsorshipId: 'SP-441220',
    transactionRef: 'TXN-88320',
    disbursedDate: 'Aug 9, 2026',
  ),
  AwardPrize(
    id: 'award-kondapur-mom',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    title: 'Man of the Match',
    subtitle: 'Final · Spoto Kondapur Super Over Cup',
    amountLabel: '₹500',
    kind: AwardKind.individual,
    referenceId: 'SP-441221',
    dateLabel: '9 Aug 2026',
    sponsorName: 'Deccan Sports Traders',
    sponsorActive: false,
    sponsorshipId: 'SP-441221',
    transactionRef: 'TXN-88321',
    disbursedDate: 'Aug 9, 2026',
  ),
  AwardPrize(
    id: 'award-ameerpet-mom',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    title: 'Man of the Match',
    subtitle: 'Match 3 · Ameerpet Winter League',
    amountLabel: '₹300',
    kind: AwardKind.individual,
    referenceId: 'SP-338830',
    dateLabel: '2 Aug 2026',
    sponsorName: 'Ameerpet Sports Hub',
    sponsorActive: true,
    sponsorshipId: 'SP-338830',
    transactionRef: 'TXN-88330',
  ),
];
