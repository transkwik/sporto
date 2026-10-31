import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/prize_details_info.dart';
import '../tournament/tournament_detail_screen.dart';
import 'prize_calculation_screen.dart';
import 'prize_distribution_screen.dart';

// ---------------------------------------------------------------------------
// API models (parsed from GET user/tournaments/{id}/prizes)
// ---------------------------------------------------------------------------

class _ApiPrize {
  const _ApiPrize({
    required this.title,
    required this.amount,
    required this.currency,
    required this.resolverCode,
    required this.distributionModeLabel,
    required this.isActive,
  });

  final String title;
  final String amount;
  final String currency;
  final String resolverCode;
  final String distributionModeLabel;
  final bool isActive;

  String get formattedAmount => _money(amount, currency);

  factory _ApiPrize.fromJson(Map<String, dynamic> j) {
    final status = j['status'];
    return _ApiPrize(
      title: j['title']?.toString() ?? 'Prize',
      amount: j['amount']?.toString() ?? '0',
      currency: j['currency']?.toString() ?? 'INR',
      resolverCode: j['resolver_code']?.toString() ?? '',
      distributionModeLabel: j['distribution_mode_label']?.toString() ?? '',
      isActive: status == 1 || status == true || status == '1',
    );
  }
}

class _ApiPrizes {
  const _ApiPrizes({
    required this.tournamentName,
    required this.totalPool,
    required this.prizes,
  });

  final String? tournamentName;
  final String totalPool;
  final List<_ApiPrize> prizes;

  String get formattedPool =>
      _money(totalPool, prizes.isNotEmpty ? prizes.first.currency : 'INR');

  _ApiPrize? get winner =>
      prizes.where((p) => p.resolverCode == 'TOURNAMENT_WINNER').firstOrNull;

  factory _ApiPrizes.fromJson(Map<String, dynamic> j) {
    final t = j['tournament'];
    final rawPrizes = j['prizes'];
    return _ApiPrizes(
      tournamentName: t is Map ? t['name']?.toString() : null,
      totalPool: j['total_pool']?.toString() ?? '0',
      prizes: rawPrizes is List
          ? [
              for (final p in rawPrizes)
                if (p is Map) _ApiPrize.fromJson(Map<String, dynamic>.from(p)),
            ]
          : const [],
    );
  }
}

/// "60000.00" + "INR" -> "₹60,000" (Indian digit grouping).
String _money(String raw, [String currency = 'INR']) {
  final symbol = currency.toUpperCase() == 'INR' ? '₹' : '$currency ';
  final n = num.tryParse(raw);
  if (n == null) return '$symbol$raw';
  final whole = n == n.roundToDouble();
  final fixed = whole ? n.round().toString() : n.toStringAsFixed(2);
  final parts = fixed.split('.');
  var intPart = parts[0];
  final neg = intPart.startsWith('-');
  if (neg) intPart = intPart.substring(1);

  String grouped;
  if (intPart.length <= 3) {
    grouped = intPart;
  } else {
    final last3 = intPart.substring(intPart.length - 3);
    var rest = intPart.substring(0, intPart.length - 3);
    final buf = <String>[];
    while (rest.length > 2) {
      buf.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) buf.insert(0, rest);
    grouped = '${buf.join(',')},$last3';
  }
  final decimals = parts.length > 1 ? '.${parts[1]}' : '';
  return '${neg ? '-' : ''}$symbol$grouped$decimals';
}

/// Home → Prize Details: distribution timeline, team prize, and your lines.
/// API data (`GET user/tournaments/{id}/prizes`) is merged over the dummy
/// base, so the design is always fully shown. Pull down to refresh.
class PrizeDetailsScreen extends StatefulWidget {
  const PrizeDetailsScreen({
    super.key,
    required this.tournamentId,
    this.tournamentName,
    this.details = dummyPrizeDetails,
  });

  final int tournamentId;

  /// Optional name used until / unless the API returns one.
  final String? tournamentName;

  /// Dummy base; API values override it.
  final PrizeDetailsInfo details;

  @override
  State<PrizeDetailsScreen> createState() => _PrizeDetailsScreenState();
}

class _PrizeDetailsScreenState extends State<PrizeDetailsScreen> {
  _ApiPrizes? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    if (!refresh) setState(() => _loading = true);

