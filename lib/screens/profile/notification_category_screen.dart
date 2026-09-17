import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import 'widgets/notification_toggle_tile.dart';

class NotificationPref {
  const NotificationPref({
    required this.id,
    required this.title,
    required this.subtitle,
    this.enabled = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool enabled;
}

/// One notification category: title, caption, and independent toggles.
class NotificationCategoryScreen extends StatefulWidget {
  const NotificationCategoryScreen({
    super.key,
    required this.title,
    required this.prefs,
  });

  final String title;
  final List<NotificationPref> prefs;

  @override
  State<NotificationCategoryScreen> createState() => _NotificationCategoryScreenState();
}

class _NotificationCategoryScreenState extends State<NotificationCategoryScreen> {
  late Map<String, bool> _values;

  @override
  void initState() {
    super.initState();
    _values = {for (final pref in widget.prefs) pref.id: pref.enabled};
  }

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
                    Expanded(
                      child: Text(
                        widget.title,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
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
                    for (final pref in widget.prefs) ...[
                      NotificationToggleTile(
                        title: pref.title,
                        subtitle: pref.subtitle,
                        value: _values[pref.id] ?? false,
                        onChanged: (next) => setState(() => _values[pref.id] = next),
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
