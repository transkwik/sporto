import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchFeedTabs extends StatelessWidget {
  const MatchFeedTabs({
    super.key,
    required this.index,
    required this.liveCount,
    required this.upcomingCount,
    required this.onChanged,
  });

  final int index;
  final int liveCount;
  final int upcomingCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _TabItem(
                label: liveCount > 0 ? 'Live ($liveCount)' : 'Live',
                selected: index == 0,
                showDot: true,
                onTap: () => onChanged(0),
              ),
              const SizedBox(width: 22),
              _TabItem(
                label: upcomingCount > 0 ? 'Upcoming($upcomingCount)' : 'Upcoming',
                selected: index == 1,
                onTap: () => onChanged(1),
              ),
              const SizedBox(width: 22),
              _TabItem(
                label: 'Completed',
                selected: index == 2,
                onTap: () => onChanged(2),
              ),
            ],
          ),
        ),
        Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.showDot = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDot) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFFF3B3B) : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.quicksand(
                  color: selected ? Colors.white : Colors.white54,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2.5,
            width: selected ? 56 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A1E),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
