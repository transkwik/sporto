import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../models/bank_account_info.dart';
import 'add_bank_account_screen.dart';

/// Change bank: list of saved accounts.
class BankAccountsListScreen extends StatelessWidget {
  const BankAccountsListScreen({super.key});

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

              return Column(
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
                    child: accounts.isEmpty
                        ? const SizedBox.shrink()
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
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => const AddBankAccountScreen()),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: _cyan.withValues(alpha: 0.55)),
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
                                GestureDetector(
                                  onTap: () {
                                    store.select(account.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF161A22),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(color: AppColors.glassBorder),
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
                                                'Account Name: ${account.holderName}',
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
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
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
}
