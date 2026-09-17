import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import 'notification_category_screen.dart';

class _NotificationGroup {
  const _NotificationGroup({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.prefs,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<NotificationPref> prefs;
}

const _groups = [
  _NotificationGroup(
    emoji: '🔔',
    title: 'Match Notifications',
    subtitle: 'Captain, Batter, Bowler',
    prefs: [
      NotificationPref(
        id: 'match_reminders',
        title: 'Match Reminders',
        subtitle: 'Get notified before your matches start.',
      ),
      NotificationPref(
        id: 'match_starting',
        title: 'Match Starting Soon',
        subtitle: 'Reminder 30 minutes before your match.',
      ),
      NotificationPref(
        id: 'live_match',
        title: 'Live Match Updates',
        subtitle: 'Get important updates while a match is live.',
        enabled: true,
      ),
      NotificationPref(
        id: 'match_results',
        title: 'Match Results',
        subtitle: 'Get notified when your match ends.',
      ),
    ],
  ),
  _NotificationGroup(
    emoji: '🏆',
    title: 'Tournament Updates',
    subtitle: 'Captain, Batter, Bowler',
    prefs: [
      NotificationPref(
        id: 'tournament_updates',
        title: 'Tournament Updates',
        subtitle: 'Schedule changes, round progression and important updates.',
      ),
      NotificationPref(
        id: 'fixture_changes',
        title: 'Fixture & Schedule Changes',
        subtitle: 'Get notified when match time, venue or opponent changes.',
      ),
      NotificationPref(
        id: 'tournament_announcements',
        title: 'Tournament Announcements',
        subtitle: 'Important announcements from tournament organizers.',
        enabled: true,
      ),
    ],
  ),
  _NotificationGroup(
    emoji: '👥',
    title: 'Team & Requests',
    subtitle: 'Captain, Batter, Bowler',
    prefs: [
      NotificationPref(
        id: 'team_invites',
        title: 'Team Invitations',
        subtitle: 'When someone invites you to join their team.',
      ),
      NotificationPref(
        id: 'team_join',
        title: 'Team Join Requests',
        subtitle: 'Updates when your team join request is accepted or declined.',
      ),
      NotificationPref(
        id: 'team_updates',
        title: 'Team Updates',
        subtitle: 'Important changes to your team or squad.',
        enabled: true,
      ),
    ],
  ),
  _NotificationGroup(
    emoji: '💳',
    title: 'Registration & Payments',
    subtitle: 'Captain, Batter, Bowler',
    prefs: [
      NotificationPref(
        id: 'registration_updates',
        title: 'Registration Updates',
        subtitle: 'Registration approval, rejection or status changes.',
      ),
      NotificationPref(
        id: 'payment_updates',
        title: 'Payment Updates',
        subtitle: 'Payment confirmation, pending payments or refunds.',
      ),
    ],
  ),
  _NotificationGroup(
    emoji: '📢',
    title: 'Others',
    subtitle: 'Captain, Batter, Bowler',
    prefs: [
      NotificationPref(
        id: 'nearby_alerts',
        title: 'Nearby Tournament Alerts',
        subtitle: 'Get notified about relevant tournaments near you.',
      ),
      NotificationPref(
        id: 'promo_updates',
        title: 'Promotional Updates',
        subtitle: 'New features, offers and occasional Sporto updates.',
      ),
    ],
  ),
];

/// Profile → Settings → Notification Settings hub.
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      'Notification Settings',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  children: [
                    Text(
                      'Choose what you want to be notified about.',
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final group in _groups) ...[
                      _CategoryTile(
                        emoji: group.emoji,
                        title: group.title,
                        subtitle: group.subtitle,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NotificationCategoryScreen(
                                title: group.title,
                                prefs: group.prefs,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.quicksand(
                      color: Colors.white54,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 22),
          ],
        ),
      ),
    );
  }
}
