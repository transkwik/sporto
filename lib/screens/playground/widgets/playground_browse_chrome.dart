import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

const playgroundLime = Color(0xFFC6F04D);

class ReadyToPlayBanner extends StatelessWidget {
  const ReadyToPlayBanner({super.key, required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: playgroundLime,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spoto Marketplace',
                  style: GoogleFonts.quicksand(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "I'm Ready To Play",
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Available  for teams',
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            onChanged: onChanged,
            activeTrackColor: Colors.black87,
            activeThumbColor: Colors.white,
            inactiveTrackColor: Colors.black26,
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class LimeSportChips extends StatelessWidget {
  const LimeSportChips({
    super.key,
    required this.sports,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<(IconData icon, String label)> sports;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final (icon, label) = sports[index];
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? playgroundLime : const Color(0xFF1A1E28),
                borderRadius: BorderRadius.circular(20),
                border: selected ? null : Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 15, color: selected ? Colors.black87 : Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: GoogleFonts.quicksand(
                      color: selected ? Colors.black87 : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlayerCaptainToggle extends StatelessWidget {
  const PlayerCaptainToggle({
    super.key,
    required this.isPlayer,
    required this.onChanged,
    this.playerLabel = "I'm a Player",
    this.captainLabel = "I'm a Captain",
  });

  final bool isPlayer;
  final ValueChanged<bool> onChanged;
  final String playerLabel;
  final String captainLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF141820),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Pill(
              icon: Icons.add_rounded,
              label: playerLabel,
              selected: isPlayer,
              onTap: () => onChanged(true),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _Pill(
              icon: Icons.groups_rounded,
              label: captainLabel,
              selected: !isPlayer,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? playgroundLime : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.black87 : Colors.white54),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  color: selected ? Colors.black87 : Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleUnderlineFilters extends StatelessWidget {
  const RoleUnderlineFilters({
    super.key,
    required this.roles,
    required this.selectedIndex,
    required this.onSelect,
    this.onSort,
  });

  final List<String> roles;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback? onSort;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: roles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final selected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => onSelect(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        roles[index],
                        style: GoogleFonts.quicksand(
                          color: selected ? Colors.white : Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 2.5,
                        width: selected ? 22 : 0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF8A1E),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: onSort,
          child: const Icon(Icons.swap_vert_rounded, color: Colors.white70, size: 22),
        ),
      ],
    );
  }
}
