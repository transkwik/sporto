import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Small dark rounded box showing a bold value with a muted label below,
/// used for the Teams / Entry Fee / Kickoff row on the tournament detail
/// screen.
class TournamentStatBox extends StatelessWidget {
  const TournamentStatBox({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
        ],
      ),
    );
  }
}
