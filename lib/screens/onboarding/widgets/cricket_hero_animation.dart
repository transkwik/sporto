import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Looping cricket scene: a delivery comes in, the batsman swings,
/// and the ball is lofted away.
class CricketHeroAnimation extends StatefulWidget {
  const CricketHeroAnimation({super.key});

  @override
  State<CricketHeroAnimation> createState() => _CricketHeroAnimationState();
}

class _CricketHeroAnimationState extends State<CricketHeroAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _CricketScenePainter(t: _controller.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _CricketScenePainter extends CustomPainter {
  _CricketScenePainter({required this.t});

  final double t;

  static const Color _pitch = Color(0xFF3A4A32);
  static const Color _crease = Color(0x66FFFFFF);
  static const Color _stump = Color(0xFFE8C07A);
  static const Color _jersey = Color(0xFFF4F7FA);
  static const Color _pad = Color(0xFFE8ECF2);
  static const Color _skin = Color(0xFFC68642);
  static const Color _helmet = Color(0xFF2A3142);
  static const Color _batWood = Color(0xFFD9A066);
  static const Color _batFace = Color(0xFFF3D5A8);
  static const Color _ball = Color(0xFFC62828);
  static const Color _seam = Color(0xFFF5F5F5);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width < 8 || size.height < 8) return;

    final groundY = size.height * 0.78;
    _drawGround(canvas, size, groundY);
    _drawPitch(canvas, size, groundY);
    _drawStumps(canvas, size, groundY);

    final swing = _swingAmount();
    _drawBatsman(canvas, size, groundY, swing);
    _drawBall(canvas, size, groundY);
    _drawImpactBurst(canvas, size, groundY);
  }

  void _drawGround(Canvas canvas, Size size, double groundY) {
    final rect = Rect.fromLTWH(0, groundY - 18, size.width, size.height - groundY + 18);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, rect.top),
          Offset(0, rect.bottom),
          [
            AppColors.mintGreen.withValues(alpha: 0.10),
            const Color(0xFF1A2218).withValues(alpha: 0.55),
          ],
        ),
    );
  }

  void _drawPitch(Canvas canvas, Size size, double groundY) {
    final pitch = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.48, groundY),
        width: size.width * 0.82,
        height: 18,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(pitch, Paint()..color = _pitch.withValues(alpha: 0.85));

    final creasePaint = Paint()
      ..color = _crease
      ..strokeWidth = 1.4;
    canvas.drawLine(
      Offset(size.width * 0.22, groundY - 6),
      Offset(size.width * 0.22, groundY + 6),
      creasePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, groundY - 6),
      Offset(size.width * 0.68, groundY + 6),
      creasePaint,
    );
  }

  void _drawStumps(Canvas canvas, Size size, double groundY) {
    final baseX = size.width * 0.20;
    const stumpH = 38.0;
    const stumpW = 4.2;
    final paint = Paint()..color = _stump;
    for (var i = 0; i < 3; i++) {
      final x = baseX + i * 8.2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, groundY - stumpH, stumpW, stumpH),
          const Radius.circular(2),
        ),
        paint,
      );
    }

    final bailLift = t > 0.42 && t < 0.62 ? (t - 0.42) * 28 : 0.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(baseX - 1, groundY - stumpH - 3 - bailLift, 28, 3.2),
        const Radius.circular(1.4),
      ),
      Paint()..color = _stump.withValues(alpha: 0.95),
    );
  }

  double _swingAmount() {
    if (t < 0.28) return 0;
    if (t < 0.46) {
      return Curves.easeIn.transform((t - 0.28) / 0.18);
    }
    if (t < 0.72) return 1;
    if (t < 0.88) {
      return 1 - Curves.easeOut.transform((t - 0.72) / 0.16);
    }
    return 0;
  }

  void _drawBatsman(Canvas canvas, Size size, double groundY, double swing) {
    final origin = Offset(size.width * 0.66, groundY);
    canvas.save();
    canvas.translate(origin.dx, origin.dy);

    _roundedRect(canvas, const Rect.fromLTWH(6, -46, 16, 46), 7, _pad.withValues(alpha: 0.7));
    _roundedRect(canvas, const Rect.fromLTWH(-8, -50, 18, 50), 8, _pad);
    _roundedRect(canvas, const Rect.fromLTWH(-14, -96, 32, 50), 12, _jersey);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-14, -96, 6, 50), const Radius.circular(4)),
      Paint()..color = AppColors.mintGreen,
    );

    canvas.drawCircle(const Offset(2, -114), 16, Paint()..color = _helmet);
    canvas.drawCircle(const Offset(4, -112), 11, Paint()..color = _skin.withValues(alpha: 0.35));
    canvas.drawArc(
      const Rect.fromLTWH(-12, -122, 28, 20),
      math.pi,
      math.pi,
      true,
      Paint()..color = AppColors.mintGreen,
    );
    final grill = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.1;
    for (var i = 0; i < 3; i++) {
      canvas.drawLine(Offset(-2.0 + i * 4, -112), Offset(-2.0 + i * 4, -102), grill);
    }

    final armPaint = Paint()
      ..color = _jersey
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(10, -84), Offset(22, -64 - swing * 8), armPaint);

    final batAngle = ui.lerpDouble(-2.05, 1.05, swing)!;
    canvas.save();
    canvas.translate(-4, -70);
    canvas.rotate(batAngle);

    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-3, -22, 6, 24), const Radius.circular(2)),
      Paint()..color = const Color(0xFF5C4033),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-9, 0, 18, 52), const Radius.circular(4)),
      Paint()..color = _batWood,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-6, 6, 10, 40), const Radius.circular(3)),
      Paint()..color = _batFace,
    );
    canvas.drawCircle(const Offset(0, -6), 7, Paint()..color = _jersey);
    canvas.restore();
    canvas.restore();
  }

  void _drawBall(Canvas canvas, Size size, double groundY) {
    final pos = _ballPos(size, groundY);
    if (pos == null) return;

    if (t < 0.42) {
      for (var i = 1; i <= 4; i++) {
        final trailT = (t - i * 0.018).clamp(0.0, 1.0);
        final trail = _incomingPos(size, groundY, (trailT / 0.42).clamp(0.0, 1.0));
        canvas.drawCircle(trail, 5.5 - i * 0.7, Paint()..color = _ball.withValues(alpha: 0.18 / i));
      }
    } else if (t < 0.78) {
      for (var i = 1; i <= 5; i++) {
        final trailT = ((t - 0.42 - i * 0.022) / 0.36).clamp(0.0, 1.0);
        final trail = _outgoingPos(size, groundY, trailT);
        canvas.drawCircle(trail, 6 - i * 0.6, Paint()..color = AppColors.mintGreen.withValues(alpha: 0.16 / i));
      }
    }

    canvas.drawCircle(pos, 7.2, Paint()..color = _ball);
    canvas.drawCircle(pos.translate(-1.6, -1.8), 2.4, Paint()..color = Colors.white24);
    canvas.drawArc(
      Rect.fromCircle(center: pos, radius: 4.6),
      0.4,
      2.2,
      false,
      Paint()
        ..color = _seam
        ..strokeWidth = 1.3
        ..style = PaintingStyle.stroke,
    );
  }

  Offset? _ballPos(Size size, double groundY) {
    if (t < 0.42) return _incomingPos(size, groundY, t / 0.42);
    if (t < 0.78) return _outgoingPos(size, groundY, (t - 0.42) / 0.36);
    return null;
  }

  Offset _incomingPos(Size size, double groundY, double p) {
    final eased = Curves.easeIn.transform(p.clamp(0.0, 1.0));
    final x = ui.lerpDouble(size.width * 0.10, size.width * 0.58, eased)!;
    final bounce = math.sin(eased * math.pi) * size.height * 0.16;
    return Offset(x, groundY - 28 - bounce + eased * 10);
  }

  Offset _outgoingPos(Size size, double groundY, double p) {
    final eased = Curves.easeOut.transform(p.clamp(0.0, 1.0));
    final x = ui.lerpDouble(size.width * 0.58, size.width * 1.06, eased)!;
    final y = groundY - 22 - eased * size.height * 0.72;
    return Offset(x, y);
  }

  void _drawImpactBurst(Canvas canvas, Size size, double groundY) {
    if (t < 0.42 || t > 0.52) return;
    final strength = 1 - ((t - 0.42) / 0.10);
    final center = Offset(size.width * 0.58, groundY - 26);
    final paint = Paint()
      ..color = AppColors.mintGreen.withValues(alpha: 0.45 * strength)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final r = 10 + (1 - strength) * 16;
      canvas.drawLine(center, center + Offset(math.cos(a) * r, math.sin(a) * r), paint);
    }
  }

  void _roundedRect(Canvas canvas, Rect rect, double radius, Color color) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _CricketScenePainter oldDelegate) => oldDelegate.t != t;
}
