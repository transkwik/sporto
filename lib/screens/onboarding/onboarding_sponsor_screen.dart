import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';
import 'widgets/rising_bubbles.dart';

const _orange = Color(0xFFFF8A1E);

/// Third onboarding page: sponsor logo card, SPONSOR THE GAME / ADVERTISE
/// YOUR BRAND, and Sponsor a Tournament.
class OnboardingSponsorScreen extends StatefulWidget {
  const OnboardingSponsorScreen({super.key, this.onContinue, this.onBack, this.onSkip});

  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  @override
  State<OnboardingSponsorScreen> createState() => _OnboardingSponsorScreenState();
}

class _OnboardingSponsorScreenState extends State<OnboardingSponsorScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enter;
  late final AnimationController _float;

  void _finish() {
    final action = widget.onContinue ?? widget.onSkip;
    if (action != null) {
      action();
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
    _float = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _enter.dispose();
    _float.dispose();
    super.dispose();
  }

  Animation<double> _fade(double begin, double end) {
    return CurvedAnimation(parent: _enter, curve: Interval(begin, end, curve: Curves.easeOutCubic));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1008), Colors.black, Colors.black],
              ),
            ),
          ),
          const RisingBubbles(color: _orange, count: 18, travel: 360),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _handleBack,
                        behavior: HitTestBehavior.opaque,
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 12, 8),
                          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _finish,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'SKIP',
                            style: GoogleFonts.quicksand(
                              color: Colors.white38,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 5,
                    child: FadeTransition(
                      opacity: _fade(0.05, 0.5),
                      child: _SponsorHero(float: _float),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fade(0.2, 0.75),
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
                          .animate(_fade(0.2, 0.75)),
                      child: const _CopyBlock(),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Center(child: _ProgressDots(activeIndex: 2, count: 3)),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fade(0.45, 1),
                    child: _OrangeCtaButton(label: 'Sponsor a Tournament  →', onTap: _finish),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SponsorHero extends StatelessWidget {
  const _SponsorHero({required this.float});

  final Animation<double> float;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: float,
      builder: (context, _) {
        final lift = math.sin(float.value * math.pi) * 6;
        return Center(
          child: SizedBox(
            width: 268,
            height: 248,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: _orange.withValues(alpha: 0.18),
                          blurRadius: 36,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 210,
                    height: 168,
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: CustomPaint(
                      painter: const _DashedRRectPainter(color: _orange, radius: 18),
                      child: Center(
                        child: Text(
                          'Add\nYour Brand',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            color: Colors.white38,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  bottom: 18,
                  child: Transform.translate(
                    offset: Offset(0, -lift),
                    child: const _MedalBadge(),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 42,
                  child: Transform.translate(
                    offset: Offset(0, lift * 0.7),
                    child: const _BuildingBadge(),
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

class _MedalBadge extends StatelessWidget {
  const _MedalBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: _orange,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: _orange.withValues(alpha: 0.55), blurRadius: 18, spreadRadius: 1),
        ],
      ),
      child: const Icon(Icons.workspace_premium_rounded, color: Colors.black, size: 28),
    );
  }
}

class _BuildingBadge extends StatelessWidget {
  const _BuildingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        shape: BoxShape.circle,
        border: Border.all(color: _orange, width: 1.6),
        boxShadow: [
          BoxShadow(color: _orange.withValues(alpha: 0.22), blurRadius: 12),
        ],
      ),
      child: const Icon(Icons.apartment_rounded, color: _orange, size: 24),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;

    const dash = 7.0;
    const gap = 5.0;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final end = math.min(dist + dash, metric.length);
        canvas.drawPath(metric.extractPath(dist, end), paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _CopyBlock extends StatelessWidget {
  const _CopyBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SPONSOR THE\nGAME.',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: 0.3,
          ),
        ),
        Text(
          'ADVERTISE YOUR\nBRAND.',
          style: GoogleFonts.quicksand(
            color: _orange,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Support grassroots sports. Sponsor tournaments. Reward champions. Connect with players and fans.',
          style: GoogleFonts.quicksand(
            color: Colors.white70,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.activeIndex, required this.count});

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == activeIndex ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == activeIndex ? _orange : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}

class _OrangeCtaButton extends StatelessWidget {
  const _OrangeCtaButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _orange,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: _orange.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
