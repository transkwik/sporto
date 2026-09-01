import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sporto/core/Firebase/auth_servises.dart';
import 'package:sporto/core/apiServices/api_constants.dart';
import 'package:sporto/core/apiServices/api_helpers.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:sporto/core/globalefunction/global_functions.dart';
import 'package:sporto/screens/auth/login_screen.dart';
import 'package:sporto/screens/auth/providers/auth_provider.dart';
import 'package:sporto/screens/onboarding/complete_profile_screen.dart';
import 'package:sporto/screens/onboarding/permission_screen.dart';
import 'package:sporto/screens/onboarding/onboarding_flow_screen.dart';
import '../../core/constants/app_assets.dart';

/// High-energy Action Montage splash (variation C): diagonal floodlight
/// sweep, speed lines, the Sporto logo with a snappy entrance, staggered
/// sport chips, and a scoreboard-style loader — then into onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color _ink = Color(0xFF050505);
  static const Color _green = Color(0xFF4CAF3D);
  static const Color _amber = Color(0xFFF4B41A);
  static const Color _orange = Color(0xFFF3801C);
  static const Color _red = Color(0xFFE8241B);
  static const Color _status = Color(0xFF55606C);

  static const List<_SplashChip> _chips = [
    // _SplashChip(label: 'Football', emoji: '⚽', alignment: Alignment(-0.85, -0.55), delay: 0.07),
    _SplashChip(
      label: 'Cricket',
      emoji: '🏏',
      alignment: Alignment(0.88, -0.42),
      delay: 0.17,
    ),
    _SplashChip(
      label: 'Live Match',
      emoji: null,
      live: true,
      alignment: Alignment(-0.82, 0.42),
      delay: 0.27,
    ),
    // _SplashChip(label: 'Basketball', emoji: '🏀', alignment: Alignment(0.86, 0.55), delay: 0.37),
  ];

  static const List<String> _statusLines = [
    'Matching players near you',
    'Loading tournaments',
    'Syncing your city',
  ];

  late final AnimationController _loopController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  )..repeat();

  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  late final AnimationController _dotController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  late final AnimationController _statusController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  int _statusIndex = 0;

  late final Animation<double> _logoOpacity = CurvedAnimation(
    parent: _introController,
    curve: const Interval(0.0, 0.18, curve: Curves.easeOut),
  );

  late final Animation<double> _logoSkew = Tween<double>(begin: 0.12, end: 0.0)
      .animate(
        CurvedAnimation(
          parent: _introController,
          curve: const Interval(0.0, 0.18, curve: Curves.easeOut),
        ),
      );

  late final Animation<double> _logoScale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(
        begin: 0.72,
        end: 1.06,
      ).chain(CurveTween(curve: Curves.easeOutBack)),
      weight: 18,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.06,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 10,
    ),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 72),
  ]).animate(_introController);

  late final Animation<double> _progress = CurvedAnimation(
    parent: _introController,
    curve: const Interval(0.05, 0.92, curve: Curves.easeInOut),
  );
  var accessToken;
  @override
  void initState() {
    super.initState();
    _boot();
    _cycleStatus();
    initApp();
  }

  Future<void> _cycleStatus() async {
    while (mounted && _introController.value < 1.0) {
      await Future<void>.delayed(const Duration(milliseconds: 850));
      if (!mounted) return;
      await _statusController.forward(from: 0);
      if (!mounted) return;
      setState(() => _statusIndex = (_statusIndex + 1) % _statusLines.length);
      _statusController.reset();
    }
  }

  /// 🔥 Main initialization
  Future<void> initApp() async {
    try {
      // ✅ Step 1: Get Firebase token
      accessToken = await AuthService().getAccessToken();
      log("Firebase token: $accessToken");

      // ✅ Step 2: Splash delay
      await Future.delayed(const Duration(seconds: 2));

      // ✅ Step 3: Navigate
      if (mounted) {
        await handleNavigation();
      }
    } catch (e) {
      log("Init error: $e");

      if (!mounted) return;
      
      if (_navigated) return;
      _navigated = true;

      // 🚨 Navigate first
      Get.offAll(() => LoginScreen());

      // ✅ Show message AFTER navigation
      Future.delayed(const Duration(milliseconds: 300), () {
        MCP.showMessage(context, "Something went wrong");
      });
    }
  }

  bool _navigated = false;

  /// 🚀 Navigation logic
  Future<void> handleNavigation() async {
    if (_navigated) return;
    _navigated = true;
    
    final provider = Provider.of<AuthProvider>(context, listen: false);

    try {
      var authCode = storage.read('authToken');
      log("Stored authToken: $authCode");

      // 🔴 If not logged in
      if (authCode == null || authCode.toString().isEmpty) {
        if (FORCE_SHOW_ONBOARDING) {
          Get.offAll(
            () => const OnboardingFlowScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 420),
          );
          return;
        }

        bool hasSeenOnboarding = storage.read('hasSeenOnboarding') ?? false;
        if (!hasSeenOnboarding) {
          storage.write('hasSeenOnboarding', true);
          Get.offAll(
            () => const OnboardingFlowScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 420),
          );
        } else {
          Get.offAll(() => LoginScreen());
        }
        return;
      }

      // 🔵 API call with timeout
      var check = await UserApis().getCheck().timeout(
        const Duration(seconds: 10),
      );

      log("Check API response: $check");

      // ✅ VALID RESPONSE
      if (check != null && check['data'] != null) {
        provider.saveCheckResponce(check['data']);

        final profile = check['data']['profile'];
        if (profile != null) {
          if (profile['full_name'] == null) {
            Get.offAll(() => const CompleteProfileScreen());
          } else {
            Get.offAll(() => const PermissionScreen());
          }
        } else {
          Get.offAll(() => const CompleteProfileScreen());
        }
        return;
      }

      // ❌ INVALID RESPONSE (user null / error)
      log("Invalid check response");

      // 🔥 Clear bad token (important fix)
      storage.remove('authToken');

      Get.offAll(() => LoginScreen());

      Future.delayed(const Duration(milliseconds: 300), () {
        MCP.showMessage(
          context,
          check?['error'] ?? "Unable to fetch user details",
        );
      });
    } catch (e) {
      log("Navigation error: $e");

      // 🔥 Clear token on error
      storage.remove('authToken');

      Get.offAll(() => LoginScreen());

      Future.delayed(const Duration(milliseconds: 300), () {
        MCP.showMessage(context, "Server error, please try again");
      });
    }
  }

  Future<void> _boot() async {
    final minHold = Future<void>.delayed(const Duration(milliseconds: 1400));
    final introDone = _introController.forward();
    await Future.wait<void>([minHold, introDone]);
  }

  @override
  void dispose() {
    _loopController.dispose();
    _introController.dispose();
    _dotController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoWidth = math.min(MediaQuery.sizeOf(context).width * 0.62, 260.0);

    return Scaffold(
      backgroundColor: _ink,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _loopController,
            builder: (context, _) =>
                _DiagonalSweep(progress: _loopController.value),
          ),
          AnimatedBuilder(
            animation: _loopController,
            builder: (context, _) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  for (var i = 0; i < 4; i++)
                    _SpeedLine(
                      progress: (_loopController.value + i * 0.17) % 1.0,
                      topFraction: [0.22, 0.32, 0.68, 0.76][i],
                      width: [90.0, 60.0, 80.0, 50.0][i],
                    ),
                ],
              );
            },
          ),
          for (final chip in _chips)
            Align(
              alignment: chip.alignment,
              child: AnimatedBuilder(
                animation: _introController,
                builder: (context, child) {
                  final local = ((_introController.value - chip.delay) / 0.12)
                      .clamp(0.0, 1.0);
                  final t = Curves.easeOut.transform(local);
                  return Opacity(
                    opacity: t,
                    child: Transform.scale(scale: 0.7 + 0.3 * t, child: child),
                  );
                },
                child: _SportChip(chip: chip),
              ),
            ),
          Center(
            child: AnimatedBuilder(
              animation: _introController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(0, 1, _logoSkew.value),
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: _amber.withValues(alpha: 0.22),
                      blurRadius: 48,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: _green.withValues(alpha: 0.12),
                      blurRadius: 70,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Image.asset(
                  AppAssets.sportoLogo,
                  width: logoWidth,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 46,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _dotController,
                      builder: (context, _) {
                        final t = _dotController.value;
                        return Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _red.withValues(
                              alpha: 0.45 + 0.55 * (1 - t),
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _red.withValues(alpha: 0.45 * (1 - t)),
                                blurRadius: 4 + 4 * t,
                                spreadRadius: 2 * t,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _introController,
                        _statusController,
                      ]),
                      builder: (context, _) {
                        return Text(
                          _statusLines[_statusIndex].toUpperCase(),
                          style: GoogleFonts.robotoMono(
                            fontSize: 10.5,
                            letterSpacing: 1.5,
                            color: _status,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 108,
                  height: 2,
                  child: AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            FractionallySizedBox(
                              widthFactor: _progress.value.clamp(0.0, 1.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [_green, _amber, _orange],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashChip {
  const _SplashChip({
    required this.label,
    required this.alignment,
    required this.delay,
    this.emoji,
    this.live = false,
  });

  final String label;
  final String? emoji;
  final bool live;
  final Alignment alignment;
  final double delay;
}

class _SportChip extends StatelessWidget {
  const _SportChip({required this.chip});

  final _SplashChip chip;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xD90D0D0D),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF262B32)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (chip.live)
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8241B),
                    shape: BoxShape.circle,
                  ),
                )
              else if (chip.emoji != null) ...[
                Text(chip.emoji!, style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 6),
              ],
              Text(
                chip.label.toUpperCase(),
                style: GoogleFonts.robotoMono(
                  fontSize: 9.5,
                  letterSpacing: 0.8,
                  color: const Color(0xFFC9CFD6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiagonalSweep extends StatelessWidget {
  const _DiagonalSweep({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    double opacity;
    if (progress < 0.30) {
      opacity = progress / 0.30;
    } else if (progress < 0.60) {
      opacity = 1.0 - ((progress - 0.30) / 0.30) * 0.4;
    } else {
      opacity = 0.6 * (1.0 - (progress - 0.60) / 0.40);
    }

    final dx = -0.30 + progress * 0.70;

    return IgnorePointer(
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(MediaQuery.sizeOf(context).width * dx, 0),
          child: Transform.rotate(
            angle: -0.45,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.35,
                height: MediaQuery.sizeOf(context).height * 1.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      const Color(0xFF4CAF3D).withValues(alpha: 0.14),
                      const Color(0xFF4CAF3D).withValues(alpha: 0.14),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.42, 0.58, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpeedLine extends StatelessWidget {
  const _SpeedLine({
    required this.progress,
    required this.topFraction,
    required this.width,
  });

  final double progress;
  final double topFraction;
  final double width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    double opacity;
    if (progress < 0.10) {
      opacity = progress / 0.10;
    } else if (progress < 0.90) {
      opacity = 1.0;
    } else {
      opacity = 1.0 - (progress - 0.90) / 0.10;
    }

    final travel = size.width * 1.15 * progress;

    return Positioned(
      top: size.height * topFraction,
      left: -60 + travel,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: width,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFFF3801C).withValues(alpha: 0.55),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
