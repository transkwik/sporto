import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import '../payment/widgets/payment_method_tabs.dart';
import '../payment/widgets/payment_option_tile.dart';
import 'sponsor_format.dart';
import 'sponsorship_confirmed_screen.dart';
import 'widgets/sponsor_tournament_banner.dart';

class SponsorshipPaymentScreen extends StatefulWidget {
  const SponsorshipPaymentScreen({super.key, required this.checkout});

  final SponsorCheckout checkout;

  @override
  State<SponsorshipPaymentScreen> createState() => _SponsorshipPaymentScreenState();
}

class _SponsorshipPaymentScreenState extends State<SponsorshipPaymentScreen> {
  static const _gold = Color(0xFFE3A93D);

  int _tabIndex = 0;
  int _selectedOption = 0;
  bool _paying = false;

  Future<void> _pay() async {
    if (_paying) return;
    setState(() => _paying = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final receipt = widget.checkout.toReceipt();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => SponsorshipConfirmedScreen(receipt: receipt)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkout = widget.checkout;
    final amount = checkout.total;

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
                      'Sponsorship Payment',
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
                    SponsorTournamentBanner(tournament: checkout.tournament),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          for (final item in checkout.selected) ...[
                            Row(
                              children: [
                                Icon(item.icon, color: _gold, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  sponsorRupees(item.remaining),
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          Row(
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                sponsorRupees(amount),
                                style: GoogleFonts.quicksand(
                                  color: _gold,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                            'Sponsor ${sponsorRupees(amount)}',
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
