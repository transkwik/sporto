import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import 'sponsor_details_screen.dart';
import 'sponsor_format.dart';

/// List → Sponsorship: prize-pool progress and per-category sponsor CTAs.
class SponsorshipScreen extends StatefulWidget {
  const SponsorshipScreen({super.key, required this.tournament});

  final SponsorTournament tournament;

  @override
  State<SponsorshipScreen> createState() => _SponsorshipScreenState();
}

class _SponsorshipScreenState extends State<SponsorshipScreen> {
  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);
  static const _cyan = Color(0xFF3ADFA0);

  late final SponsorCheckout _checkout = SponsorCheckout(tournament: widget.tournament);

  void _openCategory(SponsorPrizeCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SponsorDetailsScreen(checkout: _checkout, category: category),
      ),
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
                      'Sponsorship',
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
                    _HeaderCard(tournament: t),
                    const SizedBox(height: 12),
                    _ProgressCard(
                      tournament: t,
                      gold: _gold,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            value: sponsorCompact(t.prizePoolValue),
                            label: 'Prize Pool',
                            valueColor: _gold,
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
                            valueColor: _gold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sponsor a Prize Category',
                      style: GoogleFonts.quicksand(
                        color: _cyan,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final category in t.categories) ...[
                      _CategoryCard(
                        category: category,
                        gold: _gold,
                        pink: _pink,
                        rupees: sponsorRupees,
                        onSponsor: () => _openCategory(category),
                      ),
                      const SizedBox(height: 10),
                    ],
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.tournament});

  final SponsorTournament tournament;

  @override
  Widget build(BuildContext context) {
    final t = tournament;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161222),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE85AD4).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.title,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: t.sport,
                  style: GoogleFonts.quicksand(
                    color: AppColors.mintGreen,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '  •  ${t.city}',
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: Colors.white38, size: 13),
              const SizedBox(width: 5),
              Text(
                t.dateLabel,
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.groups_outlined, color: Colors.white38, size: 15),
              const SizedBox(width: 4),
              Text(
                '${t.teams} Teams',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.tournament, required this.gold});

  final SponsorTournament tournament;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    final t = tournament;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF12181A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sponsorship Progress',
            style: GoogleFonts.quicksand(
              color: gold,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: t.fundedRatio,
              minHeight: 7,
              backgroundColor: const Color(0xFF2A303C),
              color: gold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${t.sponsors} Sponsors',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
              ),
              const Spacer(),
              Text(
                '${t.fundedPercent}% Funded',
                style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12.5),
              ),
            ],
          ),
        ],
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

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.gold,
    required this.pink,
    required this.rupees,
    required this.onSponsor,
  });

  final SponsorPrizeCategory category;
  final Color gold;
  final Color pink;
  final String Function(int) rupees;
  final VoidCallback onSponsor;

  @override
  Widget build(BuildContext context) {
    final c = category;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161222),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: pink.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(c.icon, color: gold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  c.label,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                rupees(c.target),
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: c.fundedRatio,
              minHeight: 7,
              backgroundColor: const Color(0xFF2A303C),
              color: gold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${rupees(c.sponsored)} Sponsored',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
              ),
              const Spacer(),
              Text(
                '${rupees(c.remaining)} Remaining',
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onSponsor,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: pink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 15),
                    const SizedBox(width: 6),
                    Text(
                      'Sponsor ${c.label}',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
