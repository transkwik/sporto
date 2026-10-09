import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_booking_summary_screen.dart';

class RefereeDetailScreen extends StatelessWidget {
  const RefereeDetailScreen({super.key, required this.official, this.draft});

  final RefereeOfficial official;
  final RefereeBookingDraft? draft;

  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _card = Color(0xFF141820);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: ColoredBox(
        color: _pageBg,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Text(
                      'Referee Profile',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 18,
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: official.photoUrl != null
                                ? Image.network(
                                    official.photoUrl!,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const SizedBox(width: 52, height: 52),
                                  )
                                : const SizedBox(width: 52, height: 52),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  official.name,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${official.sport}  •  ${official.experienceYears} yrs  •  ${official.level}',
                                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Available',
                                style: GoogleFonts.quicksand(
                                  color: _mint,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            icon: Icons.star_rounded,
                            iconColor: const Color(0xFFE3A93D),
                            value: '${official.rating}',
                            label: '20 reviews',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatBox(
                            value: '${official.matches}',
                            label: 'Matches',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatBox(
                            icon: Icons.location_on_rounded,
                            iconColor: const Color(0xFFE35A4A),
                            value: '${official.distanceKm} km',
                            label: 'Distance',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('About', style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 6),
                    Text(
                      official.about,
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5, height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    Text('Pricing', style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A1228), Color(0xFF12161D)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _PriceRow('Hourly', official.hourlyFeeLabel),
                          const Divider(color: Color(0xFF2A3140), height: 1),
                          _PriceRow('Daily', official.dailyFeeLabel),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          'Reviews  •  ⭐ ${official.rating} (${official.reviewCount})',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          'View All >',
                          style: GoogleFonts.quicksand(
                            color: const Color(0xFF4EB4E8),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final review in official.reviews)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        decoration: BoxDecoration(
                          color: _card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF252A33)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    review.author,
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Text('⭐⭐⭐⭐⭐', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '“${review.text}”',
                              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5, height: 1.35),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A1228), Color(0xFF12161D)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('🏏', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                draft?.sport ?? official.sport,
                                style: GoogleFonts.quicksand(
                                  color: _mint,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: _mint, size: 16),
                              SizedBox(width: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'KPHB Indoor Stadium',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                    ),
                                    Text('Kompally, Hyderabad', style: TextStyle(color: Colors.white54, fontSize: 12.5)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RefereeBookingSummaryScreen(
                          draft: (draft ??
                                  RefereeBookingDraft(
                                    sport: official.sport,
                                    location: 'KPHB Indoor Stadium, Kompally, Hyderabad',
                                  ))
                              .copyWith(official: official),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.bannerGradient,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A1E).withValues(alpha: 0.4),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      'Book This Referee',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
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

class _StatBox extends StatelessWidget {
  const _StatBox({this.icon, this.iconColor, required this.value, required this.label});

  final IconData? icon;
  final Color? iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141820),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF252A33)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5)),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(label, style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value, style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
