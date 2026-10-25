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
    String teamA = json['team_a']?['name']?.toString() ?? 'Team A';
    String teamB = json['team_b']?['name']?.toString() ?? 'Team B';
    String? teamAId = json['team_a']?['id']?.toString();
    String? teamBId = json['team_b']?['id']?.toString();

    final teams = json['teams'] as List<dynamic>?;
    if (teams != null && teams.isNotEmpty) {
      if (teamA == 'Team A') teamA = teams[0]['name']?.toString() ?? 'Team A';
      teamAId ??= teams[0]['id']?.toString();
      if (teams.length > 1) {
        if (teamB == 'Team B') teamB = teams[1]['name']?.toString() ?? 'Team B';
        teamBId ??= teams[1]['id']?.toString();
      }
    }

    String scoreA = json['score_a']?.toString() ?? '-';
    String scoreB = json['score_b']?.toString() ?? '-';

    final scoringData = json['scoring']?['score']?['teams'] as Map<String, dynamic>?;
    if (scoringData != null) {
      if (teamAId != null && scoringData[teamAId] != null) {
        final sc1 = scoringData[teamAId]['score']?.toString() ?? '0';
        final w1 = scoringData[teamAId]['wickets']?.toString() ?? '0';
        final o1 = scoringData[teamAId]['overs']?.toString();
        scoreA = o1 != null ? '$sc1/$w1 ($o1)' : '$sc1/$w1';
      }
      if (teamBId != null && scoringData[teamBId] != null) {
        final sc2 = scoringData[teamBId]['score']?.toString() ?? '0';
        final w2 = scoringData[teamBId]['wickets']?.toString() ?? '0';
        final o2 = scoringData[teamBId]['overs']?.toString();
        scoreB = o2 != null ? '$sc2/$w2 ($o2)' : '$sc2/$w2';
      }
    }

    final nestedMatch = json['match'];
    final id = json['id'] as int?
        ?? (nestedMatch is Map ? nestedMatch['id'] as int? : null)
        ?? 0;

    return MatchInfo(
      id: id,
      sport: json['sport']?['name']?.toString() ?? json['sport_name']?.toString() ?? 'Unknown',
      title: json['tournament']?['name']?.toString() ?? json['title']?.toString() ?? 'Friendly Match',
      teamA: teamA,
      teamB: teamB,
      scoreA: scoreA,
      scoreB: scoreB,
      status: json['status_label']?.toString() ?? json['status_key']?.toString() ?? json['status']?.toString() ?? 'Live',
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
