import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/bank_account_info.dart';
import 'add_bank_account_screen.dart';
import 'bank_account_screen.dart';

/// Wallet → Withdraw to bank: pick a payout account or add one.
class WithdrawToBankScreen extends StatelessWidget {
  const WithdrawToBankScreen({super.key});

  static const _cyan = Color(0xFF3ADFA0);

  @override
  Widget build(BuildContext context) {
    final store = BankAccountStore.instance;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              final accounts = store.accounts;
              final selected = store.selected;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        GlassBackButton(onTap: () => Navigator.of(context).pop()),
                        const SizedBox(width: 10),
                        Text(
                          'Withdraw to bank',
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
                    child: accounts.isEmpty
                        ? _EmptyState(
                            onAdd: () => _openAdd(context),
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF121A18),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: _cyan.withValues(alpha: 0.35)),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${accounts.length} Banks Accounts',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => _openAdd(context),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: _cyan.withValues(alpha: 0.55), style: BorderStyle.solid),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.add, color: _cyan, size: 16),
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
                              ),
                              const SizedBox(height: 14),
                              for (final account in accounts) ...[
                                _BankTile(
                                  account: account,
                                  selected: account.id == selected?.id,
                                  onTap: () {
                                    if (account.id == selected?.id) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => BankAccountScreen(account: account),
                                        ),
                                      );
                                    } else {
                                      store.select(account.id);
                                    }
                                  },
                                  onOpenDetails: () {
                                    store.select(account.id);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => BankAccountScreen(account: account),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                              const SizedBox(height: 18),
                              GestureDetector(
                                onTap: selected == null
                                    ? null
                                    : () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Withdrawal to ${selected.shortLabel} requested',
                                              style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        );
                                      },
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
                                  child: Text(
                                    'Withdraw to ${selected?.shortLabel ?? 'bank'}',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _openAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddBankAccountScreen()),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1418),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE85A6B).withValues(alpha: 0.45)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline_rounded, color: Color(0xFFE85A6B), size: 20),
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
        const SizedBox(height: 18),
        GestureDetector(
          onTap: onAdd,
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
      ],
    );
  }
}

class _BankTile extends StatelessWidget {
  const _BankTile({
    required this.account,
    required this.selected,
    required this.onTap,
    required this.onOpenDetails,
  });

  final BankAccount account;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onOpenDetails;

  static const _cyan = Color(0xFF3ADFA0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onOpenDetails,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF121A18) : const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? _cyan.withValues(alpha: 0.55) : AppColors.glassBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: account.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                account.mark,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.bankName,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Account Holder Name: ${account.holderName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                  ),
                  Text(
                    'A/c ${account.maskedMid}',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (selected)
              Row(
                children: [
                  Icon(Icons.check_circle, color: _cyan, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Selected',
                    style: GoogleFonts.quicksand(
                      color: _cyan,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
