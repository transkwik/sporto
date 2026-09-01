import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';
import 'widgets/rising_bubbles.dart';

const _gold = Color(0xFFF5B42A);

/// Second onboarding page: live prediction card, WATCH / CHEER / SUPPORT,
/// and Join the Action.
class OnboardingWatchScreen extends StatefulWidget {
  const OnboardingWatchScreen({super.key, this.onContinue, this.onBack, this.onSkip});

  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  @override
  State<OnboardingWatchScreen> createState() => _OnboardingWatchScreenState();
}

class _OnboardingWatchScreenState extends State<OnboardingWatchScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enter;
  late final AnimationController _livePulse;

  void _finish() {
    if (widget.onSkip != null) {
      widget.onSkip!();
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  void _handleContinue() {
    if (widget.onContinue != null) {
      widget.onContinue!();
      return;
    }
    Navigator.of(context).pushNamed(AppRoutes.onboardingSponsor);
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
    _livePulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _enter.dispose();
    _livePulse.dispose();
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
                colors: [Color(0xFF1A1408), Colors.black, Colors.black],
              ),
            ),
          ),
          const RisingBubbles(color: _gold, count: 18, travel: 360),
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
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _fade(0.05, 0.45),
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero).animate(_fade(0.05, 0.45)),
                      child: _LiveMatchCard(pulse: _livePulse),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _GoldDivider(),
                  const Spacer(),
                  FadeTransition(
                    opacity: _fade(0.2, 0.75),
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(_fade(0.2, 0.75)),
                      child: const _CopyBlock(),
                    ),
                  ),
                  const Spacer(),
                  const Center(child: _ProgressDots(activeIndex: 1, count: 3)),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fade(0.45, 1),
                    child: _GoldCtaButton(label: 'Join the Action  →', onTap: _handleContinue),
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

class _LiveMatchCard extends StatelessWidget {
  const _LiveMatchCard({required this.pulse});

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x22F5B42A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: pulse,
                builder: (context, _) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.55 + pulse.value * 0.45),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              Text(
                'LIVE',
                style: GoogleFonts.quicksand(color: _gold, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.8),
              ),
              const Spacer(),
              Text(
                "72'",
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Galli United  2  —  1  FC Turf',
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _gold.withValues(alpha: 0.7)),
            ),
            child: Column(
              children: [
                Text(
                  'Your prediction: Galli United',
                  style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.check_rounded, color: _gold, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldDivider extends StatelessWidget {
  const _GoldDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0x22FFFFFF), height: 1)),
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: _gold,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: _gold.withValues(alpha: 0.55), blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 18),
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: _gold,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: _gold.withValues(alpha: 0.55), blurRadius: 8)],
          ),
        ),
        const Expanded(child: Divider(color: Color(0x22FFFFFF), height: 1)),
      ],
    );
  }
}

class _CopyBlock extends StatelessWidget {
  const _CopyBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _gold, width: 1.5),
          ),
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _gold.withValues(alpha: 0.45)),
              ),
              child: const Icon(Icons.auto_awesome, color: _gold, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'WATCH. CHEER.\nSUPPORT.',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: 0.3,
          ),
        ),
        Text(
          'WIN CASH PRIZES.',
          style: GoogleFonts.quicksand(
            color: _gold,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 18),
        const _Bullet('Follow Live Action'),
        const SizedBox(height: 11),
        const _Bullet('Predict Outcomes'),
        const SizedBox(height: 11),
        const _Bullet('Win Prizes'),
        const SizedBox(height: 11),
        const _Bullet('No Gambling — Just Winning'),
      ],
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
          decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle),
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == activeIndex ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == activeIndex ? _gold : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ],
    );
  }
}

class _GoldCtaButton extends StatelessWidget {
  const _GoldCtaButton({required this.label, required this.onTap});

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
          color: _gold,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: _gold.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8)),
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
