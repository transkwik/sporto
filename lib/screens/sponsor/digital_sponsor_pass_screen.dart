import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import 'my_sponsorships_screen.dart';
import 'sponsor_format.dart';

class DigitalSponsorPassScreen extends StatelessWidget {
  const DigitalSponsorPassScreen({super.key, required this.receipt});

  final SponsorReceipt receipt;

  static const _gold = Color(0xFFE3A93D);

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.quicksand(fontWeight: FontWeight.w600))),
    );
  }

  void _viewList(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MySponsorshipsScreen(highlight: receipt)),
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
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Text(
                      'Digital Sponsor Pass',
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                            color: _gold,
                            child: Row(
                              children: [
                                const Icon(Icons.emoji_events_rounded, color: Colors.black87, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'SPOTO',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF4A1C58), Color(0xFF2A1038)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tournament Sponsor',
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r.tournament.title,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  r.tournament.sport,
                                  style: GoogleFonts.quicksand(
                                    color: AppColors.mintGreen,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Sponsor',
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  r.sponsorName,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
                                const SizedBox(height: 14),
                                Text(
                                  'Supported',
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                                ),
                                const SizedBox(height: 8),
                                for (final item in r.displayLines) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        Icon(item.icon, color: _gold, size: 16),
                                        const SizedBox(width: 8),
                                        Text(
                                          item.label,
                                          style: GoogleFonts.quicksand(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Text(
                                  'Contribution',
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      sponsorRupees(r.total),
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      r.id,
                                      style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _GhostButton(
                            label: 'Share',
                            onTap: () => _toast(context, 'Share is not available yet'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _GhostButton(
                            label: 'Download',
                            onTap: () => _toast(context, 'Download is not available yet'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: GestureDetector(
                        onTap: () => _viewList(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1E28),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.glassBorderStrong),
                          ),
                          child: Text(
                            'View My Sponsorships  →',
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
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorderStrong),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            color: Colors.white70,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
