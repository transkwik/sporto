/// Static design-time model representing a live match card on the home
/// dashboard. No persistence/network layer — purely for UI presentation.
class MatchInfo {
  const MatchInfo({
    this.id = 0,
    required this.sport,
    required this.title,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.status,
  });

  final int id;
  final String sport;
  final String title;
  final String teamA;
  final String teamB;
  final String scoreA;
  final String scoreB;
  final String status;

  factory MatchInfo.fromJson(Map<String, dynamic> json) {
    return MatchInfo(
      id: json['id'] as int? ?? 0,
      sport: json['sport']?['name']?.toString() ?? json['sport_name']?.toString() ?? 'Unknown',
      title: json['tournament']?['name']?.toString() ?? json['title']?.toString() ?? 'Friendly Match',
      teamA: json['team_a']?['name']?.toString() ?? 'Team A',
      teamB: json['team_b']?['name']?.toString() ?? 'Team B',
      scoreA: json['score_a']?.toString() ?? '-',
      scoreB: json['score_b']?.toString() ?? '-',
      status: json['status']?.toString() ?? 'Live',
    );
  }
}

const MatchInfo dummyLiveMatch = MatchInfo(
  id: 3665,
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
