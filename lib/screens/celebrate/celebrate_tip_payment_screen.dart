import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/celebrate_info.dart';
import '../payment/widgets/payment_method_tabs.dart';
import '../payment/widgets/payment_option_tile.dart';
import 'celebrate_tip_success_screen.dart';
import 'widgets/celebrate_tip_summary.dart';

class CelebrateTipPaymentScreen extends StatefulWidget {
  const CelebrateTipPaymentScreen({super.key, required this.draft});

  final CelebrateTipDraft draft;

  @override
  State<CelebrateTipPaymentScreen> createState() => _CelebrateTipPaymentScreenState();
}

class _CelebrateTipPaymentScreenState extends State<CelebrateTipPaymentScreen> {
  int _tabIndex = 1;
  int _selectedOption = 0;
  bool _paying = false;

  Future<void> _pay() async {
    if (_paying) return;
    setState(() => _paying = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CelebrateTipSuccessScreen(draft: widget.draft),
      ),
    );
    setState(() => _paying = false);
  }

  @override
  Widget build(BuildContext context) {
    final amount = widget.draft.amount;

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
                      'Tips Payment',
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  children: [
                    CelebrateTournamentBanner(campaign: widget.draft.campaign),
                    const SizedBox(height: 12),
                    CelebrateTipSummaryCard(draft: widget.draft),
                    const SizedBox(height: 22),
                    Text(
                      'Select Your Payment Method',
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    PaymentMethodTabs(
                      selectedIndex: _tabIndex,
                      onSelect: (i) => setState(() => _tabIndex = i),
                    ),
                    const SizedBox(height: 18),
                    PaymentOptionTile(
                      label: 'G Pay',
                      selected: _selectedOption == 0,
                      onTap: () => setState(() => _selectedOption = 0),
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(
                      label: 'Add UPI',
                      trailing: PaymentOptionTrailing.add,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(
                      label: 'Add New Wallet',
                      trailing: PaymentOptionTrailing.add,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GestureDetector(
                  onTap: _pay,
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
                    child: _paying
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Pay ₹$amount',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
