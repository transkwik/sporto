import 'package:flutter/material.dart';

/// Centralized color palette for the Sporto app.
///
/// Keeping every color in a single place makes it easy to re-theme the
/// app or switch to dark mode without touching individual screens.
class AppColors {
  AppColors._();

  // Brand colors
  static const Color primary = Color(0xFFFF4D30);
  static const Color primaryDark = Color(0xFFE63E22);
  static const Color primaryLight = Color(0xFFFF7A5C);

  static const Color secondary = Color(0xFF14142B);
  static const Color accent = Color(0xFF2ED8B6);

  // Neutrals
  static const Color background = Color(0xFFF8F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF14142B);
  static const Color textSecondary = Color(0xFF6E7191);
  static const Color textHint = Color(0xFFA0A3BD);
  static const Color divider = Color(0xFFE5E5EC);
  static const Color border = Color(0xFFE2E2EA);

  // Status colors
  static const Color success = Color(0xFF2ED8B6);
  static const Color error = Color(0xFFEB5757);
  static const Color warning = Color(0xFFF2C94C);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [secondary, Color(0xFF23234A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dark glassmorphism auth screens (mobile OTP login/signup).
  static const Color authBackgroundTop = Color(0xFF181B27);
  static const Color authBackgroundBottom = Color(0xFF0A0B12);
  static const Color mintGreen = Color(0xFF3ADFA0);
  static const Color infoBlue = Color(0xFF5AC8FA);
  static const Color amberAccent = Color(0xFFE3A93D);

  static const Color glassFillLight = Color(0x14FFFFFF); // white @ 8%
  static const Color glassFillLighter = Color(0x0DFFFFFF); // white @ 5%
  static const Color glassBorder = Color(0x24FFFFFF); // white @ 14%
  static const Color glassBorderStrong = Color(0x33FFFFFF); // white @ 20%

  static const LinearGradient authBackgroundGradient = LinearGradient(
    colors: [authBackgroundTop, authBackgroundBottom],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFFFFC24D), Color(0xFFFF8A1E), Color(0xFFFF6A00)],
    stops: [0.0, 0.55, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Home dashboard (dark theme).
  static const LinearGradient liveCardGradient = LinearGradient(
    colors: [Color(0xFF5B3423), Color(0xFFB3521B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nextMatchGradient = LinearGradient(
    colors: [Color(0xFF1A2A4A), Color(0xFF0D1526)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Tournament detail screen.
  static const Color roseTag = Color(0xFFB3486B);
  static const RadialGradient tournamentHeroGradient = RadialGradient(
    center: Alignment(-0.9, -0.9),
    radius: 1.5,
    colors: [Color(0xFF1F4A3A), Color(0xFF0E1620)],
  );

  // Payment method screen.
  static const LinearGradient paymentSummaryGradient = LinearGradient(
    colors: [Color(0xFF3E7A55), Color(0xFF162C1F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Splash screen.
  static const Color splashAmber = Color(0xFFF6A623);
  static const Color splashPillDark = Color(0xFF2B2013);

  // Playground screen.
  static const LinearGradient playgroundCricketCardGradient = LinearGradient(
    colors: [Color(0xFF16261D), Color(0xFF0E1620)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient playgroundFootballCardGradient = LinearGradient(
    colors: [Color(0xFF2B1D12), Color(0xFF0E1620)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Live match detail screen.
  static const LinearGradient liveScorePanelGradient = LinearGradient(
    colors: [Color(0xFF215B45), Color(0xFF0E1620)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tGradient = LinearGradient(
    begin: Alignment(0.50, -0.00),
    end: Alignment(0.50, 1.00),
    stops: [0.0, 1.0],
    colors: [Color(0xFF7C0537), Color(0xFF9A144D)],
  );
  static const LinearGradient tAppBarGradient = LinearGradient(
    colors: [Color(0XFF7C0638), Color(0xFF9B154D)],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient tSecondaryGradient = LinearGradient(
    colors: [Color.fromRGBO(112, 8, 103, 0.7), Color.fromRGBO(30, 11, 91, 0.7)],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient tWhiteGradient = LinearGradient(
    colors: [
      Color.fromRGBO(255, 255, 255, 0.2),
      Color.fromRGBO(255, 255, 255, 0.9),
    ],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient tLightGradient = LinearGradient(
    colors: [Color.fromRGBO(112, 8, 103, 0.3), Color.fromRGBO(30, 11, 91, 0.3)],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const tButtonBoxShadow = BoxShadow(
    color: Color.fromRGBO(36, 132, 58, 0.4),
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 0,
  );
  static const tBoxShadow = BoxShadow(
    color: Color(0x1e000000),
    blurRadius: 6,
    offset: Offset(0, 1),
  );
  static const tCardShadow = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 4,
    offset: Offset(0, 1),
    spreadRadius: 0,
  );
  static const tContainerShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    blurRadius: 7,
    offset: Offset(0, 2),
    spreadRadius: 0,
  );
  static const tTabShadow = BoxShadow(
    color: Color(0x66111111),
    blurRadius: 3,
    offset: Offset(0, 1),
    spreadRadius: 0,
  );

  // Predictor leaderboard prize banner.
  static const LinearGradient predictorPrizeGradient = LinearGradient(
    colors: [Color(0xFF3A2414), Color(0xFF6B3A18), Color(0xFF1A120C)],
    stops: [0.0, 0.45, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Onboarding intro screen.
  static const Color onboardingHeroCard = Color(0xFF242A3A);

  // Live Matches tab list cards.
  static const LinearGradient liveFootballCardGradient = LinearGradient(
    colors: [Color(0xFF2A3B4C), Color(0xFF141C24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient liveBadmintonCardGradient = LinearGradient(
    colors: [Color(0xFF3E2C4E), Color(0xFF181420)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Live match detail screen — predictor & hype meter sections.
  static const Color hypePink = Color(0xFFE0399E);
  static const Color hypePinkDark = Color(0xFFB23A80);
  static const LinearGradient pinkGradient = LinearGradient(
    colors: [hypePink, hypePinkDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient predictCardGradient = LinearGradient(
    colors: [Color(0xFF3D2A54), Color(0xFF17121F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient hypeMeterBarGradient = LinearGradient(
    colors: [primary, hypePink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const currencySymbol = '₹';
  static const GOOGLE_MAP_KEY = 'AIzaSyBl0Pm1-cZM3-IdYhEkmEQ2A4XxSJpIRdQ';

  static const DISCOUNT_TYPE_FIXED = 1;
  static const DISCOUNT_TYPE_PERCENTAGE = 2;

  // Constant Urls
  static const TERMS_AND_CONDITIONS = 'https://www.zotoapp.in/Terms.html';
  static const PRIVACY_POLICY = 'https://www.zotoapp.in/Privacy.html';
  static const CONTACT_US = 'https://www.zotoapp.in/Contact.html';
  static const ABOUT_US = 'https://www.zotoapp.in/Aboutus.html';

  //Purchased Coupons Constants
  static const STATUS_ACTIVE = 1;
  static const STATUS_REDEEMED = 2;
  static const STATUS_EXPIRED = 3;

  //
  static const DISCOUNT_TYPE_ITEM = 1;
  static const DISCOUNT_TYPE_BILL = 2;
  static const DISCOUNT_TYPE_COMBO = 3;

  // Payment Status
  static const PAYMENT_PENDING = 1;
  static const PAYMENT_PAID = 2;
  static const PAYMENT_FAILED = 3;
  static const PAYMENT_REFUNDED = 4;
  static const PAYMENT_CANCELLED = 5;

  // Registration Status
  static const REGISTRATION_PENDING = 1;
  static const REGISTRATION_WAITING_APPROVAL = 2;
  static const REGISTRATION_CONFIRMED = 3;
  static const REGISTRATION_REJECTED = 4;
  static const REGISTRATION_CANCELLED = 5;
  static const REGISTRATION_COMPLETED = 6;
}
