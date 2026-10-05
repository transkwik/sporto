import 'package:flutter/material.dart';

class SponsorPrizeCategory {
  const SponsorPrizeCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.target,
    required this.sponsored,
  });

  final String id;
  final String label;
  final IconData icon;
  final int target;
  final int sponsored;

  int get remaining => (target - sponsored).clamp(0, target);
  double get fundedRatio => target == 0 ? 0 : (sponsored / target).clamp(0, 1);
}

class SponsorTournament {
  const SponsorTournament({
    required this.id,
    required this.title,
    required this.sport,
    required this.sportIcon,
    required this.city,
    required this.dateLabel,
    required this.teams,
    required this.prizePool,
    required this.prizePoolValue,
    required this.raised,
    required this.sponsors,
    this.categories = dummyCricketPrizeCategories,
  });

  final String id;
  final String title;
  final String sport;
  final IconData sportIcon;
  final String city;
  final String dateLabel;
  final int teams;
  final String prizePool;
  final int prizePoolValue;
  final int raised;
  final int sponsors;
  final List<SponsorPrizeCategory> categories;

  int get remaining => (prizePoolValue - raised).clamp(0, prizePoolValue);
  double get fundedRatio => prizePoolValue == 0 ? 0 : (raised / prizePoolValue).clamp(0, 1);
  int get fundedPercent => (fundedRatio * 100).round();
}

enum SponsorIdentityKind { name, profile, brand, anonymous }

class SponsorCheckout {
  SponsorCheckout({required this.tournament});

  final SponsorTournament tournament;
  final List<SponsorPrizeCategory> selected = [];
  SponsorIdentityKind identity = SponsorIdentityKind.name;
  String sponsorName = 'Zoto';

  int get total => selected.fold(0, (sum, item) => sum + item.remaining);

  void upsert(SponsorPrizeCategory category) {
    selected.removeWhere((item) => item.id == category.id);
    selected.add(category);
  }

  void remove(String id) {
    selected.removeWhere((item) => item.id == id);
  }

  SponsorReceipt toReceipt({String? dateLabel}) {
    return SponsorReceipt.fromCheckout(this, dateLabel: dateLabel);
  }
}

enum SponsorshipRecordStatus { active, completed, refunded }

class SponsorCategoryLine {
  const SponsorCategoryLine({
    required this.label,
    required this.icon,
    required this.amount,
  });

  final String label;
  final IconData icon;
  final int amount;
}

class SponsorReceipt {
  const SponsorReceipt({
    required this.id,
    required this.tournament,
    required this.categories,
    required this.total,
    required this.sponsorName,
    required this.dateLabel,
    this.status = SponsorshipRecordStatus.active,
    this.listDate = '20 Sep 2026',
    this.tournamentDate = '24 Aug 2026',
    this.sponsorType = 'Brand / Company',
    this.listTitle,
    this.lines,
    this.tournamentCancelled = false,
    this.refundMessage,
    this.refundDate,
  });

  final String id;
  final SponsorTournament tournament;
  final List<SponsorPrizeCategory> categories;
  final int total;
  final String sponsorName;
  final String dateLabel;
  final SponsorshipRecordStatus status;
  final String listDate;
  final String tournamentDate;
  final String sponsorType;
  final String? listTitle;
  final List<SponsorCategoryLine>? lines;
  final bool tournamentCancelled;
  final String? refundMessage;
  final String? refundDate;

  String get cardTitle => listTitle ?? tournament.title;

  List<SponsorCategoryLine> get displayLines {
    if (lines != null && lines!.isNotEmpty) return lines!;
    return [
      for (final category in categories)
        SponsorCategoryLine(label: category.label, icon: category.icon, amount: category.remaining),
    ];
  }

  factory SponsorReceipt.fromCheckout(SponsorCheckout checkout, {String? dateLabel}) {
    final seed = checkout.total + checkout.tournament.id.hashCode.abs();
    return SponsorReceipt(
      id: 'SPT-SP-${885196 + (seed % 8000)}',
      tournament: checkout.tournament,
      categories: List<SponsorPrizeCategory>.from(checkout.selected),
      total: checkout.total,
      sponsorName: checkout.sponsorName,
      dateLabel: dateLabel ?? '26 Sep 2026',
      status: SponsorshipRecordStatus.active,
      lines: [
        for (final category in checkout.selected)
          SponsorCategoryLine(label: category.label, icon: category.icon, amount: category.remaining),
      ],
    );
  }
}

const dummySponsorSports = [
  (null, 'All'),
  (Icons.sports_cricket_rounded, 'Cricket'),
  (Icons.sports_soccer_rounded, 'Football'),
  (Icons.sports_tennis_rounded, 'Badminton'),
  (Icons.sports_rounded, 'Kabaddi'),
];

