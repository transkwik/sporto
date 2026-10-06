import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../models/bank_account_info.dart';
import 'add_bank_account_screen.dart';
import 'bank_accounts_list_screen.dart';

/// Profile → Bank Account: verified payout account, or empty state.
class BankAccountScreen extends StatelessWidget {
  const BankAccountScreen({super.key, this.account});

  final BankAccount? account;

  @override
  Widget build(BuildContext context) {
    final store = BankAccountStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final a = account ?? store.selected;
        if (a == null) {
          return const _BankEmptyScaffold();
        }
        return _BankDetailsScaffold(account: a);
      },
    );
  }
}

class _BankEmptyScaffold extends StatelessWidget {
  const _BankEmptyScaffold();

  static const _cyan = Color(0xFF3ADFA0);

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: ListView(
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AddBankAccountScreen()),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BankDetailsScaffold extends StatelessWidget {
  const _BankDetailsScaffold({required this.account});

  final BankAccount account;

  static const _cyan = Color(0xFF3ADFA0);

  @override
  Widget build(BuildContext context) {
    final a = account;

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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                a.maskedLast4Display,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.radio_button_checked, color: Colors.white38, size: 16),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF143024),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: _cyan, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Verified',
                                      style: GoogleFonts.quicksand(
                                        color: _cyan,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _kv('Bank', a.bankName),
                          const SizedBox(height: 10),
                          _kv('IFSC', a.ifsc),
                          const SizedBox(height: 10),
                          _kv('Account holder', a.holderName),
                          const SizedBox(height: 10),
                          _kv('UPI ID', a.upiId),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _GhostAction(
                            icon: Icons.add,
                            label: 'Add Bank Account',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AddBankAccountScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _GhostAction(
                            icon: Icons.check_circle_outline,
                            label: 'Change Bank Account',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const BankAccountsListScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _GhostAction(
                      icon: Icons.verified_outlined,
                      label: 'Re-verify Bank Account',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Bank account re-verified',
                              style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      },
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

  Widget _kv(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _GhostAction extends StatelessWidget {
  const _GhostAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorderStrong),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
