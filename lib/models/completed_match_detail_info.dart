/// Data for the completed-match details screen. Filled from the matches API
/// map when present, with design fallbacks for summary fields.
class CompletedMatchDetailInfo {
  const CompletedMatchDetailInfo({
    required this.tournamentName,
    required this.location,
    required this.dateShort,
    required this.timeLabel,
    required this.roundLabel,
    required this.sport,
    required this.venue,
    required this.battingTeam,
    required this.bowlingTeam,
    required this.battingScore,
    required this.bowlingScore,
    required this.winnerName,
    required this.playerOfTheMatch,
    required this.dateFull,
    required this.referee,
  });

  final String tournamentName;
  final String location;
  final String dateShort;
  final String timeLabel;
  final String roundLabel;
  final String sport;
  final String venue;
  final String battingTeam;
  final String bowlingTeam;
  final String battingScore;
  final String bowlingScore;
  final String winnerName;
  final String playerOfTheMatch;
  final String dateFull;
  final String referee;

  String get initials {
    final words = tournamentName.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    final t = tournamentName.trim();
    return t.isEmpty ? 'M' : t.substring(0, t.length >= 2 ? 2 : 1).toUpperCase();
  }

  factory CompletedMatchDetailInfo.fromMatchData(Map<String, dynamic> matchData) {
    final match = matchData['match'];
    final teams = matchData['teams'] as List<dynamic>? ?? [];
    final teamA = teams.isNotEmpty ? (teams[0]['name']?.toString() ?? 'Team A') : 'Team A';
    final teamB = teams.length > 1 ? (teams[1]['name']?.toString() ?? 'Team B') : 'Team B';
    final title = matchData['tournament']?['name']?.toString() ??
        matchData['format']?['name']?.toString() ??
        'Tournament';
    final venue = matchData['venue']?['name']?.toString() ??
        matchData['ground']?.toString() ??
        match?['venue']?.toString() ??
        'Ground A';
    final winner = match?['winner']?['name']?.toString() ??
        matchData['winner']?['name']?.toString() ??
        match?['winner']?.toString() ??
        matchData['winner']?.toString() ??
        teamA;

    return CompletedMatchDetailInfo(
      tournamentName: title,
      location: matchData['city']?.toString() ??
          matchData['location']?.toString() ??
          match?['city']?.toString() ??
          'Hyderabad',
      dateShort: match?['date_label']?.toString() ??
          matchData['date_label']?.toString() ??
          '8 Aug Today',
      timeLabel: match?['start_time']?.toString() ??
          match?['time']?.toString() ??
          matchData['time']?.toString() ??
          '10:30 AM',
      roundLabel: matchData['round']?['name']?.toString() ??
          matchData['stage']?.toString() ??
          'Round of 128',
      sport: matchData['sport']?['name']?.toString() ?? 'Cricket',
      venue: venue,
      battingTeam: teamA,
      bowlingTeam: teamB,
      battingScore: match?['score_a']?.toString() ??
          match?['scoreA']?.toString() ??
          (teams.isNotEmpty ? teams[0]['score']?.toString() : null) ??
          '28/1',
      bowlingScore: match?['score_b']?.toString() ??
          match?['scoreB']?.toString() ??
          (teams.length > 1 ? teams[1]['score']?.toString() : null) ??
          '31/2',
      winnerName: winner,
      playerOfTheMatch: match?['player_of_match']?.toString() ??
          matchData['player_of_match']?.toString() ??
          'Sandeep Rao',
      dateFull: match?['date']?.toString() ??
          matchData['date']?.toString() ??
          'Aug 08, 2026',
      referee: match?['referee']?.toString() ??
          matchData['referee']?.toString() ??
          'Amit Verma',
    );
  }
}

const dummyCompletedMatchDetail = CompletedMatchDetailInfo(
  tournamentName: 'Hyderabad Super Cup',
  location: 'Hyderabad',
  dateShort: '8 Aug Today',
  timeLabel: '10:30 AM',
  roundLabel: 'Round of 128',
  sport: 'Cricket',
  venue: 'Ground A',
  battingTeam: 'Hyd Highlanders',
  bowlingTeam: 'Delhi Warriors',
  battingScore: '28/1',
  bowlingScore: '31/2',
  winnerName: 'Hyd Highlanders',
  playerOfTheMatch: 'Sandeep Rao',
  dateFull: 'Aug 08, 2026',
  referee: 'Amit Verma',
);
