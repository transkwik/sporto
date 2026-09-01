import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Small colored dot + bold title, used to label a content section (e.g.
/// "Live Now") on the Home and Matches dashboards.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.dotColor, required this.title});

  final Color dotColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.quicksand(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
