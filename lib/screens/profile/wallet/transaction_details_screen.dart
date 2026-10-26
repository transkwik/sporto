import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/wallet_utils.dart';
import '../../../core/widgets/glass_back_button.dart';

/// Wallet list → a single wallet transaction's receipt. [transaction] is the
/// raw object from `GET user/wallet/transactions`.
class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key, required this.transaction});

  final Map<String, dynamic> transaction;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final accent = WalletUtils.accent(t);
    final amountColor = WalletUtils.amountColor(t);
    final directionLabel = WalletUtils.directionLabel(t);
    final isCredit = WalletUtils.isCredit(t);
    final description = WalletUtils.description(t);
    final typeLabel = WalletUtils.typeLabel(t);
    final listDate = WalletUtils.listDate(t);
    final detailDate = WalletUtils.detailDate(t);
    final headerSubtitle = [
      WalletUtils.reference(t),
      if (listDate.isNotEmpty) listDate,
    ].join('  •  ');

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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            headerSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1E28),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassBorder),
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
                            child: Icon(WalletUtils.icon(t), color: Colors.white, size: 22),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            WalletUtils.signedAmount(t),
                            style: GoogleFonts.quicksand(
                              color: amountColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            WalletUtils.title(t),
                            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
                          ),
                          if (directionLabel.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isCredit == false
                                        ? Icons.arrow_circle_up_rounded
                                        : Icons.arrow_circle_down_rounded,
                                    color: accent,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    directionLabel,
                                    style: GoogleFonts.quicksand(
                                      color: accent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),
                          _MetaRow(label: 'Transaction Ref', value: WalletUtils.reference(t)),
                          if (typeLabel.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _MetaRow(label: 'Type', value: typeLabel),
                          ],
                          if (directionLabel.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _MetaRow(label: 'Direction', value: directionLabel),
                          ],
                          if (detailDate.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _MetaRow(label: 'Date', value: detailDate),
                          ],
                        ],
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Description',
                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                      ),
                      const SizedBox(height: 10),
                      _InfoCard(
                        child: Row(
                          children: [
                            Icon(WalletUtils.icon(t), color: Colors.white70, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                description,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              WalletUtils.amountLabel(t),
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
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

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }
}
