import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Hero from the onboarding HTML: 200×128 slot, left conic beam, SVG athlete.
class NeonKickerAnimation extends StatefulWidget {
  const NeonKickerAnimation({super.key});

  @override
  State<NeonKickerAnimation> createState() => _NeonKickerAnimationState();
}

class _NeonKickerAnimationState extends State<NeonKickerAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ray;

  static const _spot = Color(0xFF4CAF3D);

  /// CSS `conic-gradient(from 200deg, …)` — Flutter SweepGradient is 0 at 3 o'clock.
  static final double _fromAngle = (200 - 90) * math.pi / 180;

  @override
  void initState() {
    super.initState();
    _ray = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ray.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const slotW = 200.0;
        const slotH = 128.0;
        final scale = math.min(
          constraints.maxWidth / slotW,
          constraints.maxHeight / slotH,
        );

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: slotW * scale,
            height: slotH * scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedBuilder(
                  animation: _ray,
                  builder: (context, child) {
                    final pan = Curves.easeInOut.transform(_ray.value);
                    final angle = (pan * 2 - 1) * 32 * math.pi / 180;
                    return Positioned(
                      left: -30 * scale,
                      top: -150 * scale,
                      child: Transform.rotate(
                        angle: angle,
                        child: child,
                      ),
                    );
                  },
                  child: IgnorePointer(
                    child: Container(
                      width: 300 * scale,
                      height: 290 * scale,
                      decoration: BoxDecoration(
                        gradient: SweepGradient(
                          startAngle: _fromAngle,
                          colors: [
                            _spot.withValues(alpha: 0),
                            _spot.withValues(alpha: 0.18),
                            _spot.withValues(alpha: 0),
                            _spot.withValues(alpha: 0),
                          ],
                          stops: const [0.0, 9 / 360, 22 / 360, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 120 * scale,
                    height: 160 * scale,
                    child: const CustomPaint(painter: _AthletePainter()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AthletePainter extends CustomPainter {
  const _AthletePainter();

  static const _green = Color(0xFF4CAF3D);
  static const _ink = Color(0xFF12161C);
  static const _headFill = Color(0xFF0D0D0D);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 130, size.height / 120);

    canvas.drawCircle(
      const Offset(60, 60),
      55,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 0.85,
          colors: [
            _green.withValues(alpha: 0.35),
            _green.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(60, 40), radius: 50)),
    );

    final body = Path()
      ..moveTo(62, 33)
      ..lineTo(58, 62)
      ..lineTo(40, 78)
      ..moveTo(58, 62)
      ..lineTo(74, 70)
      ..lineTo(82, 100);

    final arms = Path()
      ..moveTo(62, 40)
      ..lineTo(44, 52)
      ..moveTo(62, 40)
      ..lineTo(80, 34);

    _stroke(canvas, body, color: _ink, width: 6);
    _stroke(canvas, body, color: _green.withValues(alpha: 0.7), width: 2);
    _stroke(canvas, arms, color: _ink, width: 5);
    _stroke(canvas, arms, color: _green.withValues(alpha: 0.7), width: 1.5);

    canvas.drawCircle(const Offset(62, 24), 9, Paint()..color = _headFill);
    canvas.drawCircle(
      const Offset(62, 24),
      9,
      Paint()
        ..color = _green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(38, 80), width: 14, height: 14),
      Paint()..color = _green.withValues(alpha: 0.85),
    );

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(60, 130), width: 60, height: 10),
      Paint()..color = _green.withValues(alpha: 0.12),
    );
  }

  void _stroke(Canvas canvas, Path path, {required Color color, required double width}) {
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _AthletePainter oldDelegate) => false;
}
