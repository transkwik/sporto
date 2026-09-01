import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Soft bubbles that rise from the bottom with a slight horizontal drift,
/// matching the `floatUp` particles in `spoto_onboarding-1.html`.
class RisingBubbles extends StatefulWidget {
  const RisingBubbles({
    super.key,
    required this.color,
    this.count = 14,
    this.travel = 280,
  });

  final Color color;
  final int count;
  final double travel;

  @override
  State<RisingBubbles> createState() => _RisingBubblesState();
}

class _RisingBubblesState extends State<RisingBubbles> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() => _elapsed = elapsed);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _RisingBubblesPainter(
          color: widget.color,
          count: widget.count,
          travel: widget.travel,
          seconds: _elapsed.inMilliseconds / 1000.0,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _ParticleSeed {
  const _ParticleSeed({
    required this.left,
    required this.size,
    required this.duration,
    required this.delay,
    required this.drift,
  });

  final double left;
  final double size;
  final double duration;
  final double delay;
  final double drift;

  /// Deterministic layout, same formula as the HTML `particleSeed(i)`.
  factory _ParticleSeed.fromIndex(int i) {
    return _ParticleSeed(
      left: (i * 137.5) % 100,
      size: 3.5 + ((i * 53) % 7).toDouble(),
      duration: 3.2 + ((i * 29) % 5).toDouble(),
      delay: (i * 0.37) % 4,
      drift: ((i.isOdd ? 1 : -1) * (12 + (i * 7) % 28)).toDouble(),
    );
  }
}

class _RisingBubblesPainter extends CustomPainter {
  _RisingBubblesPainter({
    required this.color,
    required this.count,
    required this.travel,
    required this.seconds,
  });

  final Color color;
  final int count;
  final double travel;
  final double seconds;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < count; i++) {
      final seed = _ParticleSeed.fromIndex(i);
      final local = seconds - seed.delay;
      if (local < 0) continue;

      final progress = (local % seed.duration) / seed.duration;
      final opacity = _opacityFor(progress);
      if (opacity <= 0.01) continue;

      final x = size.width * (seed.left / 100) + seed.drift * progress;
      final y = size.height + 8 - travel * progress;
      final radius = seed.size;

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);

      canvas.drawCircle(Offset(x, y), radius, paint);

      canvas.drawCircle(
        Offset(x, y),
        radius * 2.1,
        Paint()..color = color.withValues(alpha: opacity * 0.18),
      );
    }
  }

  /// Mirrors the CSS keyframes: fade in by 15%, hold, fade out by 100%.
  double _opacityFor(double p) {
    if (p < 0.15) return (p / 0.15) * 0.55;
    if (p < 0.85) {
      return 0.55 - ((p - 0.15) / 0.70) * 0.15;
    }
    return 0.40 * (1 - (p - 0.85) / 0.15);
  }

  @override
  bool shouldRepaint(covariant _RisingBubblesPainter oldDelegate) {
    return oldDelegate.seconds != seconds ||
        oldDelegate.color != color ||
        oldDelegate.count != count ||
        oldDelegate.travel != travel;
  }
}

/// Accent colors used by the HTML particle layers for each onboarding beat.
abstract final class OnboardingBubbleColors {
  static const Color amber = Color(0xFFF4B41A);
  static const Color green = Color(0xFF4CAF3D);
  static const Color orange = Color(0xFFF3801C);
  static const Color mint = Color(0xFF3ADFA0);

  static Color forPage(int index) {
    switch (index % 4) {
      case 0:
        return amber;
      case 1:
        return orange;
      case 2:
        return green;
      default:
        return mint;
    }
  }
}
