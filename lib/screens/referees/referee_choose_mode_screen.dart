import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_schedule_screen.dart';
import 'widgets/referee_venue_card.dart';

/// Game Location → How would you like to book?
///
/// * **Quick Book** (`autoMatch: true`): Schedule → Confirm Booking → Payment
///   → a random nearby referee is assigned (Referee Found).
/// * **Browse Referees** (`autoMatch: false`): Schedule → Choose Referee →
///   Referee Profile → Booking Summary → Payment → Booking Confirmed.
class RefereeChooseModeScreen extends StatelessWidget {
  const RefereeChooseModeScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _questionBlue = Color(0xFF4EB4E8);

  void _openSchedule(BuildContext context, {required bool autoMatch}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RefereeScheduleScreen(
          // Start every mode fresh (no referee pre-selected).
          draft: RefereeBookingDraft(
            sport: draft.sport,
            sportId: draft.sportId,
            location: draft.location,
            venueName: draft.venueName,
            city: draft.city,
            latitude: draft.latitude,
            longitude: draft.longitude,
            autoMatch: autoMatch,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: ColoredBox(
        color: _pageBg,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
            children: [
              Row(
                children: [
                  GlassBackButton(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book A Referee',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Book A Referee',
                          style: GoogleFonts.quicksand(
                            color: Colors.white38,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              RefereeVenueCard(draft: draft),
              const SizedBox(height: 20),
              Text(
                'How would you like to book?',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: _questionBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _BookOptionCard(
                icon: Icons.bolt_rounded,
                iconColor: _mint,
                title: 'Find Me a Referee',
                body:
                    'Send your request to available referees nearby. SPOTO automatically finds a suitable match — you don’t pick a specific referee.',
                bullets: const [
                  'Faster booking',
                  'Nearby, eligible referees',
                  'First valid acceptance wins',
                ],
                bulletColor: _mint,
                background: const Color(0xFF0F1F19),
                borderColor: const Color(0xFF1F4A38),
                buttonLabel: 'Quick Book',
                buttonGradient: const LinearGradient(
                  colors: [Color(0xFF34C77B), Color(0xFF2BAF6A)],
                ),
                onTap: () => _openSchedule(context, autoMatch: true),
              ),
              const SizedBox(height: 14),
              _BookOptionCard(
                icon: Icons.people_outline_rounded,
                iconColor: Colors.white,
                title: 'Choose Your Referee',
                body:
                    'Browse referee profiles and pick the one you want. Compare rating, experience, distance and price.',
                bullets: const [
                  'Compare ratings & reviews',
                  'See distance & pricing upfront',
                  'Pick exactly who you want',
                ],
                bulletColor: _mint,
                background: const Color(0xFF151A22),
                borderColor: const Color(0xFF262D38),
                buttonLabel: 'Browse Referees',
                buttonGradient: const LinearGradient(
                  colors: [Color(0xFF8ED8FF), Color(0xFF5BBDF2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                onTap: () => _openSchedule(context, autoMatch: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookOptionCard extends StatelessWidget {
  const _BookOptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.bullets,
    required this.bulletColor,
    required this.background,
    required this.borderColor,
    required this.buttonLabel,
    required this.buttonGradient,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final List<String> bullets;
  final Color bulletColor;
  final Color background;
  final Color borderColor;
  final String buttonLabel;
  final Gradient buttonGradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.quicksand(
              color: Colors.white60,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          for (final bullet in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, color: bulletColor, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bullet,
                      style: GoogleFonts.quicksand(
                        color: Colors.white70,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          Center(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 240,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: buttonGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  buttonLabel,
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
