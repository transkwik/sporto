enum MyTournamentStatus { live, upcoming, completed }

/// One squad member's tournament stats.
class MyTournamentPlayerStat {
  const MyTournamentPlayerStat({
    required this.name,
    required this.role,
    required this.runs,
    required this.wickets,
    this.isYou = false,
  });

  final String name;
  final String role;
  final int runs;
  final int wickets;
  final bool isYou;
}

/// One finished or scheduled match in the user's tournament.
class MyTournamentMatchResult {
  const MyTournamentMatchResult({
    required this.teamA,
    required this.scoreA,
    required this.teamB,
    required this.scoreB,
    this.matchLabel = 'League — Match 1',
  });

  final String teamA;
  final String scoreA;
  final String teamB;
  final String scoreB;
  final String matchLabel;
}

/// One tournament the user is in, shown on Profile → My Tournaments.
class MyTournamentInfo {
  const MyTournamentInfo({
    required this.id,
    required this.sport,
    required this.status,
    required this.roundLabel,
    required this.title,
    required this.location,
    required this.teamA,
    required this.teamB,
    required this.statusLine,
    this.ctaLabel,
    this.dateRange = '',
    this.championTeam = '',
    this.played = 0,
    this.won = 0,
    this.lost = 0,
    this.finalRank = 0,
    this.prizeEarned = '',
    this.prizeCaption = '',
    this.squad = const [],
    this.matchResults = const [],
  });

  final String id;
  final String sport;
  final MyTournamentStatus status;
  final String roundLabel;
  final String title;
  final String location;
  final String teamA;
  final String teamB;
  final String statusLine;
  final String? ctaLabel;
  final String dateRange;
  final String championTeam;
  final int played;
  final int won;
  final int lost;
  final int finalRank;
  final String prizeEarned;
  final String prizeCaption;
  final List<MyTournamentPlayerStat> squad;
  final List<MyTournamentMatchResult> matchResults;
}

const _asiaCupSquad = [
  MyTournamentPlayerStat(name: 'You', role: 'Captain · Captain', runs: 187, wickets: 4, isYou: true),
  MyTournamentPlayerStat(name: 'Sandeep Rao', role: 'Batter', runs: 142, wickets: 0),
  MyTournamentPlayerStat(name: 'Sandeep Rao', role: 'Batter', runs: 96, wickets: 7),
  MyTournamentPlayerStat(name: 'Sandeep Rao', role: 'Batter', runs: 68, wickets: 5),
  MyTournamentPlayerStat(name: 'Sandeep Rao', role: 'Batter', runs: 21, wickets: 9),
];

const _asiaCupResults = [
  MyTournamentMatchResult(teamA: 'Hyd Highlanders', scoreA: '162/6', teamB: 'Delhi Warriors', scoreB: '148/9', matchLabel: 'League — Match 1'),
  MyTournamentMatchResult(teamA: 'Hyd Highlanders', scoreA: '162/6', teamB: 'Zoto Warrior', scoreB: '148/9', matchLabel: 'League — Match 1'),
  MyTournamentMatchResult(teamA: 'Hyd Highlanders', scoreA: '162/6', teamB: 'Thunder Titans', scoreB: '148/9', matchLabel: 'League — Match 1'),
  MyTournamentMatchResult(teamA: 'Hyd Highlanders', scoreA: '162/6', teamB: 'Royal Smashers', scoreB: '148/9', matchLabel: 'League — Match 1'),
];

