enum PrizeStepState { done, current, pending }

class PrizeProgressStep {
  const PrizeProgressStep({
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final String title;
  final String subtitle;
  final PrizeStepState state;
}

class PrizeLineItem {
  const PrizeLineItem({
    required this.label,
    required this.amountLabel,
    required this.status,
  });

  final String label;
  final String amountLabel;
  final String status;
}

class PrizeDetailsInfo {
  const PrizeDetailsInfo({
    required this.dateLabel,
    required this.sport,
    required this.tournamentTitle,
    required this.eventStatus,
    required this.prizeStatus,
    required this.steps,
    required this.winningEventTitle,
    required this.winningEventSubtitle,
    required this.teamPrize,
    required this.eligiblePlayers,
    required this.expectedShare,
    required this.creditNote,
    required this.yourPrizes,
    required this.totalPrize,
    this.formulaLabel = '₹50,000 ÷ 10 = ₹5,000',
    this.individualAwardsTotal = '₹5,000',
    this.totalBreakdown = '₹5,000 team share + ₹5,000 awards',
    this.walletTxnNote = 'Each prize is credited as its own wallet transaction.',
    this.eligibleCount = 10,
    this.yourSlot = 1,
    this.winningTeamName = 'SPOTO Warriors',
    this.distributionChecks = const [
      'Team prize split among 10 eligible players',
      'Individual awards added',
      'Crediting your SPOTO Wallet',
    ],
    this.creditTxnId = 'SPTO-20260926-00125',
    this.creditedOnLabel = '26 Sep 2026',
    this.totalCredited = '₹5,000',
  });

  final String dateLabel;
  final String sport;
  final String tournamentTitle;
  final String eventStatus;
  final String prizeStatus;
  final List<PrizeProgressStep> steps;
  final String winningEventTitle;
  final String winningEventSubtitle;
  final String teamPrize;
  final String eligiblePlayers;
  final String expectedShare;
  final String creditNote;
  final List<PrizeLineItem> yourPrizes;
  final String totalPrize;
  final String formulaLabel;
  final String individualAwardsTotal;
  final String totalBreakdown;
  final String walletTxnNote;
  final int eligibleCount;
  final int yourSlot;
  final String winningTeamName;
  final List<String> distributionChecks;
  final String creditTxnId;
  final String creditedOnLabel;
  final String totalCredited;
}

const dummyPrizeDetails = PrizeDetailsInfo(
  dateLabel: '10 Aug 2026',
  sport: 'Cricket',
  tournamentTitle: 'ABC PREMIER LEAGUE 2026',
  eventStatus: 'Completed',
  prizeStatus: 'Prize Processing',
  steps: [
    PrizeProgressStep(
      title: 'Tournament Completed',
      subtitle: '26 Sep, 6:42 PM',
      state: PrizeStepState.done,
    ),
    PrizeProgressStep(
      title: 'Final Result Verified',
      subtitle: '26 Sep, 7:05 PM',
      state: PrizeStepState.done,
    ),
    PrizeProgressStep(
      title: 'Winner Confirmed',
      subtitle: '26 Sep, 7:06 PM',
      state: PrizeStepState.done,
    ),
    PrizeProgressStep(
      title: 'Prize Calculated',
      subtitle: '26 Sep, 7:20 PM',
      state: PrizeStepState.done,
    ),
    PrizeProgressStep(
      title: 'Prize Distribution Processing',
      subtitle: 'In progress',
      state: PrizeStepState.current,
    ),
    PrizeProgressStep(
      title: 'Prize Credited to Wallet',
      subtitle: '',
      state: PrizeStepState.pending,
    ),
  ],
  winningEventTitle: 'Spoto Kondapur Super Over Cup',
  winningEventSubtitle: 'Winner · Split 6 ways',
  teamPrize: '₹50,000',
  eligiblePlayers: '10',
  expectedShare: '₹5,000',
  creditNote:
      'Your share will be credited to your SPOTO Wallet after prize distribution is completed.',
  yourPrizes: [
    PrizeLineItem(label: 'Winning Team Prize', amountLabel: '₹5,000', status: 'Processing'),
    PrizeLineItem(label: 'Player of the Tournament', amountLabel: '₹5,000', status: 'Processing'),
  ],
  totalPrize: '₹10,000',
);
