import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/live_match_detail_info.dart';

/// Dark glass table listing the current bowler(s): wickets-runs, overs
/// bowled, and strike rate.
class BowlerStatsTable extends StatelessWidget {
  const BowlerStatsTable({super.key, required this.bowlers});

  final List<BowlerStat> bowlers;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: _HeaderRow(),
          ),
          Container(height: 1, color: AppColors.glassBorder),
          for (final bowler in bowlers) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      bowler.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      bowler.wicketsRuns,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: Text(bowler.overs, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      bowler.strikeRate,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            if (bowler != bowlers.last) Container(height: 1, color: AppColors.glassBorder),
          ],
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w500);
    return const Row(
      children: [
        Expanded(flex: 4, child: Text('Name', style: style)),
        Expanded(flex: 2, child: Text('W-R', textAlign: TextAlign.center, style: style)),
        Expanded(child: Text('Overs', textAlign: TextAlign.center, style: style)),
        Expanded(flex: 2, child: Text('SR', textAlign: TextAlign.right, style: style)),
      ],
    );
  }
}
