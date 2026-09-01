import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'onboarding_intro_screen.dart';
import 'onboarding_sponsor_screen.dart';
import 'onboarding_watch_screen.dart';

const _pageDuration = Duration(milliseconds: 560);
const _pageCurve = Curves.easeInOutCubicEmphasized;

/// Hosts the three onboarding pages in a single [PageView] so continue, back,
/// and swipe all share the same fade-scale slide instead of stacked routes.
class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  bool _animating = false;

  static const int _lastPage = 2;

  void _goLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  Future<void> _animateTo(int target) async {
    if (_animating || target == _page || target < 0 || target > _lastPage) return;
    _animating = true;
    await _controller.animateToPage(target, duration: _pageDuration, curve: _pageCurve);
    if (mounted) _animating = false;
  }

  void _next() {
    if (_page >= _lastPage) {
      _goLogin();
      return;
    }
    _animateTo(_page + 1);
  }

  void _back() => _animateTo(_page - 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_page > 0) {
          _back();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) => setState(() => _page = index),
          children: [
            _FlowPage(
              index: 0,
              controller: _controller,
              child: OnboardingIntroScreen(onContinue: _next, onSkip: _goLogin),
            ),
            _FlowPage(
              index: 1,
              controller: _controller,
              child: OnboardingWatchScreen(
                onContinue: _next,
                onBack: _back,
                onSkip: _goLogin,
              ),
            ),
            _FlowPage(
              index: 2,
              controller: _controller,
              child: OnboardingSponsorScreen(
                onContinue: _goLogin,
                onBack: _back,
                onSkip: _goLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowPage extends StatelessWidget {
  const _FlowPage({
    required this.index,
    required this.controller,
    required this.child,
  });

  final int index;
  final PageController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        var page = index.toDouble();
        if (controller.hasClients && controller.position.haveDimensions) {
          page = controller.page ?? page;
        }
        final delta = (page - index).abs().clamp(0.0, 1.0);
        final opacity = (1.0 - delta * 0.55).clamp(0.0, 1.0);
        final scale = 1.0 - delta * 0.07;

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            filterQuality: FilterQuality.low,
            child: child,
          ),
        );
      },
    );
  }
}
