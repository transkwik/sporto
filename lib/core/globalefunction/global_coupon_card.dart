import 'package:flutter/material.dart';

class MovieTicketVerticalClipper extends CustomClipper<Path> {
  final double notchRadius;
  final int notchCount;

  MovieTicketVerticalClipper({this.notchRadius = 10, this.notchCount = 10});

  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start top-left
    path.moveTo(0, 0);

    // Top edge
    path.lineTo(size.width, 0);

    // Right side with semicircle notches
    double step = (size.height - 2 * notchRadius) / notchCount;
    double y = 0;
    for (int i = 0; i < notchCount; i++) {
      y += step;
      path.arcToPoint(Offset(size.width, y + notchRadius), radius: Radius.circular(notchRadius), clockwise: false);
      y += notchRadius;
    }
    path.lineTo(size.width, size.height);

    // Bottom edge
    path.lineTo(0, size.height);

    // Left side with semicircle notches
    y = size.height;
    for (int i = 0; i < notchCount; i++) {
      y -= step;
      path.arcToPoint(Offset(0, y - notchRadius), radius: Radius.circular(notchRadius), clockwise: false);
      y -= notchRadius;
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
