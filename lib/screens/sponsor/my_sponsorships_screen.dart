import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import '../profile/bank/withdraw_to_bank_screen.dart';
import 'my_sponsor_details_screen.dart';
import 'sponsor_format.dart';

class MySponsorshipsScreen extends StatefulWidget {
  MySponsorshipsScreen({super.key, this.highlight, List<SponsorReceipt>? receipts})
      : receipts = receipts ?? dummySponsorReceipts;

  final SponsorReceipt? highlight;
  final List<SponsorReceipt> receipts;

  @override
  State<MySponsorshipsScreen> createState() => _MySponsorshipsScreenState();
}

class _MySponsorshipsScreenState extends State<MySponsorshipsScreen> {
  int _filter = 0;
  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);

  List<SponsorReceipt> get _all {
    final receipts = widget.receipts;
    if (widget.highlight == null) return receipts;
    if (receipts.any((r) => r.id == widget.highlight!.id)) return receipts;
    return [widget.highlight!, ...receipts];
  }

  int get _activeCount => _all.where((r) => r.status == SponsorshipRecordStatus.active).length;
  int get _completedCount => _all.where((r) => r.status == SponsorshipRecordStatus.completed).length;
  int get _refundedCount => _all.where((r) => r.status == SponsorshipRecordStatus.refunded).length;

  List<SponsorReceipt> get _visible {
    switch (_filter) {
      case 1:
        return _all.where((r) => r.status == SponsorshipRecordStatus.active).toList();
      case 2:
        return _all.where((r) => r.status == SponsorshipRecordStatus.completed).toList();
      case 3:
        return _all.where((r) => r.status == SponsorshipRecordStatus.refunded).toList();
      default:
        return _all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;
    final chips = [
      'All (${_all.length})',
      'Active ($_activeCount)',
      'Completed ($_completedCount)',
      'Refunded ($_refundedCount)',
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
                      'My Sponsorships',
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
                        color: _pink,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Sponsored',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dummySponsorHistoryStats.totalLabel,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
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
                                color: Colors.white.withValues(alpha: 0.18),
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
                            value: '${dummySponsorHistoryStats.tournamentsSponsored}',
                            label: 'Tournaments\nSponsored',
                            valueColor: _gold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatTile(
                            value: '${dummySponsorHistoryStats.categoriesSupported}',
                            label: 'Categories\nSupported',
                            valueColor: _pink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatTile(
                            value: dummySponsorHistoryStats.refundedLabel,
                            label: 'Refunded',
                            valueColor: const Color(0xFFE85A6B),
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
                          final selected = _filter == index;
                          return GestureDetector(
                            onTap: () => setState(() => _filter = index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected ? _gold : const Color(0xFF1A1E28),
                                borderRadius: BorderRadius.circular(18),
                                border: selected ? null : Border.all(color: AppColors.glassBorder),
                              ),
                              child: Text(
                                chips[index],
                                style: GoogleFonts.quicksand(
                                  color: selected ? Colors.black87 : Colors.white70,
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
                    for (final receipt in items) ...[
                      _HistoryCard(
                        receipt: receipt,
                        gold: _gold,
                        onDetails: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MySponsorDetailsScreen(receipt: receipt),
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

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.receipt,
    required this.gold,
    required this.onDetails,
  });

  final SponsorReceipt receipt;
  final Color gold;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final (label, color, bg, border, icon) = switch (receipt.status) {
      SponsorshipRecordStatus.active => (
          'Active',
          gold,
          const Color(0xFF1A160C),
          gold.withValues(alpha: 0.4),
          Icons.circle,
        ),
      SponsorshipRecordStatus.completed => (
          'Completed',
          AppColors.mintGreen,
          const Color(0xFF121A16),
          AppColors.mintGreen.withValues(alpha: 0.35),
          Icons.check_circle,
        ),
      SponsorshipRecordStatus.refunded => (
          'Refunded',
          const Color(0xFFE85A6B),
          const Color(0xFF2A1418),
          const Color(0xFFE85A6B).withValues(alpha: 0.4),
          Icons.error_outline_rounded,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: receipt.status == SponsorshipRecordStatus.active ? 10 : 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.quicksand(
                  color: color,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                receipt.listDate,
                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(receipt.tournament.sportIcon, color: Colors.white70, size: 15),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  receipt.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              for (final line in receipt.displayLines)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(line.icon, color: gold, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      line.label,
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sponsorRupees(receipt.total),
                      style: GoogleFonts.quicksand(
                        color: gold,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      receipt.id,
                      style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onDetails,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1E28),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorderStrong),
                  ),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
