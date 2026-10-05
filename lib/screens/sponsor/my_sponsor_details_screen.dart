import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import 'digital_sponsor_pass_screen.dart';
import 'sponsor_format.dart';
import 'sponsorship_screen.dart';

class MySponsorDetailsScreen extends StatelessWidget {
  const MySponsorDetailsScreen({super.key, required this.receipt});

  final SponsorReceipt receipt;

  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);

  void _help(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Support is not available yet', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = receipt;
    final isRefunded = r.status == SponsorshipRecordStatus.refunded;
    final isActive = r.status == SponsorshipRecordStatus.active;
    final (statusLabel, statusColor, statusIcon) = switch (r.status) {
      SponsorshipRecordStatus.active => ('Active', _gold, Icons.circle),
      SponsorshipRecordStatus.completed => ('Completed', AppColors.mintGreen, Icons.check_circle),
      SponsorshipRecordStatus.refunded => ('Refunded', const Color(0xFFE85A6B), Icons.error_outline_rounded),
    };
    final tournamentBadge = r.tournamentCancelled
        ? ('Cancelled', const Color(0xFFE85A6B), Icons.error_outline_rounded)
        : isActive
            ? ('Active', _gold, Icons.circle)
            : ('Completed', AppColors.mintGreen, Icons.check_circle);

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
                      'Sponsor Details',
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
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3A1848), Color(0xFF1A1028)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: _pink.withValues(alpha: 0.28)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Tournament',
                                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                              ),
                              const SizedBox(width: 8),
                              Icon(tournamentBadge.$3, color: tournamentBadge.$2, size: tournamentBadge.$1 == 'Active' ? 9 : 13),
                              const SizedBox(width: 4),
                              Text(
                                tournamentBadge.$1,
                                style: GoogleFonts.quicksand(
                                  color: tournamentBadge.$2,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                r.tournamentDate,
                                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                        ],
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(height: 12),
                      _StatusBanner(
                        icon: Icons.circle,
                        iconSize: 9,
                        color: _gold,
                        title: 'Active',
                        body: "Your sponsorship is confirmed. The tournament hasn't finished yet.",
                        bg: const Color(0xFF1A160C),
                      ),
                    ],
                    if (isRefunded) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A1418),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE85A6B).withValues(alpha: 0.45)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Status',
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.error_outline_rounded, color: Color(0xFFE85A6B), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Refunded',
                                  style: GoogleFonts.quicksand(
                                    color: const Color(0xFFE85A6B),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${r.refundMessage ?? 'This sponsorship was refunded.'}${r.refundDate == null ? '' : '\nRefunded on ${r.refundDate}.'}',
                              style: GoogleFonts.quicksand(
                                color: const Color(0xFFE85A6B),
                                fontSize: 13.5,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => _help(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE85A6B),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Contact Support  >',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2A1030), Color(0xFF161222)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: _pink.withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sponsor',
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            r.sponsorName,
                            style: GoogleFonts.quicksand(
                              color: _pink,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            r.sponsorType,
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Categories Sponsored',
                      style: GoogleFonts.quicksand(
                        color: AppColors.infoBlue,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          for (final line in r.displayLines) ...[
                            Row(
                              children: [
                                Icon(line.icon, color: _gold, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    line.label,
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  sponsorRupees(line.amount),
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          Row(
                            children: [
                              Text(
                                'Total Sponsored',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                sponsorRupees(r.total),
                                style: GoogleFonts.quicksand(
                                  color: _gold,
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
                      child: Column(
                        children: [
                          _kv('Status', statusLabel, valueColor: statusColor),
                          const SizedBox(height: 10),
                          _kv('Total Amount', sponsorRupees(r.total)),
                          const SizedBox(height: 10),
                          _kv('Sponsorship ID', r.id),
                          const SizedBox(height: 10),
                          _kv('Date', r.dateLabel),
                        ],
                      ),
                    ),
                    if (!isRefunded) ...[
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => DigitalSponsorPassScreen(receipt: r)),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _pink,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: _pink.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            'View Digital Sponsor Pass',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SponsorshipScreen(tournament: r.tournament),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1E28),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.glassBorderStrong),
                        ),
                        child: Text(
                          'View Tournament Sponsorship Progress',
                          style: GoogleFonts.quicksand(
                            color: Colors.white70,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: GestureDetector(
                        onTap: () => _help(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1E28),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.glassBorderStrong),
                          ),
                          child: Text(
                            'Need help?',
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

  Widget _kv(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.quicksand(
            color: valueColor ?? Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.bg,
    this.iconSize = 14,
  });

  final IconData icon;
  final double iconSize;
  final Color color;
  final String title;
  final String body;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Status',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: color, size: iconSize),
              const SizedBox(width: 4),
              Text(
                title,
                style: GoogleFonts.quicksand(
                  color: color,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.quicksand(
              color: color,
              fontSize: 13.5,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
