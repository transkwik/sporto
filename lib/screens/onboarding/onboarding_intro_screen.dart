import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';
import 'widgets/neon_kicker_animation.dart';
import 'widgets/rising_bubbles.dart';

const _neon = Color(0xFF6CFF3C);

/// First onboarding page: neon kicker orb, REGISTER / PLAY / WIN, level
/// chips, bullets, and Create Player Profile.
class OnboardingIntroScreen extends StatefulWidget {
  const OnboardingIntroScreen({super.key, this.onContinue, this.onSkip});

  final VoidCallback? onContinue;
  final VoidCallback? onSkip;

  @override
  State<OnboardingIntroScreen> createState() => _OnboardingIntroScreenState();
}

class _OnboardingIntroScreenState extends State<OnboardingIntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter;

  void _handleContinue() {
    if (widget.onContinue != null) {
      widget.onContinue!();
      return;
    }
    Navigator.of(context).pushNamed(AppRoutes.onboardingWatch);
  }

  void _handleSkip() {
    if (widget.onSkip != null) {
      widget.onSkip!();
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
  }

  @override
  void dispose() {
    _enter.dispose();
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
                colors: [Color(0xFF0C1808), Colors.black, Colors.black],
              ),
            ),
          ),
          const RisingBubbles(color: _neon, count: 18, travel: 360),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _fade(0, 0.3),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _handleSkip,
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
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: FadeTransition(
                      opacity: _fade(0.05, 0.5),
                      child: const NeonKickerAnimation(),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fade(0.2, 0.7),
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(_fade(0.2, 0.7)),
                      child: const _CopyBlock(),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Center(child: _ProgressDots(activeIndex: 0, count: 3)),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fade(0.45, 1),
                    child: _NeonCtaButton(
                      label: 'Create Player Profile  →',
                      onTap: _handleContinue,
                    ),
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

class _CopyBlock extends StatelessWidget {
  const _CopyBlock();

  static const _levels = ['LOCAL', 'CITY', 'DISTRICT', 'STATE', 'NATIONAL'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _neon, width: 1.4),
              ),
              child: const Icon(Icons.emoji_events_outlined, color: _neon, size: 32),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'REGISTER. PLAY.',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: 0.4,
          ),
        ),
        Text(
          'WIN.',
          style: GoogleFonts.quicksand(
            color: _neon,
            fontSize: 34,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i < _levels.length; i++) ...[
              _LevelChip(label: _levels[i], highlighted: i == _levels.length - 1),
              if (i != _levels.length - 1)
                const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 16),
            ],
          ],
        ),
        const SizedBox(height: 18),
        const _Bullet('Build Your Team'),
        const SizedBox(height: 10),
        const _Bullet('Find Tournaments'),
        const SizedBox(height: 10),
        const _Bullet('Win Prize Money'),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.label, required this.highlighted});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: highlighted ? _neon : const Color(0xFF3A3A3A)),
      ),
      child: Text(
        label,
        style: GoogleFonts.quicksand(
          color: highlighted ? _neon : Colors.white54,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(color: _neon, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
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
              color: i == activeIndex ? _neon : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}

class _NeonCtaButton extends StatelessWidget {
  const _NeonCtaButton({required this.label, required this.onTap});

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
          color: _neon,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: _neon.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8)),
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
