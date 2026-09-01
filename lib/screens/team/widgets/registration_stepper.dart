import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// A custom stepper widget for the registration flow
/// showing Tournament -> Team -> Payment.
class RegistrationStepper extends StatelessWidget {
  const RegistrationStepper({
    super.key,
    required this.currentStep,
  });

  /// 1 = Tournament, 2 = Team, 3 = Payment
  final int currentStep;

  Widget _buildStep({
    required int stepNumber,
    required String title,
    required bool isCompleted,
    required bool isActive,
  }) {
    Color color;
    if (isCompleted) {
      color = AppColors.mintGreen;
    } else if (isActive) {
      color = AppColors.amberAccent;
    } else {
      color = Colors.white38;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Colors.transparent : (isActive ? color : Colors.transparent),
            border: Border.all(color: color, width: 1.5),
          ),
          child: isCompleted
              ? Icon(Icons.check_rounded, size: 14, color: color)
              : Text(
                  stepNumber.toString(),
                  style: GoogleFonts.quicksand(
                    color: isActive ? Colors.white : color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: GoogleFonts.quicksand(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Icon(
        Icons.arrow_right_alt_rounded,
        color: Colors.white38,
        size: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(
            stepNumber: 1,
            title: 'Tournament',
            isCompleted: currentStep > 1,
            isActive: currentStep == 1,
          ),
          _buildDivider(),
          _buildStep(
            stepNumber: 2,
            title: 'Team',
            isCompleted: currentStep > 2,
            isActive: currentStep == 2,
          ),
          _buildDivider(),
          _buildStep(
            stepNumber: 3,
            title: 'Payment',
            isCompleted: currentStep > 3,
            isActive: currentStep == 3,
          ),
        ],
      ),
    );
  }
}