const dummyCricketPrizeCategories = [
  SponsorPrizeCategory(
    id: 'winner',
    label: 'Winner',
    icon: Icons.emoji_events_rounded,
    target: 50000,
    sponsored: 35000,
  ),
  SponsorPrizeCategory(
    id: 'runner-up',
    label: 'Runner-Up',
    icon: Icons.military_tech_rounded,
    target: 25000,
    sponsored: 15000,
  ),
  SponsorPrizeCategory(
    id: 'semi',
    label: 'Semi-Finalists',
    icon: Icons.emoji_events_outlined,
    target: 10000,
    sponsored: 5000,
  ),
  SponsorPrizeCategory(
    id: 'quarter',
    label: 'Quarter-Finalists',
    icon: Icons.workspace_premium_outlined,
    target: 5000,
    sponsored: 2500,
  ),
  SponsorPrizeCategory(
    id: 'batsman',
    label: 'Best Batsman',
    icon: Icons.sports_cricket_rounded,
    target: 5000,
    sponsored: 3000,
  ),
  SponsorPrizeCategory(
    id: 'bowler',
    label: 'Best Bowler',
    icon: Icons.sports_baseball_rounded,
    target: 5000,
    sponsored: 2000,
  ),
];

const dummyFootballPrizeCategories = [
  SponsorPrizeCategory(
    id: 'winner',
    label: 'Winner',
    icon: Icons.emoji_events_rounded,
    target: 40000,
    sponsored: 18000,
  ),
  SponsorPrizeCategory(
    id: 'runner-up',
    label: 'Runner-Up',
    icon: Icons.military_tech_rounded,
    target: 20000,
    sponsored: 7000,
  ),
  SponsorPrizeCategory(
    id: 'semi',
    label: 'Semi-Finalists',
    icon: Icons.emoji_events_outlined,
    target: 8000,
    sponsored: 3000,
  ),
  SponsorPrizeCategory(
    id: 'scorer',
    label: 'Top Scorer',
    icon: Icons.sports_soccer_rounded,
    target: 7000,
    sponsored: 2000,
  ),
];

const dummyBadmintonPrizeCategories = [
  SponsorPrizeCategory(
    id: 'winner',
    label: 'Winner',
    icon: Icons.emoji_events_rounded,
    target: 20000,
    sponsored: 10000,
  ),
  SponsorPrizeCategory(
    id: 'runner-up',
    label: 'Runner-Up',
    icon: Icons.military_tech_rounded,
    target: 12000,
    sponsored: 5000,
  ),
  SponsorPrizeCategory(
    id: 'player',
    label: 'Best Player',
    icon: Icons.sports_tennis_rounded,
    target: 8000,
    sponsored: 3000,
  ),
];

const dummySponsorTournaments = [
  SponsorTournament(
    id: 'spn-1',
    title: 'Spoto Super Over Championship',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    city: 'Hyderabad',
    dateLabel: '24 Aug 2026',
    teams: 64,
    prizePool: '₹1,00,000',
    prizePoolValue: 100000,
    raised: 62500,
    sponsors: 27,
  ),
  SponsorTournament(
    id: 'spn-2',
    title: 'Spoto Super Over Championship',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    city: 'Hyderabad',
    dateLabel: '24 Aug 2026',
    teams: 64,
    prizePool: '₹1,00,000',
    prizePoolValue: 100000,
    raised: 62500,
    sponsors: 27,
  ),
  SponsorTournament(
    id: 'spn-3',
    title: 'Spoto Super Over Championship',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    city: 'Hyderabad',
    dateLabel: '24 Aug 2026',
    teams: 64,
    prizePool: '₹1,00,000',
    prizePoolValue: 100000,
    raised: 62500,
    sponsors: 27,
  ),
  SponsorTournament(
    id: 'spn-4',
    title: 'Hyderabad Penalty Cup',
    sport: 'Football',
    sportIcon: Icons.sports_soccer_rounded,
    city: 'Hyderabad',
    dateLabel: '12 Sep 2026',
    teams: 32,
    prizePool: '₹75,000',
    prizePoolValue: 75000,
    raised: 30000,
    sponsors: 11,
    categories: dummyFootballPrizeCategories,
  ),
  SponsorTournament(
    id: 'spn-5',
    title: 'Spoto Smash Open',
    sport: 'Badminton',
    sportIcon: Icons.sports_tennis_rounded,
    city: 'Secunderabad',
    dateLabel: '5 Sep 2026',
    teams: 24,
    prizePool: '₹40,000',
    prizePoolValue: 40000,
    raised: 18000,
    sponsors: 8,
    categories: dummyBadmintonPrizeCategories,
  ),
];

const dummyHoopsTournament = SponsorTournament(
  id: 'spn-hoops',
  title: 'Spoto Super Over Championship',
  sport: 'Cricket',
  sportIcon: Icons.sports_cricket_rounded,
  city: 'Hyderabad',
  dateLabel: '24 Aug 2026',
  teams: 64,
  prizePool: '₹1,00,000',
  prizePoolValue: 100000,
  raised: 62500,
  sponsors: 27,
);

