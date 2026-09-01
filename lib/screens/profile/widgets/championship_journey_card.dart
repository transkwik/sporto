import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Championship progress banner with a 5-node track. Use [compact] for the
/// profile-tab version (title inside the card) or leave it false for the
/// details page (external header + "View" link + highlighted caption).
class ChampionshipJourneyCard extends StatelessWidget {
  const ChampionshipJourneyCard({
    super.key,
    this.compact = true,
    this.onView,
  });

  final bool compact;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A4A38), Color(0xFF0E1620)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  compact ? 'Your Championship Journey' : 'Your Championship Journey',
                  style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
                ),
              ),
              if (!compact) const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 18),
            ],
          ),
          const SizedBox(height: 18),
          const _JourneyTrack(showChecks: true),
          const SizedBox(height: 14),
          if (compact)
            Text(
              "You're qualified for District Championship — register before Aug 30.",
              style: TextStyle(color: AppColors.mintGreen.withValues(alpha: 0.85), fontSize: 12, height: 1.35),
            )
          else
            Text.rich(
              TextSpan(
                style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                children: [
                  const TextSpan(text: "You're qualified for "),
                  TextSpan(
                    text: 'District Championship',
                    style: TextStyle(color: AppColors.amberAccent, fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: ' — register before Aug 30.'),
                ],
              ),
            ),
        ],
      ),
    );

    if (compact) return card;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Championship Journey',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            GestureDetector(
              onTap: onView,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View', style: TextStyle(color: AppColors.mintGreen, fontSize: 13, fontWeight: FontWeight.w700)),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, color: AppColors.mintGreen, size: 18),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        card,
      ],
    );
  }
}

class _JourneyTrack extends StatelessWidget {
  const _JourneyTrack({this.showChecks = false});

  final bool showChecks;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _JourneyNode(style: _NodeStyle.done, showCheck: showChecks),
        const Expanded(child: _JourneyLine(active: true)),
        _JourneyNode(style: _NodeStyle.done, showCheck: showChecks),
        const Expanded(child: _JourneyLine(active: true)),
        const _JourneyNode(style: _NodeStyle.current),
        const Expanded(child: _JourneyLine(active: false)),
        const _JourneyNode(style: _NodeStyle.locked),
        const Expanded(child: _JourneyLine(active: false)),
        const _JourneyNode(style: _NodeStyle.locked),
      ],
    );
  }
}

enum _NodeStyle { done, current, locked }

class _JourneyNode extends StatelessWidget {
  const _JourneyNode({required this.style, this.showCheck = false});

  final _NodeStyle style;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    late final Color fill;
    late final Widget child;

    switch (style) {
      case _NodeStyle.done:
        fill = AppColors.mintGreen;
        child = showCheck
            ? const Icon(Icons.check_rounded, color: Colors.black87, size: 14)
            : const SizedBox.shrink();
      case _NodeStyle.current:
        fill = AppColors.amberAccent;
        child = const Icon(Icons.local_fire_department_rounded, color: Colors.black87, size: 14);
      case _NodeStyle.locked:
        fill = const Color(0xFF243040);
        child = const Icon(Icons.lock_rounded, color: Colors.white38, size: 12);
    }

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: style == _NodeStyle.locked ? Border.all(color: AppColors.glassBorder) : null,
      ),
      child: child,
    );
  }
}

class _JourneyLine extends StatelessWidget {
  const _JourneyLine({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: active ? AppColors.mintGreen.withValues(alpha: 0.7) : AppColors.glassBorderStrong,
    );
  }
}
