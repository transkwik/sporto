import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_browse_screen.dart';
import 'referee_confirmed_screen.dart';

/// Game Location → How would you like to book? (dummy).
class RefereeChooseModeScreen extends StatelessWidget {
  const RefereeChooseModeScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _questionBlue = Color(0xFF4EB4E8);

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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A1228), Color(0xFF12161D)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
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
                          draft.sport,
                          style: GoogleFonts.quicksand(
                            color: _mint,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.location_on_rounded, color: _mint, size: 16),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KPHB Indoor Stadium',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Kompally, Hyderabad',
                                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'How would you like to book?',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: _questionBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              _BookOptionCard(
                icon: Icons.bolt_rounded,
                title: 'Find Me a Referee',
                body:
                    'Send your request to available referees nearby. SPOTO automatically finds a suitable match — you don’t pick a specific referee.',
                bullets: const [
                  'Faster booking',
                  'Nearby, eligible referees',
                  'First valid acceptance wins',
                ],
                buttonLabel: 'Quick Book',
                buttonColor: _mint,
                buttonTextColor: Colors.black,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RefereeConfirmedScreen(
                        draft: draft.copyWith(
                          autoMatch: true,
                          official: dummyAvailableReferees.first,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              _BookOptionCard(
                icon: Icons.groups_rounded,
                title: 'Choose Your Referee',
                body:
                    'Browse referee profiles and pick the one you want. Compare rating, experience, distance and price.',
                bullets: const [
                  'Compare ratings & reviews',
                  'See distance & pricing upfront',
                  'Pick exactly who you want',
                ],
                buttonLabel: 'Browse Referees',
                buttonColor: const Color(0xFF6EC8F5),
                buttonTextColor: Colors.black,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RefereeBrowseScreen(
                        title: 'Choose Referee',
                        officials: dummyAvailableReferees,
                        draft: draft,
                      ),
                    ),
                  );
                },
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
    required this.title,
    required this.body,
    required this.bullets,
    required this.buttonLabel,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final List<String> bullets;
  final String buttonLabel;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF10241C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1F4A38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3DDC97), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5, height: 1.35),
          ),
          const SizedBox(height: 10),
          for (final bullet in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_rounded, color: Color(0xFF3DDC97), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      bullet,
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                buttonLabel,
                style: GoogleFonts.quicksand(
                  color: buttonTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
