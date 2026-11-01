import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sporto/core/constants/app_assets.dart';

/// Light "Tournament Completed!" card showing an individual player award
/// (e.g. "Batsmen Award") with a "Prize Details" button.
///
/// Pure UI widget: no API calls. Pass data in and handle taps from outside.
class IndividualPlayerAwardCard extends StatelessWidget {
  const IndividualPlayerAwardCard({
    super.key,
    this.badgeText = 'Tournament Completed!',
    this.awardName = 'Batsmen Award',
    this.buttonText = 'Prize Details',
    this.onTap,
    this.height = 140,
  });

  final String badgeText;
  final String awardName;
  final String buttonText;
  final VoidCallback? onTap;
  final double height;

  static const Color _gold = Color(0xFFF5B016);
  static const Color _badgeBg = Color(0xFFFEF5E1);
  static const Color _badgeBorder = Color(0xFFFBDFA0);
  static const Color _btnTop = Color(0xFF78D2FF);
  static const Color _btnBottom = Color(0xFF4DB6EC);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.all(1.0), // gradient border thickness
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3AD7E8),
              Color.fromARGB(255, 4, 170, 247),
              Color.fromARGB(191, 4, 247, 109),
              Color.fromARGB(255, 138, 255, 35),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(AppAssets.prizeBackground),
              fit: BoxFit.cover,
              alignment: Alignment(0.55, 0),
            ),
            color: const Color.fromARGB(255, 27, 85, 118),
            borderRadius: BorderRadius.circular(22.5),
          ),
          child: Stack(
            children: [
              // Positioned.fill(
              //   child: Image.asset(
              //     AppAssets.prizeBackground,
              //     fit: BoxFit.cover,
              //     alignment: const Alignment(0.55, 0),
              //   ),
              // ),
              // Top-left badge
              Align(alignment: Alignment.topLeft, child: _buildBadge()),

              // Bottom-left award name
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, bottom: 60),
                  child: Text(
                    "ABS Premier League 2026",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, bottom: 20),
                  child: Text(
                    "You’ve won best",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, bottom: 4),
                  child: Text(
                    awardName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: _gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // Bottom-right button
              Align(alignment: Alignment.bottomRight, child: _buildButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _badgeBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: _gold.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Text(
            badgeText,
            style: GoogleFonts.quicksand(
              color: _gold,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [_btnTop, _btnBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: _btnBottom.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            buttonText,
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.black,
            size: 18,
          ),
        ],
      ),
    );
  }
}
