import 'package:flutter/material.dart';

class TeamUpTournament {
  const TeamUpTournament({
    required this.id,
    required this.sport,
    required this.sportIcon,
    required this.title,
    required this.dateLabel,
    required this.venue,
    required this.entryFee,
    required this.teamSize,
    required this.formatLine,
    required this.regClosesLabel,
    required this.registered,
    required this.capacity,
    required this.prizePool,
    required this.closingDays,
    required this.distanceKm,
    this.teamsGrid = '8 X 5',
  });

  final String id;
  final String sport;
  final IconData sportIcon;
  final String title;
  final String dateLabel;
  final String venue;
  final int entryFee;
  final int teamSize;
  final String formatLine;
  final String regClosesLabel;
  final int registered;
  final int capacity;
  final String prizePool;
  final int closingDays;
  final double distanceKm;
  final String teamsGrid;

  double get fillRatio => capacity == 0 ? 0 : (registered / capacity).clamp(0, 1);
  int get fillPercent => (fillRatio * 100).round();

  String get listTitle {
    final oneLine = title.replaceAll('\n', ' ');
    final dash = oneLine.indexOf(' -');
    return dash == -1 ? oneLine : oneLine.substring(0, dash);
  }
}

class TeamUpSportOption {
  const TeamUpSportOption({
    required this.label,
    required this.icon,
    required this.tileColors,
  });

  final String label;
  final IconData icon;
  final List<Color> tileColors;
}

const dummyTeamUpChipSports = [
  (null, 'All'),
  (Icons.sports_cricket_rounded, 'Cricket'),
  (Icons.sports_soccer_rounded, 'Football'),
  (Icons.sports_tennis_rounded, 'Badminton'),
  (Icons.sports_rounded, 'Kabaddi'),
];

const dummyTeamUpSports = [
  TeamUpSportOption(
    label: 'Cricket',
    icon: Icons.sports_cricket_rounded,
    tileColors: [Color(0xFF1E3A52), Color(0xFF15181F)],
  ),
  TeamUpSportOption(
    label: 'Football',
    icon: Icons.sports_soccer_rounded,
    tileColors: [Color(0xFF5A2A22), Color(0xFF15181F)],
  ),
  TeamUpSportOption(
    label: 'Badminton',
    icon: Icons.sports_tennis_rounded,
    tileColors: [Color(0xFF4A3A18), Color(0xFF15181F)],
  ),
  TeamUpSportOption(
    label: 'Kabaddi',
    icon: Icons.sports_martial_arts_rounded,
    tileColors: [Color(0xFF4A2C14), Color(0xFF15181F)],
  ),
  TeamUpSportOption(
    label: 'Dodgeball',
    icon: Icons.sports_handball_rounded,
    tileColors: [Color(0xFF2A2E38), Color(0xFF15181F)],
  ),
];

const dummyTeamUpHowItWorks = [
  'Register individually — no team needed',
  'SPOTO Balanced Randomization™ builds your squad',
  'Play with your new team, build your SPOTO legacy',
];

const dummyTeamUpFilters = ['Upcoming', 'Closing Soon', 'Lowest Fee', 'Nearest'];

const dummyTeamUpPlatformFee = 15;

const dummyTeamUpPlayingRoles = [
  'Batter',
  'Bowler',
  'All-Rounder',
  'Wicketkeeper',
  'Wicketkeeper-Batter',
];

const dummyTeamUpBattingStyles = ['Right-hand', 'Left-hand'];

const dummyTeamUpBowlingStyles = [
  'Right-arm Pace',
  'Left-arm Pace',
  'Right-arm Spin',
  'Left-arm Spin',
  "Doesn't Bowl",
];

const dummyTeamUpExperienceLevels = ['Beginner', 'Intermediate', 'Advanced'];

