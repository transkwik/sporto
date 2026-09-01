import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../auth/widgets/auth_pill_buttons.dart';
import 'widgets/interest_tile.dart';

/// Final onboarding screen: celebrates the finished profile and teases a
/// few personalized interest stats before dropping the user into the app.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.userName});

  final String userName;

  void _handleGoToDashboard(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final displayName = userName.trim().isEmpty ? 'there' : userName.trim().split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.glassFillLighter,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 18),
                      Text(
                        'Welcome $displayName!',
                        style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your profile is ready.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.glassFillLighter,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.amberAccent.withValues(alpha: 0.45)),
                  ),
                  child: const Center(
                    child: Text(
                      'Based on your interests...',
                      style: TextStyle(color: AppColors.amberAccent, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const InterestTile(count: '12', label: 'Nearby Tournaments'),
                const SizedBox(height: 14),
                const InterestTile(count: '5', label: 'Cricket'),
                const SizedBox(height: 14),
                const InterestTile(count: '7', label: 'Football'),
                const SizedBox(height: 14),
                const InterestTile(count: '18', label: 'Teams Looking For Players'),
                const SizedBox(height: 32),
                GradientPillButton(label: 'Go to Dashboard', onPressed: () => _handleGoToDashboard(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
