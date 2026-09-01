import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HomeNavItem {
  const HomeNavItem({required this.label, required this.iconOutlined, required this.iconFilled});

  final String label;
  final IconData iconOutlined;
  final IconData iconFilled;
}

const List<HomeNavItem> homeNavItems = [
  HomeNavItem(label: 'Tournaments', iconOutlined: Icons.emoji_events_outlined, iconFilled: Icons.emoji_events_rounded),
  HomeNavItem(label: 'Live', iconOutlined: Icons.live_tv_outlined, iconFilled: Icons.live_tv_rounded),
  HomeNavItem(label: 'Matches', iconOutlined: Icons.play_circle_outline_rounded, iconFilled: Icons.play_circle_fill_rounded),
  HomeNavItem(label: 'Playground', iconOutlined: Icons.park_outlined, iconFilled: Icons.park_rounded),
  HomeNavItem(label: 'Profile', iconOutlined: Icons.person_outline_rounded, iconFilled: Icons.person_rounded),
];

/// Custom dark bottom navigation bar matching the home dashboard design:
/// flat outline icons when inactive, and a solid amber icon + label (with a
/// soft glow) for the active tab — no pill background.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.authBackgroundBottom,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < homeNavItems.length; i++)
              Expanded(
                child: _NavItemView(
                  item: homeNavItems[i],
                  selected: i == selectedIndex,
                  onTap: () => onSelect(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItemView extends StatelessWidget {
  const _NavItemView({required this.item, required this.selected, required this.onTap});

  final HomeNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.amberAccent : Colors.white38;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: selected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppColors.amberAccent.withValues(alpha: 0.35), blurRadius: 16, spreadRadius: 2),
                    ],
                  )
                : null,
            child: Icon(selected ? item.iconFilled : item.iconOutlined, color: color, size: 24),
          ),
          const SizedBox(height: 5),
          Text(
            item.label,
            style: TextStyle(color: color, fontSize: 10.5, fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
