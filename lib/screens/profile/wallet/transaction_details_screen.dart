import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../models/wallet_transaction_info.dart';

/// Wallet list → a single settlement's receipt.
class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key, required this.transaction});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final amountColor = transaction.credit ? AppColors.mintGreen : Colors.white;
    final signedAmount = '${transaction.credit ? '+' : '-'} ${transaction.amountLabel}';

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
                            '${transaction.id}  •  ${transaction.dateLabel}',
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
                            child: Icon(transaction.icon, color: Colors.white, size: 22),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            signedAmount,
                            style: GoogleFonts.quicksand(
                              color: amountColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction.title,
                            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, color: AppColors.mintGreen, size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  transaction.status,
                                  style: GoogleFonts.quicksand(
                                    color: AppColors.mintGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          _MetaRow(label: 'Transaction Ref', value: transaction.id),
                          const SizedBox(height: 10),
                          _MetaRow(label: 'Payment Method', value: transaction.paymentMethod),
                          const SizedBox(height: 10),
                          _MetaRow(label: 'Direction', value: transaction.direction),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Description',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 10),
                    _InfoCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.descriptionTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  transaction.descriptionLine,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            transaction.amountLabel,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Tournament Details',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 10),
                    _InfoCard(
                      child: Row(
                        children: [
                          Icon(transaction.icon, color: Colors.white70, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              transaction.tournamentLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
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
