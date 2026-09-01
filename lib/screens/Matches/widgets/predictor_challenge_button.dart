import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Full-width pink gradient pill button with a soft glow, prompting the
/// viewer to open the predictor challenge for this match.
class PredictorChallengeButton extends StatelessWidget {
  const PredictorChallengeButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppColors.pinkGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: AppColors.hypePink.withValues(alpha: 0.45), blurRadius: 22, offset: const Offset(0, 10)),
          ],
        ),
        child: const Text(
          'Predictor Challenge',
          style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
