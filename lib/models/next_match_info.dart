/// Static design-time model for the "Next Match" spotlight card on the
/// home dashboard. No persistence/network layer — purely for UI
/// presentation.
class NextMatchInfo {
  const NextMatchInfo({
    required this.stage,
    required this.dateLabel,
    required this.title,
    required this.location,
    required this.teamA,
    required this.teamB,
    required this.prize,
    required this.maxPlayers,
    required this.regFee,
    required this.regEndsLabel,
  });

  final String stage;
  final String dateLabel;
  final String title;
  final String location;
  final String teamA;
  final String teamB;
  final String prize;
  final String maxPlayers;
  final String regFee;
  final String regEndsLabel;
}

const NextMatchInfo dummyNextMatch = NextMatchInfo(
  stage: 'Quarter Final',
  dateLabel: 'Tomorrow, 06:30 PM',
  title: 'Asia Cup 2026',
  location: 'Hyderabad',
  teamA: 'Delhi Warriors',
  teamB: 'Hyd Highlanders',
  prize: '₹50,000',
  maxPlayers: '32',
  regFee: '₹999',
  regEndsLabel: '30 June 2026',
);
