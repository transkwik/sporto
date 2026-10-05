import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import 'digital_sponsor_pass_screen.dart';
import 'sponsor_format.dart';

class SponsorshipConfirmedScreen extends StatelessWidget {
  const SponsorshipConfirmedScreen({super.key, required this.receipt});

  final SponsorReceipt receipt;

  static const _pink = Color(0xFFE85AD4);

  void _home(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _review(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DigitalSponsorPassScreen(receipt: receipt)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = receipt;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GlassBackButton(onTap: () => _home(context)),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
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
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E222C),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Container(
                              width: 56,
                              height: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF5AE07A), Color(0xFF1FA85A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.mintGreen.withValues(alpha: 0.4),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emoji_events_rounded, color: Color(0xFFE3A93D), size: 22),
                              SizedBox(width: 8),
                              Icon(Icons.celebration_rounded, color: Color(0xFFE3A93D), size: 22),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Sponsorship Confirmed!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: 'Your contribution is helping reward the athletes competing in ',
                              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14, height: 1.4),
                              children: [
                                TextSpan(
                                  text: '${r.tournament.title}.',
                                  style: GoogleFonts.quicksand(
                                    color: AppColors.infoBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
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
                          _meta('Total Amount', sponsorRupees(r.total)),
                          const SizedBox(height: 12),
                          _meta('Sponsorship ID', r.id),
                          const SizedBox(height: 12),
                          _meta('Date', r.dateLabel),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => _review(context),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _pink,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: _pink.withValues(alpha: 0.45),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          'Review Sponsorship',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: GestureDetector(
                        onTap: () => _home(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1E28),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.glassBorderStrong),
                          ),
                          child: Text(
                            'Back to Home',
                            style: GoogleFonts.quicksand(
                              color: Colors.white70,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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

  Widget _meta(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
