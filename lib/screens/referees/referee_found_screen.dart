import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_hub_screen.dart';

/// Pay → Referee Found (dummy).
class RefereeFoundScreen extends StatelessWidget {
  const RefereeFoundScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _card = Color(0xFF141820);
  static const _gold = Color(0xFFE3B34A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: ColoredBox(
        color: _pageBg,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C222C),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Text('🎉', style: TextStyle(fontSize: 40)),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'REFEREE FOUND!',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your registration for SPOTO Random Cricket is confirmed.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REF-61307662',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                draft.sport,
                                style: GoogleFonts.quicksand(
                                  color: _mint,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Booking Confirmed',
                            style: GoogleFonts.quicksand(
                              color: _mint,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 52,
                                height: 52,
                                color: const Color(0xFF2A241C),
                                alignment: Alignment.center,
                                child: Text(
                                  'SR',
                                  style: GoogleFonts.quicksand(
                                    color: AppColors.amberAccent,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Suresh Reddy',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '⭐  4.8  •  8 yrs  •  3 Level',
                                  style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  '34 matches  •  2.4 km',
                                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tournament', style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
                          Text(
                            'SPOTO Random Cricket — Hyderabad',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Venue', style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
                          Text(
                            'KPHB Indoor Stadium',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Location', style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12)),
                          Text(
                            'Kompally, Hyderabad',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF10141A),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _StatCell(label: 'Date', value: '24 Aug 2026'),
                                ),
                                Container(width: 1, height: 44, color: const Color(0xFF2A3140)),
                                const Expanded(
                                  child: _StatCell(label: 'Start Time', value: '5:00 PM'),
                                ),
                                Container(width: 1, height: 44, color: const Color(0xFF2A3140)),
                                const Expanded(
                                  child: _StatCell(label: 'Duration', value: '2 Hours'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Booking Type: ',
                                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: 'Hourly',
                                    style: GoogleFonts.quicksand(
                                      color: _mint,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const RefereeHubScreen()),
                      (route) => route.isFirst,
                    );
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: _gold, width: 1.4),
                    ),
                    child: Text(
                      'View My Bookings',
                      style: GoogleFonts.quicksand(
                        color: _gold,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F28),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      'Back to Home',
                      style: GoogleFonts.quicksand(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5)),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
