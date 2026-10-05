import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import '../auth/providers/auth_provider.dart';
import 'sponsorship_payment_screen.dart';
import 'widgets/sponsor_tournament_banner.dart';

/// Review → how the sponsorship is shown publicly, then dummy payment.
class SponsorshipIdentityScreen extends StatefulWidget {
  const SponsorshipIdentityScreen({super.key, required this.checkout});

  final SponsorCheckout checkout;

  @override
  State<SponsorshipIdentityScreen> createState() => _SponsorshipIdentityScreenState();
}

class _SponsorshipIdentityScreenState extends State<SponsorshipIdentityScreen> {
  String _displayName = 'Zoto';
  String _handle = '@zoto';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.read<AuthProvider>().checkResponse?['user']?['profile'] ?? {};
    final name = (profile['full_name'] as String?)?.trim();
    if (name != null && name.isNotEmpty) {
      _displayName = name.split(' ').first;
      _handle = '@${_displayName.toLowerCase()}';
    }
    final username = (profile['username'] as String?)?.trim();
    if (username != null && username.isNotEmpty) {
      _handle = username.startsWith('@') ? username : '@$username';
    }
  }

  void _continue() {
    final checkout = widget.checkout;
    switch (checkout.identity) {
      case SponsorIdentityKind.name:
        checkout.sponsorName = _displayName;
      case SponsorIdentityKind.profile:
        checkout.sponsorName = _handle;
      case SponsorIdentityKind.brand:
        checkout.sponsorName = 'Brand Sponsor';
      case SponsorIdentityKind.anonymous:
        checkout.sponsorName = 'Anonymous';
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SponsorshipPaymentScreen(checkout: checkout)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkout = widget.checkout;
    final kind = checkout.identity;

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
                      'Sponsorship Identity',
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    SponsorTournamentBanner(tournament: checkout.tournament),
                    const SizedBox(height: 22),
                    Text(
                      'How should we display your sponsorship?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _IdentityOption(
                      selected: kind == SponsorIdentityKind.name,
                      title: 'Show My Name',
                      subtitle: 'Displayed as "Sponsored by $_displayName"',
                      onTap: () => setState(() => checkout.identity = SponsorIdentityKind.name),
                    ),
                    const SizedBox(height: 10),
                    _IdentityOption(
                      selected: kind == SponsorIdentityKind.profile,
                      title: 'Show My Profile Name',
                      subtitle: 'Displayed as "Sponsored by $_handle"',
                      onTap: () => setState(() => checkout.identity = SponsorIdentityKind.profile),
                    ),
                    const SizedBox(height: 10),
                    _IdentityOption(
                      selected: kind == SponsorIdentityKind.brand,
                      title: 'Sponsor as a Brand',
                      subtitle: 'Upload a logo and brand name',
                      onTap: () => setState(() => checkout.identity = SponsorIdentityKind.brand),
                    ),
                    const SizedBox(height: 10),
                    _IdentityOption(
                      selected: kind == SponsorIdentityKind.anonymous,
                      title: 'Sponsor Anonymously',
                      subtitle: 'No name shown publicly',
                      onTap: () => setState(() => checkout.identity = SponsorIdentityKind.anonymous),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Text(
                        'Your sponsorship supports tournament prize money and athlete recognition - it is a contribution, not an investment, purchase, or financial return.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          color: Colors.white54,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: _continue,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: AppColors.bannerGradient,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8A1E).withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          'Continue to Payment',
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

class _IdentityOption extends StatelessWidget {
  const _IdentityOption({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  static const _gold = Color(0xFFE3A93D);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF241C0C) : const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? _gold.withValues(alpha: 0.7) : AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _gold : Colors.transparent,
                border: selected ? null : Border.all(color: Colors.white38, width: 1.5),
              ),
              child: selected ? const Icon(Icons.check_rounded, color: Colors.black87, size: 14) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
