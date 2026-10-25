import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Dark glass table listing the batsmen currently at the crease: runs,
/// balls faced, boundaries, and strike rate.
class BatsmanStatsTable extends StatelessWidget {
  const BatsmanStatsTable({super.key, required this.batsmen});

  final List<Map<String, dynamic>> batsmen;

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
          if (batsmen.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No batsmen',
                  style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            )
          else
            for (final batsman in batsmen) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: batsman['name']?.toString() ?? 'Batter',
                              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
                            ),
                            if (batsman['isCaptain'] == true)
                              const TextSpan(
                                text: ' (C)',
                                style: TextStyle(color: AppColors.amberAccent, fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${batsman['runs'] ?? 0} (${batsman['balls'] ?? 0})',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text('${batsman['fours'] ?? 0}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ),
                    Expanded(
                      child: Text('${batsman['sixes'] ?? 0}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        batsman['strikeRate']?.toString() ?? '0.0',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              if (batsman != batsmen.last) Container(height: 1, color: AppColors.glassBorder),
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
        Expanded(flex: 2, child: Text('R (B)', textAlign: TextAlign.center, style: style)),
        Expanded(child: Text('4s', textAlign: TextAlign.center, style: style)),
        Expanded(child: Text('6s', textAlign: TextAlign.center, style: style)),
        Expanded(flex: 2, child: Text('SR', textAlign: TextAlign.right, style: style)),
      ],
    );
  }
}
