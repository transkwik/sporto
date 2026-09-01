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
    roundLabel: 'Group Stage',
    title: 'City League 2026',
    location: 'Hyderabad',
    teamA: 'Thunder Titans',
    teamB: 'Royal Smashers',
    statusLine: 'Starts 28 Aug 2026  •  6:00 PM',
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
];
