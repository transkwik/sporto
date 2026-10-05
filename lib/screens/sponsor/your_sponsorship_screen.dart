import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import 'sponsor_format.dart';
import 'sponsorship_identity_screen.dart';
import 'widgets/sponsor_tournament_banner.dart';

/// After covering a category: cart of selected prizes, then review.
class YourSponsorshipScreen extends StatefulWidget {
  const YourSponsorshipScreen({super.key, required this.checkout});

  final SponsorCheckout checkout;

  @override
  State<YourSponsorshipScreen> createState() => _YourSponsorshipScreenState();
}

class _YourSponsorshipScreenState extends State<YourSponsorshipScreen> {
  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);
  static const _cyan = Color(0xFF3ADFA0);

  SponsorCheckout get checkout => widget.checkout;

  void _selectMore() {
    var pops = 0;
    Navigator.of(context).popUntil((_) => pops++ >= 2);
  }

  void _review() {
    if (checkout.selected.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SponsorshipIdentityScreen(checkout: checkout)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = checkout.selected;

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
                      'Your Sponsorship',
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
                    SponsorTournamentBanner(tournament: checkout.tournament),
                    const SizedBox(height: 18),
                    Text(
                      'Your Sponsors',
                      style: GoogleFonts.quicksand(
                        color: _cyan,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (items.isEmpty)
                      Text(
                        'No prize categories selected yet',
                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                      )
                    else
                      for (final item in items) ...[
                        _SelectedRow(
                          category: item,
                          gold: _gold,
                          onRemove: () => setState(() => checkout.remove(item.id)),
                        ),
                        const SizedBox(height: 8),
                      ],
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _selectMore,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A3A28),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _cyan.withValues(alpha: 0.45)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: _cyan, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Select more Sponsor',
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
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Total Amount',
                      style: GoogleFonts.quicksand(
                        color: _cyan,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16120A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _gold.withValues(alpha: 0.45)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Total Sponsorship',
                            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            sponsorRupees(checkout.total),
                            style: GoogleFonts.quicksand(
                              color: _gold,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: _review,
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

class _SelectedRow extends StatelessWidget {
  const _SelectedRow({
    required this.category,
    required this.gold,
    required this.onRemove,
  });

  final SponsorPrizeCategory category;
  final Color gold;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161222),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE85AD4).withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(category.icon, color: gold, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category.label,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            sponsorRupees(category.remaining),
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onRemove,
            child: Text(
              'Remove',
              style: GoogleFonts.quicksand(
                color: const Color(0xFFFF5A5A),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
