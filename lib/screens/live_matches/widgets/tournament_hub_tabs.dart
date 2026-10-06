import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TournamentHubTabs extends StatelessWidget {
  const TournamentHubTabs({
    super.key,
    required this.index,
    required this.upcomingCount,
    required this.onChanged,
  });

  final int index;
  final int upcomingCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _TabItem(
            label: 'Tournaments',
            selected: index == 0,
            onTap: () => onChanged(0),
          ),
          const SizedBox(width: 18),
          _TabItem(
            label: 'Live',
            selected: index == 1,
            showDot: true,
            onTap: () => onChanged(1),
          ),
          const SizedBox(width: 18),
          _TabItem(
            label: upcomingCount > 0 ? 'Upcoming($upcomingCount)' : 'Upcoming',
            selected: index == 2,
            onTap: () => onChanged(2),
          ),
          const SizedBox(width: 14),
          _HistoryChip(
            selected: index == 3,
            onTap: () => onChanged(3),
          ),
        ],
      ),
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
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFFF3B3B) : Colors.white38,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.quicksand(
                  color: selected ? Colors.white : Colors.white54,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2.5,
            width: selected ? 52 : 0,
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

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF1B3A48) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF5AC8FA), width: 1.2),
            ),
            child: Text(
              'History',
              style: GoogleFonts.quicksand(
                color: const Color(0xFF5AC8FA),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2.5,
            width: selected ? 36 : 0,
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