    _ApiPrizes? data;
    String? error;
    try {
      final res = await UserApis().getTournamentPrizes(widget.tournamentId);
      if (res is! Map) {
        error = 'Unexpected response from server.';
      } else if (res['session_expired'] == true) {
        error = 'Your session has expired. Please log in again.';
      } else if (res['error'] != null) {
        error = res['error'].toString();
      } else if (res['success'] != true) {
        error = res['message']?.toString() ?? 'Could not load prize details.';
      } else if (res['data'] is! Map) {
        error = 'Prize details are not available.';
      } else {
        data = _ApiPrizes.fromJson(
          Map<String, dynamic>.from(res['data'] as Map),
        );
      }
    } catch (_) {
      error = 'Something went wrong. Please try again.';
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (data != null) _data = data;
    });
    if (data == null && error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  /// API fields override the dummy base; everything else stays as is.
  PrizeDetailsInfo _merged() {
    final b = widget.details;
    final api = _data;

    final passedName = widget.tournamentName;
    final apiName = api?.tournamentName;
    final title = (apiName != null && apiName.isNotEmpty)
        ? apiName
        : (passedName != null && passedName.isNotEmpty
              ? passedName
              : b.tournamentTitle);

    if (api == null) return _copy(b, tournamentTitle: title);

    final winner = api.winner;
    return _copy(
      b,
      tournamentTitle: title,
      yourPrizes: api.prizes.isEmpty
          ? null
          : [
              for (final p in api.prizes)
                PrizeLineItem(
                  label: p.title,
                  amountLabel: p.formattedAmount,
                  status: p.isActive ? 'Active' : 'Inactive',
                ),
            ],
      totalPrize: api.prizes.isEmpty ? null : api.formattedPool,
      winningEventSubtitle:
          (winner != null && winner.distributionModeLabel.isNotEmpty)
          ? winner.distributionModeLabel
          : null,
      teamPrize: winner?.formattedAmount,
    );
  }

  PrizeDetailsInfo _copy(
    PrizeDetailsInfo b, {
    String? tournamentTitle,
    List<PrizeLineItem>? yourPrizes,
    String? totalPrize,
    String? winningEventSubtitle,
    String? teamPrize,
  }) {
    return PrizeDetailsInfo(
      dateLabel: b.dateLabel,
      sport: b.sport,
      tournamentTitle: tournamentTitle ?? b.tournamentTitle,
      eventStatus: b.eventStatus,
      prizeStatus: b.prizeStatus,
      steps: b.steps,
      winningEventTitle: b.winningEventTitle,
      winningEventSubtitle: winningEventSubtitle ?? b.winningEventSubtitle,
      teamPrize: teamPrize ?? b.teamPrize,
      eligiblePlayers: b.eligiblePlayers,
      expectedShare: b.expectedShare,
      creditNote: b.creditNote,
      yourPrizes: yourPrizes ?? b.yourPrizes,
      totalPrize: totalPrize ?? b.totalPrize,
      formulaLabel: b.formulaLabel,
      individualAwardsTotal: b.individualAwardsTotal,
      totalBreakdown: b.totalBreakdown,
      walletTxnNote: b.walletTxnNote,
      eligibleCount: b.eligibleCount,
      yourSlot: b.yourSlot,
      winningTeamName: b.winningTeamName,
      distributionChecks: b.distributionChecks,
      creditTxnId: b.creditTxnId,
      creditedOnLabel: b.creditedOnLabel,
      totalCredited: b.totalCredited,
    );
  }

  void _openCalculation(PrizeDetailsInfo d) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PrizeCalculationScreen(details: d)),
    );
  }

  void _openDistribution(PrizeDetailsInfo d) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PrizeDistributionScreen(details: d)),
    );
  }

  void _openTournament() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            TournamentDetailScreen(tournamentId: widget.tournamentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = _merged();

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prize Details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            d.dateLabel,
                            style: GoogleFonts.quicksand(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mintGreen,
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.mintGreen,
                        backgroundColor: AppColors.secondary,
                        onRefresh: () => _load(refresh: true),
                        child: _buildContent(d),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
    t,
    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
  );

  Widget _buildContent(PrizeDetailsInfo d) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        _LeagueHeader(details: d),
        const SizedBox(height: 18),
        _sectionTitle('Distribution Progress'),
        const SizedBox(height: 10),
        _ProgressCard(steps: d.steps),
        const SizedBox(height: 18),
        _sectionTitle('Winning Team Prize'),
        const SizedBox(height: 10),
        _WinningTeamCard(details: d),
        const SizedBox(height: 18),
        _sectionTitle('Your Prizes'),
        const SizedBox(height: 10),
        for (final line in d.yourPrizes) ...[
          _YourPrizeRow(item: line),
          const SizedBox(height: 10),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total prize',
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                d.totalPrize,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.6,
            child: GestureDetector(
              onTap: () => _openCalculation(d),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE85A6B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE85A6B)),
                ),
                child: Text(
                  'See Prize Calculation',
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFFE85A6B),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _openDistribution(d),
          child: Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.amberAccent),
            ),
            child: Text(
              'Prize Distribution',
              style: GoogleFonts.quicksand(
                color: AppColors.amberAccent,
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _OutlineAction(
                label: 'Tournament Details',
                onTap: _openTournament,
              ),
            ),
            const SizedBox(width: 10),
            // Expanded(
            //   child: _OutlineAction(
            //     label: 'Tournament History',
            //     onTap: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (_) => TeamHistoryScreen(team: dummyMyTeams.first),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help Center coming soon.')),
              );
            },
            child: Text(
              'Need help with this prize?',
              style: GoogleFonts.quicksand(
                color: AppColors.mintGreen,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LeagueHeader extends StatelessWidget {
  const _LeagueHeader({required this.details});

  final PrizeDetailsInfo details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            details.sport,
            style: GoogleFonts.quicksand(
              color: AppColors.amberAccent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            details.tournamentTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusChip(
                label: details.eventStatus,
                color: AppColors.mintGreen,
                icon: Icons.check_circle_outline_rounded,
              ),
              _StatusChip(
                label: details.prizeStatus,
                color: AppColors.infoBlue,
                icon: Icons.access_time_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.quicksand(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.steps});

  final List<PrizeProgressStep> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            _ProgressRow(step: steps[i], isLast: i == steps.length - 1),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.step, required this.isLast});

  final PrizeProgressStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final Color dot;
    Widget inner;
    switch (step.state) {
      case PrizeStepState.done:
        dot = AppColors.mintGreen;
        inner = const Icon(Icons.check, color: Colors.black, size: 12);
      case PrizeStepState.current:
        dot = AppColors.infoBlue;
        inner = Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        );
      case PrizeStepState.pending:
        dot = const Color(0xFF3A4150);
        inner = const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          child: Column(
            children: [
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                child: inner,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 28,
                  color: step.state == PrizeStepState.pending
                      ? const Color(0xFF2A303C)
                      : AppColors.mintGreen.withValues(alpha: 0.45),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: step.state == PrizeStepState.pending
                        ? Colors.white38
                        : Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (step.subtitle.isNotEmpty)
                  Text(
                    step.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: Colors.white54,
                      fontSize: 11.5,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WinningTeamCard extends StatelessWidget {
  const _WinningTeamCard({required this.details});

  final PrizeDetailsInfo details;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: const Color(0xFF161A22),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.amberAccent,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Winning Team',
                    style: GoogleFonts.quicksand(
                      color: AppColors.amberAccent,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF222632),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.sports_cricket_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.winningEventTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          details.winningEventSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF161A22),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            children: [
              _KV(
                label: 'Team Prize',
                value: details.teamPrize,
                valueColor: const Color(0xFFFF8A1E),
              ),
              const SizedBox(height: 10),
              _KV(label: 'Eligible Players', value: details.eligiblePlayers),
              const SizedBox(height: 10),
              _KV(label: 'Your Expected Share', value: details.expectedShare),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            details.creditNote,
            style: GoogleFonts.quicksand(
              color: Colors.white54,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _KV extends StatelessWidget {
  const _KV({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.quicksand(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: valueColor != null ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _YourPrizeRow extends StatelessWidget {
  const _YourPrizeRow({required this.item});

  final PrizeLineItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF222632),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sports_cricket_rounded,
              color: Colors.white70,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.amountLabel,
                  style: GoogleFonts.quicksand(
                    color: AppColors.infoBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.infoBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.infoBlue,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  item.status,
                  style: GoogleFonts.quicksand(
                    color: AppColors.infoBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineAction extends StatelessWidget {
  const _OutlineAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.quicksand(
            color: AppColors.infoBlue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
