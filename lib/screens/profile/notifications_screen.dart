import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/inbox_notification.dart';

const _filters = [
  (null, 'All'),
  (InboxCategory.matches, 'Matches'),
  (InboxCategory.teams, 'Teams'),
  (InboxCategory.tournaments, 'Tournaments'),
  (InboxCategory.payments, 'Payments'),
];

/// Profile / header bell: notification inbox with category filters.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  InboxCategory? _filter;
  late List<InboxNotification> _items;

  @override
  void initState() {
    super.initState();
    _items = List<InboxNotification>.from(dummyInboxNotifications);
  }

  List<InboxNotification> get _visible => _filter == null
      ? _items
      : _items.where((n) => n.category == _filter).toList();

  void _remove(String id) {
    setState(() => _items.removeWhere((n) => n.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Text(
                      'Notifications',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final (category, label) = _filters[index];
                    final selected = _filter == category;
                    return GestureDetector(
                      onTap: () => setState(() => _filter = category),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.mintGreen : const Color(0xFF1A1E28),
                          borderRadius: BorderRadius.circular(18),
                          border: selected ? null : Border.all(color: AppColors.glassBorder),
                        ),
                        child: Text(
                          label,
                          style: GoogleFonts.quicksand(
                            color: selected ? Colors.black87 : Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No notifications yet.',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _InboxCard(
                            item: item,
                            onAccept: () => _remove(item.id),
                            onDecline: () => _remove(item.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Style {
  const _Style({
    required this.emoji,
    required this.titleColor,
    required this.background,
    this.border,
  });

  final String emoji;
  final Color titleColor;
  final Color background;
  final Color? border;
}

_Style _styleFor(InboxKind kind) {
  switch (kind) {
    case InboxKind.teamInvite:
      return const _Style(
        emoji: '📣',
        titleColor: Color(0xFFFF8A1E),
        background: Color(0xFF12261E),
        border: Color(0xFF1F4A38),
      );
    case InboxKind.matchStarting:
      return const _Style(
        emoji: '🔴',
        titleColor: Color(0xFFFF5A5A),
        background: Color(0xFF2A1518),
        border: Color(0xFF5A2A30),
      );
    case InboxKind.youWon:
      return const _Style(
        emoji: '🏆',
        titleColor: AppColors.mintGreen,
        background: Color(0xFF12261E),
        border: Color(0xFF1F4A38),
      );
    case InboxKind.tournamentUpdate:
      return const _Style(
        emoji: '📢',
        titleColor: Colors.white,
        background: Color(0xFF1A1E28),
      );
    case InboxKind.teamAccepted:
      return const _Style(
        emoji: '👥',
        titleColor: Colors.white,
        background: Color(0xFF1A1E28),
      );
    case InboxKind.payment:
      return const _Style(
        emoji: '📅',
        titleColor: AppColors.mintGreen,
        background: Color(0xFF12261E),
        border: Color(0xFF1F4A38),
      );
    case InboxKind.matchReminder:
      return const _Style(
        emoji: '📅',
        titleColor: Color(0xFFFF8A1E),
        background: Color(0xFF1A1E28),
      );
    case InboxKind.tournamentEnded:
      return const _Style(
        emoji: '🏆',
        titleColor: AppColors.mintGreen,
        background: Color(0xFF1A1E28),
      );
  }
}

class _InboxCard extends StatelessWidget {
  const _InboxCard({required this.item, this.onAccept, this.onDecline});

  final InboxNotification item;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(item.kind);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: style.border ?? AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(style.emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.title,
                  style: GoogleFonts.quicksand(
                    color: style.titleColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                item.timeLabel,
                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (item.kind == InboxKind.payment) ...[
            Text(
              '✓  Registration Payment Successful.',
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            item.body,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 13.5,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (item.teamA != null && item.teamB != null) ...[
            const SizedBox(height: 12),
            _VsRow(left: item.teamA!, right: item.teamB!),
          ],
          if (item.scoreA != null && item.scoreB != null) ...[
            const SizedBox(height: 12),
            _VsRow(left: item.scoreA!, right: item.scoreB!, muted: true),
          ],
          if (item.amountLine != null) ...[
            const SizedBox(height: 8),
            Text(
              item.amountLine!,
              style: GoogleFonts.quicksand(
                color: AppColors.mintGreen,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (item.meta != null || item.ctaLabel != null || item.kind == InboxKind.teamInvite) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (item.meta != null)
                  Expanded(
                    child: Text(
                      item.meta!,
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
                    ),
                  )
                else
                  const Spacer(),
                if (item.kind == InboxKind.teamInvite) ...[
                  GestureDetector(
                    onTap: onDecline,
                    child: Text(
                      'Decline',
                      style: GoogleFonts.quicksand(
                        color: const Color(0xFFFF8A1E),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onAccept,
                    child: Text(
                      'Accept',
                      style: GoogleFonts.quicksand(
                        color: AppColors.infoBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ] else if (item.ctaLabel != null)
                  Text(
                    '${item.ctaLabel}  >',
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFFFF8A1E),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _VsRow extends StatelessWidget {
  const _VsRow({required this.left, required this.right, this.muted = false});

  final String left;
  final String right;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = muted ? Colors.white54 : Colors.white;
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: GoogleFonts.quicksand(color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          'VS',
          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w700),
        ),
        Expanded(
          child: Text(
            right,
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
