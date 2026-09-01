import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/playground_team_info.dart';

/// Dark glass card listing every player on the team's current squad, with
/// the captain called out.
class SquadListCard extends StatelessWidget {
  const SquadListCard({super.key, required this.squad});

  final List<SquadMemberInfo> squad;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < squad.length; i++) ...[
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: squad[i].name,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  if (squad[i].isCaptain)
                    const TextSpan(
                      text: '  (Captain)',
                      style: TextStyle(color: AppColors.amberAccent, fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
            if (i != squad.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
