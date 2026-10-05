import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/prize_payout_info.dart';
import 'prize_transaction_details_screen.dart';
import 'withdraw_to_bank_screen.dart';

class MyPrizesScreen extends StatefulWidget {
  const MyPrizesScreen({super.key, this.prizes = dummyPrizePayouts});

  final List<PrizePayout> prizes;

  @override
  State<MyPrizesScreen> createState() => _MyPrizesScreenState();
}

class _MyPrizesScreenState extends State<MyPrizesScreen> {
  int _filter = 0;

  static final _inr = NumberFormat.decimalPattern('en_IN');

  int get _processing => widget.prizes.where((p) => p.status == PrizePayoutStatus.processing).length;
  int get _credited => widget.prizes.where((p) => p.status == PrizePayoutStatus.credited).length;

  List<PrizePayout> get _visible {
    switch (_filter) {
      case 1:
        return widget.prizes.where((p) => p.status == PrizePayoutStatus.processing).toList();
      case 2:
        return widget.prizes.where((p) => p.status == PrizePayoutStatus.credited).toList();
      case 3:
        return widget.prizes.where((p) => p.status == PrizePayoutStatus.failed).toList();
      default:
        return widget.prizes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    final chips = [
      ('All (${widget.prizes.length})', false),
      ('Processing ($_processing)', false),
      ('Credited ($_credited)', false),
      ('Failed', true),
    ];

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
                    Text(
                      'My Prizes',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3A93D),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Earned',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dummyPrizesTotalEarned,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const WithdrawToBankScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2410),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Withdraw to bank',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            value: '$dummyPrizesTournamentWins',
                            label: 'Tournament\nWins',
                            valueColor: const Color(0xFFE3A93D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatTile(
                            value: '$dummyPrizesIndividualAwards',
                            label: 'Individual\nAwards',
                            valueColor: const Color(0xFFE85AD4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatTile(
                            value: dummyPrizesPending,
                            label: 'Pending',
                            valueColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: chips.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final (label, failedLook) = chips[index];
                          final selected = _filter == index;
                          final Color bg;
                          final Color fg;
                          if (selected && failedLook) {
                            bg = const Color(0xFFE85A6B);
                            fg = Colors.white;
                          } else if (selected) {
                            bg = const Color(0xFFE3A93D);
                            fg = Colors.black87;
                          } else {
                            bg = const Color(0xFF1A1E28);
                            fg = Colors.white70;
                          }
                          return GestureDetector(
                            onTap: () => setState(() => _filter = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(18),
                                border: selected ? null : Border.all(color: AppColors.glassBorder),
                              ),
                              child: Text(
                                label,
                                style: GoogleFonts.quicksand(
                                  color: fg,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    for (final prize in items) ...[
                      _PrizeRow(
                        prize: prize,
                        rupees: (v) => '₹${_inr.format(v)}',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PrizeTransactionDetailsScreen(prize: prize),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.quicksand(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5, height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _PrizeRow extends StatelessWidget {
  const _PrizeRow({
    required this.prize,
    required this.rupees,
    required this.onTap,
  });

  final PrizePayout prize;
  final String Function(int) rupees;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor, amountColor) = switch (prize.status) {
      PrizePayoutStatus.processing => ('Processing', const Color(0xFFFF8A1E), const Color(0xFFFF8A1E)),
      PrizePayoutStatus.credited => ('Credited', AppColors.mintGreen, AppColors.mintGreen),
      PrizePayoutStatus.failed => ('Failed', const Color(0xFFE85A6B), const Color(0xFFE85A6B)),
    };
    final statusIcon = switch (prize.status) {
      PrizePayoutStatus.processing => Icons.schedule_rounded,
      PrizePayoutStatus.credited => Icons.check_circle,
      PrizePayoutStatus.failed => Icons.error_outline_rounded,
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(prize.sportIcon, color: Colors.white70, size: 15),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    prize.tournament,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12.5),
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
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF141820),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(prize.prizeIcon, color: Colors.white70, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prize.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 13),
                          const SizedBox(width: 4),
                          Text(
                            statusLabel,
                            style: GoogleFonts.quicksand(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rupees(prize.netAmount),
                      style: GoogleFonts.quicksand(
                        color: amountColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      prize.listDate,
                      style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