const List<MyTournamentInfo> dummyMyTournaments = [
  MyTournamentInfo(
    id: 'asia-cup-live',
    sport: 'Cricket',
    status: MyTournamentStatus.live,
    roundLabel: 'Quarter Final',
    title: 'Asia Cup 2026',
    location: 'Hyderabad',
    teamA: 'Zoto Warrior',
    teamB: 'Delhi Warriors',
    statusLine: 'Need 4 Runs in 1 Ball Left',
    ctaLabel: 'Watch Live Now',
    dateRange: 'Aug 2 - 10, 2026',
    championTeam: 'Hyd Highlanders',
    played: 5,
    won: 5,
    lost: 0,
    finalRank: 1,
    prizeEarned: '₹50,000',
    prizeCaption: 'Winner · Active',
    squad: _asiaCupSquad,
    matchResults: _asiaCupResults,
  ),
  MyTournamentInfo(
    id: 'city-league-upcoming',
    sport: 'Cricket',
    status: MyTournamentStatus.upcoming,
    roundLabel: 'Final',
    title: 'Asia Cup 2026',
    location: 'Hyderabad',
    teamA: 'Hyd Highlanders',
    teamB: 'Delhi Warriors',
    statusLine: 'Tomorrow, 06:30 PM',
    ctaLabel: 'View Details',
    dateRange: 'Aug 28 - Sep 4, 2026',
    championTeam: '',
    played: 0,
    won: 0,
    lost: 0,
    finalRank: 0,
    prizeEarned: '₹0',
    prizeCaption: 'Not started',
    squad: [
      MyTournamentPlayerStat(name: 'You', role: 'Captain · All-rounder', runs: 0, wickets: 0, isYou: true),
      MyTournamentPlayerStat(name: 'Sandeep Rao', role: 'Batter', runs: 0, wickets: 0),
    ],
    matchResults: [
      MyTournamentMatchResult(
        teamA: 'Thunder Titans',
        scoreA: '—',
        teamB: 'Royal Smashers',
        scoreB: '—',
        matchLabel: 'Group Stage — Match 1',
      ),
    ],
  ),
  MyTournamentInfo(
    id: 'asia-cup-done',
    sport: 'Cricket',
    status: MyTournamentStatus.completed,
    roundLabel: 'Final',
    title: 'Asia Cup 2026',
    location: 'Hyderabad',
    teamA: 'Hyd Highlanders',
    teamB: 'Thunder Titans',
    statusLine: 'Hyd Highlanders won the cup',
    ctaLabel: 'View Scorecard',
    dateRange: 'Aug 2 – 10, 2026',
    championTeam: 'Hyd Highlanders',
    played: 5,
    won: 5,
    lost: 0,
    finalRank: 1,
    prizeEarned: '₹50,000',
    prizeCaption: 'Winner · Active',
    squad: _asiaCupSquad,
    matchResults: _asiaCupResults,
  ),
];

const _footballSquad = [
  MyTournamentPlayerStat(name: 'You', role: 'Captain · Forward', runs: 0, wickets: 0, isYou: true),
  MyTournamentPlayerStat(name: 'Rohit Naik', role: 'Midfielder', runs: 0, wickets: 0),
  MyTournamentPlayerStat(name: 'Sandeep Rao', role: 'Defender', runs: 0, wickets: 0),
  MyTournamentPlayerStat(name: 'Vikram Chowdary', role: 'Goalkeeper', runs: 0, wickets: 0),
];

const _footballResults = [
  MyTournamentMatchResult(teamA: 'Warriors FC', scoreA: '2', teamB: 'Blaze United', scoreB: '1', matchLabel: 'Group Stage — Match 1'),
  MyTournamentMatchResult(teamA: 'Warriors FC', scoreA: '3', teamB: 'City Rovers', scoreB: '3', matchLabel: 'Group Stage — Match 2'),
  MyTournamentMatchResult(teamA: 'Warriors FC', scoreA: '1', teamB: 'Hyderabad FC', scoreB: '0', matchLabel: 'Semi Final'),
];

