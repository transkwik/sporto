import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/wallet_utils.dart';
import '../../../core/widgets/glass_back_button.dart';
import 'providers/wallet_provider.dart';
import 'transaction_details_screen.dart';
import '../bank/withdraw_to_bank_screen.dart';

/// Profile → Wallet & Transactions: balance, history actions, settlements.
class WalletTransactionsScreen extends StatefulWidget {
  const WalletTransactionsScreen({super.key});

  @override
  State<WalletTransactionsScreen> createState() => _WalletTransactionsScreenState();
}

class _WalletTransactionsScreenState extends State<WalletTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<WalletProvider>();
    provider.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) provider.fetchWallet();
    });
  }

  void _openDetails(BuildContext context, Map<String, dynamic> txn) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TransactionDetailsScreen(transaction: txn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Wallet & Transactions',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<WalletProvider>(
                  builder: (context, prov, _) {
                    if (prov.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.mintGreen),
                      );
                    }
                    if (prov.error != null) {
                      return _MessageView(
                        message: prov.error!,
                        onRetry: prov.fetchWallet,
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.mintGreen,
                      backgroundColor: AppColors.secondary,
                      onRefresh: () => prov.fetchWallet(refresh: true),
                      child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
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
                                  'Wallet balance',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  prov.balanceLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
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
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionChip(
                            label: 'Transaction History',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionChip(
                            icon: Icons.download_rounded,
                            label: 'Download Statement',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Statement download coming soon.')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Recent Settlements',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 12),
                    if (prov.transactions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            const Icon(Icons.receipt_long_outlined, color: Colors.white24, size: 44),
                            const SizedBox(height: 10),
                            Text(
                              'No transactions yet',
                              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    else
                      for (final txn in prov.transactions) ...[
                        _SettlementRow(
                          transaction: txn,
                          onTap: () => _openDetails(context, txn),
                        ),
                        const SizedBox(height: 10),
                      ],
                  ],
                ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E28),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettlementRow extends StatelessWidget {
  const _SettlementRow({required this.transaction, required this.onTap});

  final Map<String, dynamic> transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final amountColor = WalletUtils.amountColor(t);
    final description = WalletUtils.description(t);
    final date = WalletUtils.listDate(t);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1E28),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 3, color: WalletUtils.accent(t)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF141820),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(WalletUtils.icon(t), color: Colors.white70, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                WalletUtils.title(t),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (description.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              WalletUtils.signedAmount(t),
                              style: GoogleFonts.quicksand(
                                color: amountColor,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (date.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                date,
                                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, color: Colors.white38, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3A93D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
