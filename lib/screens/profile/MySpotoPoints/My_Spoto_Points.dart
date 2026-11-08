// pubspec.yaml -> dependencies:
//   google_fonts: ^6.2.1
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpotoPointsCard extends StatelessWidget {
  final int points;
  final int todayDelta;
  final int pointsToNext;
  final String nextLevel;
  final double progress; // 0.0 - 1.0

  const SpotoPointsCard({
    super.key,
    required this.points,
    required this.todayDelta,
    required this.pointsToNext,
    required this.nextLevel,
    required this.progress,
  });

  static const _gold = Color(0xFFF5B50A);
  static const _grey = Color(0xFF9A9A9E);
  static const _darkGrey = Color(0xFF6B6B6B);

  String _fmt(int n) => n.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]},',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color.fromARGB(118, 237, 124, 32), Color(0xFF69124A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A4C).withOpacity(0.18),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + today delta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Spoto Points',
                style: GoogleFonts.quicksand(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _gold,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.arrow_downward_rounded,
                    size: 13,
                    color: Color(0xFF7CFF9B),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '+$todayDelta',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'today',
                    style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Points
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$points',
                style: GoogleFonts.quicksand(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'pts',
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 4,
              child: LayoutBuilder(
                builder: (context, c) => Stack(
                  children: [
                    Container(color: const Color(0xFF756B68)),
                    Container(
                      width: c.maxWidth * progress.clamp(0.0, 1.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF07F00), Color(0xFFD4A62A)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Points to next level
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: _fmt(pointsToNext),
                  style: const TextStyle(color: _grey),
                ),
                TextSpan(
                  text: ' pts to $nextLevel',
                  style: const TextStyle(color: _darkGrey),
                ),
              ],
            ),
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