const List<TeamUpTournament> dummyTeamUpTournaments = [
  TeamUpTournament(
    id: 'teamup-cricket-1',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    title: 'SPOTO Random Cricket -\nHyderabad',
    dateLabel: '24 Aug 2026',
    venue: 'Kompally Turf Arena, Hyderabad',
    entryFee: 499,
    teamSize: 6,
    formatLine: '3 overs · 3 balls/over',
    regClosesLabel: '22 Aug 2026, 11:59 PM',
    registered: 32,
    capacity: 40,
    prizePool: '₹25,000',
    closingDays: 12,
    distanceKm: 4.2,
    teamsGrid: '8 X 5',
  ),
  TeamUpTournament(
    id: 'teamup-cricket-2',
    sport: 'Cricket',
    sportIcon: Icons.sports_cricket_rounded,
    title: 'SPOTO Night Super Over -\nHyderabad',
    dateLabel: '2 Sep 2026',
    venue: 'Gachibowli Stadium, Hyderabad',
    entryFee: 799,
    teamSize: 8,
    formatLine: '1 over · Super Over',
    regClosesLabel: '18 Sep 2026, 11:59 PM',
    registered: 18,
    capacity: 32,
    prizePool: '₹40,000',
    closingDays: 4,
    distanceKm: 8.1,
    teamsGrid: '8 X 4',
  ),
  TeamUpTournament(
    id: 'teamup-football-1',
    sport: 'Football',
    sportIcon: Icons.sports_soccer_rounded,
    title: 'SPOTO Random Football 5s -\nHyderabad',
    dateLabel: '30 Aug 2026',
    venue: 'Hitex Football Arena, Hyderabad',
    entryFee: 399,
    teamSize: 5,
    formatLine: '5v5 · 12 min halves',
    regClosesLabel: '22 Sep 2026, 11:59 PM',
    registered: 20,
    capacity: 24,
    prizePool: '₹18,000',
    closingDays: 8,
    distanceKm: 6.5,
    teamsGrid: '8 X 3',
  ),
  TeamUpTournament(
    id: 'teamup-badminton-1',
    sport: 'Badminton',
    sportIcon: Icons.sports_tennis_rounded,
    title: 'SPOTO Ace Smashers Open -\nChennai',
    dateLabel: '6 Sep 2026',
    venue: 'Chennai Indoor Arena',
    entryFee: 299,
    teamSize: 2,
    formatLine: 'Doubles · Best of 3',
    regClosesLabel: '28 Sep 2026, 11:59 PM',
    registered: 14,
    capacity: 16,
    prizePool: '₹8,000',
    closingDays: 20,
    distanceKm: 22.0,
    teamsGrid: '8 X 2',
  ),
  TeamUpTournament(
    id: 'teamup-kabaddi-1',
    sport: 'Kabaddi',
    sportIcon: Icons.sports_martial_arts_rounded,
    title: 'SPOTO Kabaddi Night -\nWarangal',
    dateLabel: '12 Sep 2026',
    venue: 'Warangal Indoor Stadium',
    entryFee: 349,
    teamSize: 7,
    formatLine: '7v7 · 20 min',
    regClosesLabel: '1 Sep 2026, 11:59 PM',
    registered: 22,
    capacity: 28,
    prizePool: '₹12,000',
    closingDays: 6,
    distanceKm: 18.0,
    teamsGrid: '7 X 4',
  ),
];

class TeamUpAssignedPlayer {
  const TeamUpAssignedPlayer({
    required this.name,
    required this.role,
    required this.rating,
    this.isYou = false,
  });

  final String name;
  final String role;
  final int rating;
  final bool isYou;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final one = parts.first;
      return one.substring(0, one.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class TeamUpAssignedTeam {
  const TeamUpAssignedTeam({
    required this.name,
    required this.squadRating,
    required this.players,
  });

  final String name;
  final int squadRating;
  final List<TeamUpAssignedPlayer> players;
}

const dummyTeamUpAssignedTeam = TeamUpAssignedTeam(
  name: 'TEAM BLAZERS',
  squadRating: 75,
  players: [
    TeamUpAssignedPlayer(name: 'Madhav Jaat', role: 'Wicketkeeper', rating: 89),
    TeamUpAssignedPlayer(name: 'Kiran Kumar', role: 'All-Rounder', rating: 74),
    TeamUpAssignedPlayer(name: 'Shravan Prajapati', role: 'Batter', rating: 74, isYou: true),
    TeamUpAssignedPlayer(name: 'Sanjay Reddy', role: 'Wicketkeeper', rating: 70),
    TeamUpAssignedPlayer(name: 'Harish Solanki', role: 'Batter', rating: 59),
  ],
);
