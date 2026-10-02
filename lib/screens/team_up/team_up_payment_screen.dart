import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_up_info.dart';
import '../payment/widgets/payment_method_tabs.dart';
import '../payment/widgets/payment_option_tile.dart';
import 'team_up_in_screen.dart';

/// Confirm Registration → Payment Method.
class TeamUpPaymentScreen extends StatefulWidget {
  const TeamUpPaymentScreen({super.key, required this.tournament});

  final TeamUpTournament tournament;

  @override
  State<TeamUpPaymentScreen> createState() => _TeamUpPaymentScreenState();
}

class _TeamUpPaymentScreenState extends State<TeamUpPaymentScreen> {
  int _tabIndex = 1;
  int _selectedOption = 0;
  bool _paying = false;

  int get _total => widget.tournament.entryFee + dummyTeamUpPlatformFee;

  Future<void> _pay() async {
    if (_paying) return;
    setState(() => _paying = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => TeamUpInScreen(tournament: widget.tournament)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tournament;

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
                      'Payment Method',
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
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                  children: [
                    _FeeCard(
                      registrationFee: t.entryFee,
                      platformFee: dummyTeamUpPlatformFee,
                      total: _total,
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
                            'Pay ₹$_total',
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

class _FeeCard extends StatelessWidget {
  const _FeeCard({
    required this.registrationFee,
    required this.platformFee,
    required this.total,
  });

  final int registrationFee;
  final int platformFee;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          _row('Registration Fee', '₹$registrationFee', muted: true),
          const SizedBox(height: 12),
          _row('Platform Fee', '₹$platformFee', muted: true),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF2A2E38), height: 1),
          const SizedBox(height: 14),
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
                '₹$total',
                style: GoogleFonts.quicksand(
                  color: AppColors.amberAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {required bool muted}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            color: Colors.white54,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.quicksand(
            color: muted ? Colors.white70 : Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
