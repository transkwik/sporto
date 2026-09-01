/// Static design-time model representing a live match card on the home
/// dashboard. No persistence/network layer — purely for UI presentation.
class MatchInfo {
  const MatchInfo({
    required this.sport,
    required this.title,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.status,
  });

  final String sport;
  final String title;
  final String teamA;
  final String teamB;
  final String scoreA;
  final String scoreB;
  final String status;
}

const MatchInfo dummyLiveMatch = MatchInfo(
  sport: 'Cricket',
  title: 'Jaipur Super Over',
  teamA: 'Thunder Titans',
  teamB: 'Royal Strikers',
  scoreA: '28/1',
  scoreB: '31/2',
  status: 'Need 4 Runs in 1 Ball Left',
);

/// Static design-time list of every currently live match, shown on the
/// dedicated "Live Matches" tab.
const List<MatchInfo> dummyLiveMatches = [
  dummyLiveMatch,
  MatchInfo(
    sport: 'Football',
    title: 'Warriors FC',
    teamA: 'Warriors FC',
    teamB: 'Blaze United',
    scoreA: '2',
    scoreB: '1',
    status: 'Kicker 3 of 5',
  ),
  MatchInfo(
    sport: 'Badminton',
    title: 'Warriors FC',
    teamA: 'A. Rao',
    teamB: 'K. Menon',
    scoreA: '11',
    scoreB: '9',
    status: 'Set 2 of 3',
  ),
];
