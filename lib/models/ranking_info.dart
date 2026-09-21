enum RankingKind { teams, players }

class RankingEntry {
  const RankingEntry({
    required this.rank,
    required this.name,
    required this.sport,
    required this.kind,
    required this.matches,
    required this.awards,
    required this.points,
    this.delta,
  });

  final int rank;
  final String name;
  final String sport;
  final RankingKind kind;
  final int matches;
  final int awards;
  final int points;
  /// Positive = moved up, negative = moved down, null = unchanged.
  final int? delta;
}

const List<RankingEntry> dummyRankings = [
  RankingEntry(rank: 1, name: 'Thunder Titans', sport: 'Cricket', kind: RankingKind.teams, matches: 18, awards: 3, points: 128, delta: 2),
  RankingEntry(rank: 2, name: 'Royal Smashers', sport: 'Cricket', kind: RankingKind.teams, matches: 18, awards: 3, points: 121, delta: 1),
  RankingEntry(rank: 3, name: 'Delhi Warriors', sport: 'Cricket', kind: RankingKind.teams, matches: 17, awards: 3, points: 116),
  RankingEntry(rank: 4, name: 'Mumbai Strikers', sport: 'Cricket', kind: RankingKind.teams, matches: 17, awards: 3, points: 109, delta: -1),
  RankingEntry(rank: 5, name: 'Jaipur Royal', sport: 'Cricket', kind: RankingKind.teams, matches: 16, awards: 3, points: 102, delta: 3),
  RankingEntry(rank: 1, name: 'Warriors FC', sport: 'Football', kind: RankingKind.teams, matches: 14, awards: 2, points: 96, delta: 1),
  RankingEntry(rank: 2, name: 'Blaze United', sport: 'Football', kind: RankingKind.teams, matches: 14, awards: 1, points: 88, delta: -1),
  RankingEntry(rank: 1, name: 'Ace Smashers', sport: 'Badminton', kind: RankingKind.teams, matches: 10, awards: 2, points: 74, delta: 2),
  RankingEntry(rank: 1, name: 'Rahul Sharma', sport: 'Cricket', kind: RankingKind.players, matches: 18, awards: 4, points: 210, delta: 8),
  RankingEntry(rank: 2, name: 'Sandeep Rao', sport: 'Cricket', kind: RankingKind.players, matches: 17, awards: 3, points: 198, delta: 2),
  RankingEntry(rank: 3, name: 'Arjun Reddy', sport: 'Cricket', kind: RankingKind.players, matches: 16, awards: 2, points: 176, delta: -1),
  RankingEntry(rank: 4, name: 'Vikram Chowdary', sport: 'Cricket', kind: RankingKind.players, matches: 16, awards: 1, points: 164),
  RankingEntry(rank: 5, name: 'Farhan Ali', sport: 'Cricket', kind: RankingKind.players, matches: 15, awards: 1, points: 151, delta: 3),
  RankingEntry(rank: 1, name: 'A. Rao', sport: 'Football', kind: RankingKind.players, matches: 12, awards: 2, points: 140, delta: 1),
  RankingEntry(rank: 1, name: 'K. Menon', sport: 'Badminton', kind: RankingKind.players, matches: 9, awards: 2, points: 118, delta: 2),
];

class PlayerRankingDetail {
  const PlayerRankingDetail({
    required this.entry,
    required this.rating,
    required this.role,
    required this.teamName,
    required this.isCaptain,
    required this.recentForm,
    required this.runs,
    required this.battingAverage,
    required this.strikeRate,
    required this.wickets,
    required this.economy,
    required this.achievements,
  });

  final RankingEntry entry;
  final double rating;
  final String role;
  final String teamName;
  final bool isCaptain;
  final List<int> recentForm;
  final int runs;
  final double battingAverage;
  final double strikeRate;
  final int wickets;
  final double economy;
  final List<String> achievements;

  factory PlayerRankingDetail.fromEntry(RankingEntry entry) {
    return PlayerRankingDetail(
      entry: entry,
      rating: entry.rank == 1 && entry.sport == 'Cricket' ? 94.6 : (entry.points / 2.2),
      role: entry.sport == 'Football' ? 'Forward' : entry.sport == 'Badminton' ? 'Singles' : 'Bowler',
      teamName: entry.sport == 'Football'
          ? 'Warriors FC'
          : entry.sport == 'Badminton'
              ? 'Ace Smashers'
              : 'Thunder Titans',
      isCaptain: entry.rank == 1,
      recentForm: const [72, 41, 89, 16, 64],
      runs: 642,
      battingAverage: 40.1,
      strikeRate: 168.4,
      wickets: 8,
      economy: 7.2,
      achievements: const [
        'Hyderabad Super Cup Champion',
        '3× Player of the Match',
      ],
    );
  }
}

class TeamRankingDetail {
  const TeamRankingDetail({
    required this.entry,
    required this.city,
    required this.captainName,
    required this.recentForm,
    required this.won,
    required this.lost,
    required this.netRunRate,
    required this.achievements,
  });

  final RankingEntry entry;
  final String city;
  final String captainName;
  final List<String> recentForm;
  final int won;
  final int lost;
  final String netRunRate;
  final List<String> achievements;

  factory TeamRankingDetail.fromEntry(RankingEntry entry) {
    final won = (entry.matches * 0.7).round();
    return TeamRankingDetail(
      entry: entry,
      city: 'Hyderabad',
      captainName: 'Rahul Sharma',
      recentForm: const ['W', 'W', 'L', 'W', 'W'],
      won: won,
      lost: entry.matches - won,
      netRunRate: '+1.24',
      achievements: const [
        'Hyderabad Super Cup Champion',
        '3× Tournament Winner',
      ],
    );
  }
}
