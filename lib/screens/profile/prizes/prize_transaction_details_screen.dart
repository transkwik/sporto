import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../core/utils/prize_utils.dart';
import 'package:provider/provider.dart';
import 'prize_status_style.dart';
import 'providers/prize_distribution_provider.dart';
import '../../home/prize_details_screen.dart';

class PrizeTransactionDetailsScreen extends StatefulWidget {
  const PrizeTransactionDetailsScreen({super.key, required this.prize});

  /// Raw payout object from `GET user/prizes/my-prizes`.
  final Map<String, dynamic> prize;

  @override
  State<PrizeTransactionDetailsScreen> createState() => _PrizeTransactionDetailsScreenState();
}

class _PrizeTransactionDetailsScreenState extends State<PrizeTransactionDetailsScreen> {
  int? get _tournamentId => PrizeUtils.tournamentId(widget.prize);

  @override
  void initState() {
    super.initState();
    final id = _tournamentId;
    if (id == null) return;
    final provider = context.read<PrizeDistributionProvider>();
    provider.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) provider.fetchDistribution(id);
    });
  }

  Future<void> _refresh() async {
    final id = _tournamentId;
    if (id == null) return;
    await context.read<PrizeDistributionProvider>().fetchDistribution(id, refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prize;
    final payoutStatus = PrizeUtils.status(p);
    final style = PrizeStatusStyle.of(payoutStatus);
    final statusColor = style.color;
    final tournamentId = PrizeUtils.tournamentId(p);
    final tournamentName = PrizeUtils.tournamentName(p);
    final title = PrizeUtils.title(p);
    final amount = PrizeUtils.formatAmount(p);
    final statusLabel = PrizeUtils.statusLabel(p);
    final categoryLabel = PrizeUtils.categoryLabel(p);
    final typeLabel = PrizeUtils.typeLabel(p);
    final team = PrizeUtils.teamName(p);
    final reference = PrizeUtils.reference(p);
    final listDate = PrizeUtils.listDate(p);
    final detailDate = PrizeUtils.detailDate(p);
    final subtitle = [
      reference,
      if (listDate.isNotEmpty) listDate,
    ].join('  •  ');

    final banner = switch (payoutStatus) {
      PayoutStatus.processing => 'Your payout is being processed.',
      PayoutStatus.pending => 'Your payout is pending. It will be processed soon.',
      PayoutStatus.failed => 'This payout failed. Please contact support if it persists.',
      PayoutStatus.credited => null,
    };

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
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
                            'Transaction Details',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.mintGreen,
                  backgroundColor: AppColors.secondary,
                  onRefresh: _refresh,
                  child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
                      decoration: BoxDecoration(
                        color: style.heroBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xFF141820),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(PrizeUtils.icon(p), color: Colors.white, size: 22),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            amount,
                            style: GoogleFonts.quicksand(
                              color: statusColor,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(style.icon, color: statusColor, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                statusLabel,
                                style: GoogleFonts.quicksand(
                                  color: statusColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Tournament Details',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: tournamentId == null
                          ? null
                          : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PrizeDetailsScreen(
                                    tournamentId: tournamentId,
                                    tournamentName: tournamentName,
                                  ),
                                ),
                              ),
                      child: _Card(
                        child: Row(
                          children: [
                            const Icon(Icons.emoji_events_outlined, color: Colors.white70, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                tournamentName,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (tournamentId != null)
                              const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Prize',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 8),
                    _Card(
                      child: Column(
                        children: [
                          _kv('Prize', title),
                          if (categoryLabel.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _kv('Category', categoryLabel),
                          ],
                          if (typeLabel.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _kv('Type', typeLabel),
                          ],
                          if (team != null) ...[
                            const SizedBox(height: 10),
                            _kv('Team', team),
                          ],
                          const SizedBox(height: 10),
                          _kv('Amount', amount, valueColor: statusColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (banner != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        decoration: BoxDecoration(
                          color: style.heroBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: statusColor.withValues(alpha: 0.45)),
                        ),
                        child: Row(
                          children: [
                            Icon(style.icon, color: statusColor, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                banner,
                                style: GoogleFonts.quicksand(
                                  color: statusColor,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _Card(
                      child: Column(
                        children: [
                          _kv('Status', statusLabel, valueColor: statusColor),
                          const SizedBox(height: 10),
                          _kv('Transaction Ref', reference),
                          if (detailDate.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _kv('Credited On', detailDate),
                          ],
                        ],
                      ),
                    ),
                    if (tournamentId != null) ...[
                      const SizedBox(height: 18),
                      _DistributionSection(
                        tournamentId: tournamentId,
                        prizeId: PrizeUtils.prizeId(p),
                      ),
                    ],
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(
              color: valueColor ?? Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }
}

/// Prize distribution for the tournament (`prize-distribution` API), read from
/// [PrizeDistributionProvider]. [prizeId] marks the award for this payout.
class _DistributionSection extends StatelessWidget {
  const _DistributionSection({required this.tournamentId, required this.prizeId});

  final int tournamentId;
  final int? prizeId;

  static Color _statusColor(String raw) {
    final s = raw.toUpperCase();
    if (s.contains('FAIL') || s.contains('CANCEL')) return const Color(0xFFE85A6B);
    if (s.contains('COMPLETE') || s.contains('DISTRIBUTED') || s.contains('CREDIT') || s == 'PAID') {
      return AppColors.mintGreen;
    }
    if (s.contains('PROGRESS') || s.contains('PROCESS')) return const Color(0xFFFF8A1E);
    return const Color(0xFFE3A93D);
  }

  static String _money(Map row) {
    final amount = PrizeUtils.parseNum(row['amount']) ?? 0;
    final currency = (PrizeUtils.text(row['currency']) ?? 'INR').toUpperCase();
    return PrizeUtils.formatMoney(amount, currency);
  }

  static bool _isMine(Map row) =>
      row['is_me'] == true || row['is_my_team'] == true || row['is_mine'] == true;

  @override
  Widget build(BuildContext context) {
    return Consumer<PrizeDistributionProvider>(
      builder: (context, prov, _) {
        final statusRaw = prov.statusRaw;
        final statusColor = _statusColor(statusRaw);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Prize Distribution',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                  ),
                ),
                if (statusRaw.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      prov.statusLabel,
                      style: GoogleFonts.quicksand(
                        color: statusColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _body(context, prov),
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context, PrizeDistributionProvider prov) {
    if (prov.isLoading && !prov.hasData) {
      return const _Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.mintGreen),
            ),
          ),
        ),
      );
    }

    if (prov.error != null && !prov.hasData) {
      return _Card(
        child: Column(
          children: [
            Text(
              prov.error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => prov.fetchDistribution(tournamentId),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.mintGreen),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.quicksand(
                    color: AppColors.mintGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final team = prov.teamPrizes;
    final individual = prov.individualAwards;

    if (team.isEmpty && individual.isEmpty) {
      return _Card(
        child: Text(
          'Prize distribution has not been published yet.',
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (team.isNotEmpty) ...[
          _groupLabel('Team Prizes (${team.length})'),
          for (final row in team) ...[
            _row(
              title: PrizeUtils.text(row['title']) ?? 'Team Prize',
              subtitle: _teamLabel(row),
              amount: _money(row),
              mine: _isMine(row),
              current: false,
            ),
            const SizedBox(height: 8),
          ],
        ],
        if (individual.isNotEmpty) ...[
          if (team.isNotEmpty) const SizedBox(height: 6),
          _groupLabel('Individual Awards (${individual.length})'),
          for (final row in individual) ...[
            _row(
              title: PrizeUtils.text(row['title']) ?? 'Award',
              subtitle: _playerLabel(row),
              amount: _money(row),
              mine: _isMine(row),
              current: prizeId != null &&
                  int.tryParse(row['prize_id']?.toString() ?? '') == prizeId,
            ),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }

  static String? _teamLabel(Map row) {
    final t = row['team'];
    if (t is Map) return PrizeUtils.text(t['name'] ?? t['team_name']);
    return PrizeUtils.text(row['team_name'] ?? t);
  }

  static String? _playerLabel(Map row) {
    final pl = row['player'];
    final name = pl is Map ? PrizeUtils.text(pl['name']) : PrizeUtils.text(pl);
    if (name != null) return name;
    if (_isMine(row)) return 'You';
    final id = pl is Map ? PrizeUtils.text(pl['id']) : null;
    return id == null ? null : 'Player #$id';
  }

  Widget _groupLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: GoogleFonts.quicksand(
            color: Colors.white70,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  Widget _row({
    required String title,
    required String? subtitle,
    required String amount,
    required bool mine,
    required bool current,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: current ? AppColors.mintGreen : AppColors.glassBorder,
          width: current ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null || mine)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        if (subtitle != null)
                          Flexible(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                            ),
                          ),
                        if (mine && subtitle != 'You') ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'You',
                              style: GoogleFonts.quicksand(
                                color: AppColors.mintGreen,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amount,
            style: GoogleFonts.quicksand(
              color: AppColors.amberAccent,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
