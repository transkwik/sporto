import 'package:flutter/material.dart';

/// Small tricolor flag chip used next to the "+91" country code.
///
/// Drawn manually (rather than relying on the 🇮🇳 flag emoji) so it renders
/// consistently on platforms — like Windows desktop — where flag emoji
/// fall back to plain two-letter country codes.
class IndiaFlagIcon extends StatelessWidget {
  const IndiaFlagIcon({super.key, this.width = 22, this.height = 15});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Expanded(child: Container(color: const Color(0xFFFF9933))),
                Expanded(child: Container(color: Colors.white)),
                Expanded(child: Container(color: const Color(0xFF138808))),
              ],
            ),
            Center(
              child: Container(
                width: height * 0.32,
                height: height * 0.32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF000080), width: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
