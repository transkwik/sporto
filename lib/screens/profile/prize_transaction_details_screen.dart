import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/prize_payout_info.dart';

class PrizeTransactionDetailsScreen extends StatelessWidget {
  const PrizeTransactionDetailsScreen({super.key, required this.prize});

  final PrizePayout prize;

  static final _inr = NumberFormat.decimalPattern('en_IN');
  String _rupees(int value) => '₹${_inr.format(value)}';

  @override
  Widget build(BuildContext context) {
    final p = prize;
    final (statusLabel, statusColor, heroBg, heroBorder, amountColor) = switch (p.status) {
      PrizePayoutStatus.credited => (
          'Credited',
          AppColors.mintGreen,
          const Color(0xFF12241C),
          AppColors.mintGreen.withValues(alpha: 0.35),
          AppColors.mintGreen,
        ),
      PrizePayoutStatus.failed => (
          'Failed',
          const Color(0xFFE85A6B),
          const Color(0xFF2A1418),
          const Color(0xFFE85A6B).withValues(alpha: 0.35),
          const Color(0xFFE85A6B),
        ),
      PrizePayoutStatus.processing => (
          'Processing',
          const Color(0xFFFF8A1E),
          const Color(0xFF2A1A0C),
          const Color(0xFFFF8A1E).withValues(alpha: 0.4),
          const Color(0xFFFF8A1E),
        ),
    };
    final statusIcon = switch (p.status) {
      PrizePayoutStatus.credited => Icons.check_circle,
      PrizePayoutStatus.failed => Icons.error_outline_rounded,
      PrizePayoutStatus.processing => Icons.schedule_rounded,
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
                            '${p.txnId}  •  ${p.listDate}',
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
                      decoration: BoxDecoration(
                        color: heroBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: heroBorder),
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
                            child: Icon(p.sportIcon, color: Colors.white, size: 22),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _rupees(p.netAmount),
                            style: GoogleFonts.quicksand(
                              color: amountColor,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p.title,
                            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(statusIcon, color: statusColor, size: 14),
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Row(
                        children: [
                          Icon(p.sportIcon, color: Colors.white70, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              p.tournament,
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Description',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 8),
                    _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.descriptionTitle,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _kv('Awarded To', p.awardedTo),
                          const SizedBox(height: 10),
                          _kv('Team', p.teamName),
                          const SizedBox(height: 10),
                          _kv('Prize', _rupees(p.grossAmount)),
                          const SizedBox(height: 10),
                          _kv('Awarded By', p.awardedBy, note: p.awardedByNote),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _Card(
                      child: Column(
                        children: [
                          _kv('Prize', _rupees(p.grossAmount)),
                          const SizedBox(height: 10),
                          _kv('Platform Fee (10%)', '- ${_rupees(p.feeAmount)}'),
                          const SizedBox(height: 10),
                          _kv('Net Amount', _rupees(p.netAmount), valueColor: amountColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (p.status == PrizePayoutStatus.processing)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A1A0C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFF8A1E).withValues(alpha: 0.45)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule_rounded, color: Color(0xFFFF8A1E), size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Payment in Processing',
                              style: GoogleFonts.quicksand(
                                color: const Color(0xFFFF8A1E),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _rupees(p.netAmount),
                              style: GoogleFonts.quicksand(
                                color: const Color(0xFFFF8A1E),
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      _Card(
                        child: Column(
                          children: [
                            _kv('Status', statusLabel, valueColor: statusColor),
                            if (p.paymentMethod != null) ...[
                              const SizedBox(height: 10),
                              _kv('Payment Method', p.paymentMethod!),
                            ],
                            const SizedBox(height: 10),
                            _kv('Transaction Ref', p.txnId),
                            const SizedBox(height: 10),
                            _kv('Date', p.detailDate),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String label, String value, {String? note, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
        ),
        const Spacer(),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                textAlign: TextAlign.right,
                style: GoogleFonts.quicksand(
                  color: valueColor ?? Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (note != null)
                Text(
                  note,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5),
                ),
            ],
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