/// Browse-all catalog (not only tournaments the user joined). Same card/detail model.
const List<MyTournamentInfo> dummyAllTournaments = [
  ...dummyMyTournaments,
  MyTournamentInfo(
    id: 'kondapur-live',
    sport: 'Cricket',
    status: MyTournamentStatus.live,
    roundLabel: 'Semi Final',
    title: 'Spoto Kondapur Super Over Cup',
    location: 'Hyderabad',
    teamA: 'Hyd Highlanders',
    teamB: 'Royal Smashers',
    statusLine: 'Need 12 Runs in 8 Balls',
    ctaLabel: 'Watch Live Now',
    dateRange: 'Sep 20 - 28, 2026',
    championTeam: '',
    played: 4,
    won: 3,
    lost: 1,
    finalRank: 0,
    prizeEarned: '₹0',
    prizeCaption: 'In progress',
    squad: _asiaCupSquad,
    matchResults: _asiaCupResults,
  ),
  MyTournamentInfo(
    id: 'bengaluru-live',
    sport: 'Football',
    status: MyTournamentStatus.live,
    roundLabel: 'Quarter Final',
    title: 'Spoto Bengaluru Penalty Kickout Cup',
    location: 'Bengaluru',
    teamA: 'Warriors FC',
    teamB: 'Blaze United',
    statusLine: '2nd Half · 68’',
    ctaLabel: 'Watch Live Now',
    dateRange: 'Sep 18 - 27, 2026',
    championTeam: '',
    played: 3,
    won: 2,
    lost: 1,
    finalRank: 0,
    prizeEarned: '₹0',
    prizeCaption: 'In progress',
    squad: _footballSquad,
    matchResults: _footballResults,
  ),
  MyTournamentInfo(
    id: 'kabaddi-live',
    sport: 'Kabaddi',
    status: MyTournamentStatus.live,
    roundLabel: 'League',
    title: 'Spoto Warriors Kabaddi League',
    location: 'Pune',
    teamA: 'Pune Panthers',
    teamB: 'Jaipur Pinks',
    statusLine: 'Raid in progress',
    ctaLabel: 'Watch Live Now',
    dateRange: 'Sep 22 - 30, 2026',
    championTeam: '',
    played: 2,
    won: 1,
    lost: 1,
    finalRank: 0,
    prizeEarned: '₹0',
    prizeCaption: 'In progress',
    squad: [
      MyTournamentPlayerStat(name: 'You', role: 'Raider', runs: 18, wickets: 0, isYou: true),
      MyTournamentPlayerStat(name: 'Kiran Varma', role: 'Defender', runs: 6, wickets: 0),
    ],
    matchResults: [
      MyTournamentMatchResult(teamA: 'Pune Panthers', scoreA: '34', teamB: 'Jaipur Pinks', scoreB: '28', matchLabel: 'League — Match 1'),
    ],
  ),
  MyTournamentInfo(
    id: 'hyd-5s-upcoming',
    sport: 'Football',
    status: MyTournamentStatus.upcoming,
    roundLabel: 'Group Stage',
    title: 'Spoto Hyderabad Night 5s',
    location: 'Hyderabad',
    teamA: 'Warriors FC',
    teamB: 'City Rovers',
    statusLine: 'Sat, 07:30 PM',
    ctaLabel: 'View Details',
    dateRange: 'Oct 4 - 12, 2026',
    prizeEarned: '₹0',
    prizeCaption: 'Not started',
    squad: _footballSquad,
    matchResults: [
      MyTournamentMatchResult(teamA: 'Warriors FC', scoreA: '—', teamB: 'City Rovers', scoreB: '—', matchLabel: 'Group Stage — Match 1'),
    ],
  ),
  MyTournamentInfo(
    id: 'ace-upcoming',
    sport: 'Badminton',
    status: MyTournamentStatus.upcoming,
    roundLabel: 'Round of 16',
    title: 'Spoto Ace Smashers Open',
    location: 'Chennai',
    teamA: 'Ace Smashers',
    teamB: 'City Shuttlers',
    statusLine: 'Sun, 09:00 AM',
    ctaLabel: 'View Details',
    dateRange: 'Oct 8 - 10, 2026',
    prizeEarned: '₹0',
    prizeCaption: 'Not started',
    squad: [
      MyTournamentPlayerStat(name: 'You', role: 'Singles', runs: 0, wickets: 0, isYou: true),
      MyTournamentPlayerStat(name: 'K. Menon', role: 'Doubles', runs: 0, wickets: 0),
    ],
    matchResults: [
      MyTournamentMatchResult(teamA: 'Ace Smashers', scoreA: '—', teamB: 'City Shuttlers', scoreB: '—', matchLabel: 'Round of 16'),
    ],
  ),
  MyTournamentInfo(
    id: 'kabaddi-upcoming',
    sport: 'Kabaddi',
    status: MyTournamentStatus.upcoming,
    roundLabel: 'Qualifier',
    title: 'Spoto State Kabaddi Qualifiers',
    location: 'Warangal',
    teamA: 'Warangal Wolves',
    teamB: 'Nizam Knights',
    statusLine: 'Fri, 06:00 PM',
    ctaLabel: 'View Details',
    dateRange: 'Oct 15 - 18, 2026',
    prizeEarned: '₹0',
    prizeCaption: 'Not started',
    squad: [
      MyTournamentPlayerStat(name: 'You', role: 'Raider', runs: 0, wickets: 0, isYou: true),
    ],
    matchResults: [
      MyTournamentMatchResult(teamA: 'Warangal Wolves', scoreA: '—', teamB: 'Nizam Knights', scoreB: '—', matchLabel: 'Qualifier — Match 1'),
    ],
  ),
  MyTournamentInfo(
    id: 'chennai-football-done',
    sport: 'Football',
    status: MyTournamentStatus.completed,
    roundLabel: 'Final',
    title: 'Spoto Chennai United Cup',
    location: 'Chennai',
    teamA: 'Warriors FC',
    teamB: 'Blaze United',
    statusLine: 'Warriors FC won the cup',
    ctaLabel: 'View Scorecard',
    dateRange: 'Aug 1 – 8, 2026',
    championTeam: 'Warriors FC',
    played: 6,
    won: 5,
    lost: 1,
    finalRank: 1,
    prizeEarned: '₹25,000',
    prizeCaption: 'Winner · Paid',
    squad: _footballSquad,
    matchResults: _footballResults,
  ),
  MyTournamentInfo(
    id: 'ace-done',
    sport: 'Badminton',
    status: MyTournamentStatus.completed,
    roundLabel: 'Final',
    title: 'Spoto Ace Smashers Classic',
    location: 'Chennai',
    teamA: 'Ace Smashers',
    teamB: 'Coastal Smash',
    statusLine: 'Ace Smashers won the title',
    ctaLabel: 'View Scorecard',
    dateRange: 'Jul 12 – 14, 2026',
    championTeam: 'Ace Smashers',
    played: 4,
    won: 4,
    lost: 0,
    finalRank: 1,
    prizeEarned: '₹8,000',
    prizeCaption: 'Winner · Paid',
    squad: [
      MyTournamentPlayerStat(name: 'You', role: 'Singles', runs: 0, wickets: 0, isYou: true),
      MyTournamentPlayerStat(name: 'K. Menon', role: 'Doubles', runs: 0, wickets: 0),
    ],
    matchResults: [
      MyTournamentMatchResult(teamA: 'Ace Smashers', scoreA: '21-18, 21-16', teamB: 'Coastal Smash', scoreB: '18-21, 16-21', matchLabel: 'Final'),
    ],
  ),
  MyTournamentInfo(
    id: 'kabaddi-done',
    sport: 'Kabaddi',
    status: MyTournamentStatus.completed,
    roundLabel: 'Final',
    title: 'Spoto State Kabaddi Cup',
    location: 'Hyderabad',
    teamA: 'Hyd Raiders',
    teamB: 'Pune Panthers',
    statusLine: 'Hyd Raiders won the cup',
    ctaLabel: 'View Scorecard',
    dateRange: 'Jun 20 – 28, 2026',
    championTeam: 'Hyd Raiders',
    played: 5,
    won: 4,
    lost: 1,
    finalRank: 2,
    prizeEarned: '₹12,000',
    prizeCaption: 'Runner-up · Paid',
    squad: [
      MyTournamentPlayerStat(name: 'You', role: 'Raider', runs: 42, wickets: 0, isYou: true),
      MyTournamentPlayerStat(name: 'Kiran Varma', role: 'Defender', runs: 11, wickets: 0),
    ],
    matchResults: [
      MyTournamentMatchResult(teamA: 'Hyd Raiders', scoreA: '41', teamB: 'Pune Panthers', scoreB: '36', matchLabel: 'Final'),
    ],
  ),
];
