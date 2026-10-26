import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import 'bank_actions.dart';
import 'bank_card.dart';
import 'providers/bank_provider.dart';

/// Profile → Bank Account: every saved account as a card. The radio on a card
/// sets it as the default; the default card is highlighted (`is_default`).
class BankAccountScreen extends StatefulWidget {
  const BankAccountScreen({super.key});

  @override
  State<BankAccountScreen> createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  static const _cyan = Color(0xFF3ADFA0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final p = context.read<BankProvider>();
      p.reset();
      p.fetchBanks();
    });
  }

  Future<void> _refresh() =>
      context.read<BankProvider>().fetchBanks(refresh: true);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();
    final accounts = provider.accounts;

    Widget body;
    if (provider.isLoading && accounts.isEmpty) {
      body = const Center(
        child: CircularProgressIndicator(color: AppColors.mintGreen),
      );
    } else if (provider.error != null && accounts.isEmpty) {
      body = BankActions.errorView(
        message: provider.error!,
        onRetry: () => provider.fetchBanks(),
      );
    } else {
      body = RefreshIndicator(
        color: AppColors.mintGreen,
        backgroundColor: AppColors.secondary,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: accounts.isEmpty
              ? _emptyChildren()
              : [
                  _Header(count: accounts.length),
                  const SizedBox(height: 14),
                  for (final account in accounts) ...[
                    BankCard(account: account),
                    const SizedBox(height: 12),
                  ],
                ],
        ),
      );
    }

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
                    Text(
                      'Bank Account',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _emptyChildren() {
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1418),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE85A6B).withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFE85A6B),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'No Bank Found! Please add your bank account.',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 13.5,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
        decoration: BoxDecoration(
          color: const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFF2A241C),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No Bank Account',
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Please Add Your Bank Account',
              style: GoogleFonts.quicksand(
                color: _cyan,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      GestureDetector(
        onTap: () => BankActions.openAdd(context),
        child: Container(
          width: double.infinity,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: AppColors.bannerGradient,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8A1E).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                'Add Bank',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});

  final int count;

  static const _cyan = Color(0xFF3ADFA0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121A18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cyan.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              count == 1 ? '1 Bank Account' : '$count Bank Accounts',
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => BankActions.openAdd(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _cyan.withValues(alpha: 0.55)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add, color: _cyan, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Add bank',
                    style: GoogleFonts.quicksand(
                      color: _cyan,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
