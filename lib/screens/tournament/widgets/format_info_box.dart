import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Green-tinted bordered box listing the tournament format rules as a
/// bulleted list.
class FormatInfoBox extends StatelessWidget {
  const FormatInfoBox({super.key, required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mintGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rules.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == rules.length - 1 ? 0 : 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: AppColors.mintGreen, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(rules[i], style: const TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.4)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
