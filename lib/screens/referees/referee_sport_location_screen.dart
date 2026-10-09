import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_game_location_screen.dart';

/// Register Individually → Select Sport (dummy design).
class RefereeSportLocationScreen extends StatefulWidget {
  const RefereeSportLocationScreen({super.key});

  @override
  State<RefereeSportLocationScreen> createState() => _RefereeSportLocationScreenState();
}

class _RefereeSportLocationScreenState extends State<RefereeSportLocationScreen> {
  static const _selectedFill = Color(0xFF6A9DB5);
  static const _tileFill = Color(0xFF12161D);
  static const _wellUnselected = Color(0xFF1C222C);
  static const _wellSelected = Color(0xFF5A8CA6);

  static const _sports = [
    ('🏏', 'Cricket'),
    ('⚽', 'Football'),
    ('🏸', 'Badminton'),
    ('🏀', 'Basketball'),
    ('🎯', 'Darts'),
    ('🏑', 'Hockey'),
    ('🤼', 'Kabaddi'),
    ('🏃', 'Kho Kho'),
    ('🏓', 'Table Tennis'),
    ('🏐', 'Throwball'),
    ('🏐', 'Volleyball'),
    ('🏐', 'Volleyball'),
  ];

  int _selected = 0;

  void _pick(int index) {
    setState(() => _selected = index);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RefereeGameLocationScreen(
          draft: RefereeBookingDraft(
            sport: _sports[index].$2,
            location: '',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      body: Container(
        color: const Color(0xFF0B0D12),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Sport',
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
              ),
              const SizedBox(height: 16),
              Text(
                'Which sport needs an official?',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF4EB4E8),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.62,
                  ),
                  itemCount: _sports.length,
                  itemBuilder: (context, index) {
                    final selected = _selected == index;
                    return GestureDetector(
                      onTap: () => _pick(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected ? _selectedFill : _tileFill,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? Colors.transparent : const Color(0xFF252A33),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected ? _wellSelected : _wellUnselected,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _sports[index].$1,
                                style: const TextStyle(fontSize: 26),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _sports[index].$2,
                              style: GoogleFonts.quicksand(
                                color: selected ? Colors.white : const Color(0xFF8B919C),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
