import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import 'sponsor_format.dart';
import 'your_sponsorship_screen.dart';

/// Category CTA → cover the remaining prize amount in full.
class SponsorDetailsScreen extends StatelessWidget {
  const SponsorDetailsScreen({
    super.key,
    required this.checkout,
    required this.category,
  });

  final SponsorCheckout checkout;
  final SponsorPrizeCategory category;

  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);
  static const _orange = Color(0xFFFF8A1E);

  void _sponsorFull(BuildContext context) {
    checkout.upsert(category);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => YourSponsorshipScreen(checkout: checkout)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = checkout.tournament;
    final remaining = category.remaining;

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
                            'Sponsor Details',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            t.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            value: sponsorCompact(t.prizePoolValue),
                            label: 'Prize Pool',
                            valueColor: _pink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatTile(
                            value: sponsorCompact(t.raised),
                            label: 'Sponsored',
                            valueColor: _gold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatTile(
                            value: sponsorCompact(t.remaining),
                            label: 'Remaining',
                            valueColor: _orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161222),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _pink.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            sponsorRupees(remaining),
                            style: GoogleFonts.quicksand(
                              color: _pink,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sponsorship Amount',
                            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "You're covering the entire remaining balance for",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13, height: 1.35),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(category.icon, color: _gold, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                category.label,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Text.rich(
                        TextSpan(
                          style: GoogleFonts.quicksand(
                            color: Colors.white70,
                            fontSize: 13.5,
                            height: 1.45,
                          ),
                          children: [
                            const TextSpan(text: 'Spoto sponsorships fund a prize category in full - this completes '),
                            TextSpan(
                              text: "${category.label}'s prize money",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                height: 1.45,
                              ),
                            ),
                            const TextSpan(text: ' for '),
                            TextSpan(
                              text: '${t.title}.',
                              style: GoogleFonts.quicksand(
                                color: AppColors.infoBlue,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => _sponsorFull(context),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Sponsor Full ${sponsorRupees(remaining)}',
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

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF16120A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3A93D).withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              color: valueColor,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
