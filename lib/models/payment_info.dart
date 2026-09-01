/// Static design-time model for the match summary card shown at the top of
/// the payment method screen. No persistence/network layer — purely for
/// UI presentation.
class PaymentMatchSummary {
  const PaymentMatchSummary({
    required this.stage,
    required this.dateLabel,
    required this.title,
    required this.teamA,
    required this.teamB,
  });

  final String stage;
  final String dateLabel;
  final String title;
  final String teamA;
  final String teamB;
}

/// Static design-time model for the registration cost breakdown.
class PaymentBreakdown {
  const PaymentBreakdown({required this.registrationFee, required this.platformFee, required this.total});

  final String registrationFee;
  final String platformFee;
  final String total;
}

const PaymentMatchSummary dummyPaymentMatch = PaymentMatchSummary(
  stage: 'Quarter Final',
  dateLabel: 'Tomorrow, 06:30 PM',
  title: 'Asia Cup 2026',
  teamA: 'Delhi Warriors',
  teamB: 'Hyd Highlanders',
);

const PaymentBreakdown dummyPaymentBreakdown = PaymentBreakdown(
  registrationFee: '₹999',
  platformFee: '₹15',
  total: '1014',
);
