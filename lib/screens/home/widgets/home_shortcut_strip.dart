import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Horizontal shortcut tiles on Home, above Upcoming Matches.
class HomeShortcutStrip extends StatelessWidget {
  const HomeShortcutStrip({
    super.key,
    required this.onTeamUp,
    required this.onVenues,
    required this.onWallet,
    required this.onStats,
    required this.onCelebrate,
    required this.onSponsors,
  });

  final VoidCallback onTeamUp;
  final VoidCallback onVenues;
  final VoidCallback onWallet;
  final VoidCallback onStats;
  final VoidCallback onCelebrate;
  final VoidCallback onSponsors;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.sports_cricket_rounded, 'Team Up', 'No Team? OK!'),
      (Icons.sports_cricket_rounded, 'Venues', 'Book & Play'),
      (Icons.sports_cricket_rounded, 'Wallet', 'Prizes & Credits'),
      (Icons.sports_cricket_rounded, 'Stats', 'Form & Rank'),
      (Icons.celebration_rounded, 'Celebrate', 'Fan Support'),
      (Icons.workspace_premium_rounded, 'Sponsors', 'Fund a Prize'),
    ];
    final actions = [onTeamUp, onVenues, onWallet, onStats, onCelebrate, onSponsors];

    return SizedBox(
      height: 142,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final (icon, title, subtitle) = items[index];
          return _ShortcutCard(
            icon: icon,
            title: title,
            subtitle: subtitle,
            onTap: actions[index],
          );
        },
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 132,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1508),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF5A4A18).withValues(alpha: 0.55)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF2A220C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(
                color: Colors.white54,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
