import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_flow_screen.dart';
import '../screens/onboarding/onboarding_sponsor_screen.dart';
import '../screens/onboarding/onboarding_watch_screen.dart';
import '../screens/profile/my_sports_screen.dart';
import '../screens/profile/my_teams_screen.dart';
import '../screens/profile/my_tournaments_screen.dart';
import '../screens/splash/splash_screen.dart';
import 'app_routes.dart';

/// Single source of truth mapping route names to the screens they render.
///
/// Using `onGenerateRoute` (rather than the plain `routes` map) keeps the
/// door open for passing arguments to screens later without changing the
/// call sites.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _build(const SplashScreen(), settings);
      case AppRoutes.onboardingIntro:
        return _fadeSlide(const OnboardingFlowScreen(), settings);
      case AppRoutes.onboardingWatch:
        return _fadeSlide(const OnboardingWatchScreen(), settings);
      case AppRoutes.onboardingSponsor:
        return _fadeSlide(const OnboardingSponsorScreen(), settings);
      case AppRoutes.login:
        return _fadeSlide(const LoginScreen(), settings);
      case AppRoutes.signup:
        return _build(const SignUpScreen(), settings);
      case AppRoutes.home:
        return _build(const HomeScreen(), settings);
      case AppRoutes.mySports:
        return _build(const MySportsScreen(), settings);
      case AppRoutes.myTeams:
        return _build(const MyTeamsScreen(), settings);
      case AppRoutes.myTournaments:
        return _build(const MyTournamentsScreen(), settings);
      default:
        return _build(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings,
        );
    }
  }

  static PageRoute _build(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }

  static PageRoute _fadeSlide(Widget screen, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 480),
      reverseTransitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final enter = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final exit = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInOutCubic,
        );
        return FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0.72).animate(exit),
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset.zero, end: const Offset(-0.06, 0)).animate(exit),
            child: FadeTransition(
              opacity: enter,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(enter),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
