import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_booking_summary_screen.dart' show RefereeAvatar;
import 'referee_hub_screen.dart';

/// Final step after payment.
///
/// * Quick Book → "REFEREE FOUND!" with the randomly assigned referee.
/// * Browse     → "BOOKING CONFIRMED!" with the chosen referee.
class RefereeFoundScreen extends StatelessWidget {
  RefereeFoundScreen({super.key, required this.draft})
    : bookingId =
          'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

  final RefereeBookingDraft draft;
  final String bookingId;

  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _card = Color(0xFF141820);
  static const _gold = Color(0xFFE3B34A);

  void _backToHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final official = draft.official;
    final isQuick = draft.autoMatch;

    return PopScope(
      // Payment is done — never go back to the payment screen.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _backToHome(context);
      },
      child: Scaffold(
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
                        child: GlassBackButton(
                          onTap: () => _backToHome(context),
                        ),
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
                              child: const Text(
                                '🎉',
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              isQuick ? 'REFEREE FOUND!' : 'BOOKING CONFIRMED!',
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isQuick
                                  ? 'A nearby referee has accepted your ${draft.sport} request.'
                                  : 'Your ${draft.sport} referee booking is confirmed.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                color: Colors.white54,
                                fontSize: 13.5,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Booking id + status
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
                                  bookingId,
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
                              decoration: const BoxDecoration(
                                color: _mint,
                                shape: BoxShape.circle,
                              ),
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

                      // Referee
                      if (official != null)
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                          decoration: BoxDecoration(
                            color: _card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF252A33)),
                          ),
                          child: Row(
                            children: [
                              RefereeAvatar(official: official, size: 52),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      official.name,
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '⭐  ${official.rating}  •  ${official.experienceYears} yrs  •  ${official.level}',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${official.matches} matches  •  ${official.distanceKm} km',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),

                      // Booking details
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
                            _label('Venue'),
                            _value(draft.venueTitle),
                            if (draft.venueSubtitle.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _label('Location'),
                              _value(draft.venueSubtitle),
                            ],
                            const SizedBox(height: 12),
                            _label('Amount Paid'),
                            _value(
                              RefereeBookingDraft.rupees(draft.totalAmount),
                              color: _gold,
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
                                    child: _StatCell(
                                      label: 'Date',
                                      value: draft.dateLabel,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 44,
                                    color: const Color(0xFF2A3140),
                                  ),
                                  Expanded(
                                    child: _StatCell(
                                      label: 'Start Time',
                                      value: draft.timeLabel,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 44,
                                    color: const Color(0xFF2A3140),
                                  ),
                                  Expanded(
                                    child: _StatCell(
                                      label: 'Duration',
                                      value: draft.durationLabel,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: 'Booking Type: ',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${draft.bookingTypeLabel}  •  ${isQuick ? 'Quick Book' : 'Chosen Referee'}',
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
                        MaterialPageRoute(
                          builder: (_) => const RefereeHubScreen(),
                        ),
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
                    onTap: () => _backToHome(context),
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
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
  );

  Widget _value(String text, {Color color = Colors.white}) => Text(
    text,
    style: GoogleFonts.quicksand(
      color: color,
      fontSize: 14.5,
      fontWeight: FontWeight.w700,
    ),
  );
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
          Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5),
          ),
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