const _winnerLine = SponsorCategoryLine(
  label: 'Winner',
  icon: Icons.emoji_events_rounded,
  amount: 4000,
);
const _quarterLine = SponsorCategoryLine(
  label: 'Quarter-Finalists',
  icon: Icons.workspace_premium_outlined,
  amount: 2000,
);
const _bowlerLine = SponsorCategoryLine(
  label: 'Best Bowler',
  icon: Icons.sports_baseball_rounded,
  amount: 3000,
);
const _batsmanLine = SponsorCategoryLine(
  label: 'Best Batsman',
  icon: Icons.sports_cricket_rounded,
  amount: 2000,
);
const _potLine = SponsorCategoryLine(
  label: 'Player of the Tournament',
  icon: Icons.star_rounded,
  amount: 2000,
);

const dummySponsorHistoryStats = (
  totalLabel: '₹ 17,500',
  tournamentsSponsored: 5,
  categoriesSupported: 8,
  refundedLabel: '₹2,000',
);

final dummySponsorReceipts = [
  SponsorReceipt(
    id: 'SPT-SP-902744',
    tournament: dummyHoopsTournament,
    categories: const [],
    total: 6000,
    sponsorName: 'Zoto',
    dateLabel: '26 Sep 2026',
    status: SponsorshipRecordStatus.active,
    listTitle: 'Spoto Hoops League Finals',
    lines: [_winnerLine, _quarterLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-885196',
    tournament: dummySponsorTournaments.first,
    categories: const [],
    total: 5000,
    sponsorName: 'Kondapur Sports Bar',
    dateLabel: '26 Sep 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Spoto Hoops League Finals',
    lines: [_bowlerLine, _batsmanLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-885201',
    tournament: dummySponsorTournaments.first,
    categories: const [],
    total: 5000,
    sponsorName: 'Kondapur Sports Bar',
    dateLabel: '26 Sep 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Spoto Hoops League Finals',
    lines: [_bowlerLine, _batsmanLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-885202',
    tournament: dummySponsorTournaments[3],
    categories: const [],
    total: 5000,
    sponsorName: 'Hyderabad Sport Co.',
    dateLabel: '12 Sep 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Hyderabad Penalty Cup',
    listDate: '12 Sep 2026',
    tournamentDate: '12 Sep 2026',
    lines: [_winnerLine, _quarterLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-330871',
    tournament: dummySponsorTournaments.first,
    categories: const [],
    total: 2000,
    sponsorName: 'Kondapur Sports Bar',
    dateLabel: '26 Sep 2026',
    status: SponsorshipRecordStatus.refunded,
    listTitle: 'Spoto Hoops League Finals',
    lines: [_potLine],
    tournamentCancelled: true,
    refundMessage: 'Tournament cancelled due to low registrations',
    refundDate: '28 Aug 2026',
  ),
  SponsorReceipt(
    id: 'SPT-SP-441210',
    tournament: dummySponsorTournaments[4],
    categories: const [],
    total: 1800,
    sponsorName: 'Ace Arena Partners',
    dateLabel: '18 Sep 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Spoto Smash Open',
    listDate: '18 Sep 2026',
    tournamentDate: '5 Sep 2026',
    lines: [_batsmanLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-441211',
    tournament: dummySponsorTournaments.first,
    categories: const [],
    total: 3500,
    sponsorName: 'Deccan Sports Traders',
    dateLabel: '10 Sep 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Spoto Super Over Championship',
    listDate: '10 Sep 2026',
    lines: [_winnerLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-441212',
    tournament: dummySponsorTournaments[3],
    categories: const [],
    total: 2200,
    sponsorName: 'Zoto',
    dateLabel: '8 Sep 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Hyderabad Penalty Cup',
    listDate: '8 Sep 2026',
    tournamentDate: '12 Sep 2026',
    lines: [_quarterLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-441213',
    tournament: dummySponsorTournaments.first,
    categories: const [],
    total: 4000,
    sponsorName: 'Zoto',
    dateLabel: '2 Sep 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Spoto Super Over Championship',
    listDate: '2 Sep 2026',
    lines: [_winnerLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-441214',
    tournament: dummySponsorTournaments[4],
    categories: const [],
    total: 1500,
    sponsorName: 'Ameerpet Sports Hub',
    dateLabel: '28 Aug 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Spoto Smash Open',
    listDate: '28 Aug 2026',
    tournamentDate: '5 Sep 2026',
    lines: [_potLine],
  ),
  SponsorReceipt(
    id: 'SPT-SP-441215',
    tournament: dummySponsorTournaments.first,
    categories: const [],
    total: 2500,
    sponsorName: 'Deccan Sports Traders',
    dateLabel: '20 Aug 2026',
    status: SponsorshipRecordStatus.completed,
    listTitle: 'Spoto Super Over Championship',
    listDate: '20 Aug 2026',
    lines: [_bowlerLine],
  ),
];
