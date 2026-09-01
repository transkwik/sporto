import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Full-width orange gradient pill button with a soft glow, used for the
/// primary "Continue" action on the auth screens.
class GradientPillButton extends StatelessWidget {
  const GradientPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 48,
      decoration: BoxDecoration(
        gradient: enabled ? AppColors.bannerGradient : null,
        color: enabled ? null : AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(14),
        border: enabled ? null : Border.all(color: AppColors.glassBorder),
        boxShadow: enabled
            ? [BoxShadow(color: const Color(0xFFFF7A1E).withValues(alpha: 0.45), blurRadius: 22, offset: const Offset(0, 10))]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: (loading || !enabled) ? null : onPressed,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: enabled ? Colors.white : Colors.white38,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Full-width frosted outline pill used for the secondary
/// "Already have an account? Login" action.
class GlassOutlinePillButton extends StatelessWidget {
  const GlassOutlinePillButton({super.key, required this.question, required this.actionLabel, required this.onPressed});

  final String question;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Center(
            child: Text.rich(
              TextSpan(
                text: '$question ',
                style: const TextStyle(color: Colors.white70, fontSize: 14.5, fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: actionLabel,
                    style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
