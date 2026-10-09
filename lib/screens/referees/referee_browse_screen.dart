import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_detail_screen.dart';
import 'widgets/referee_assignment_card.dart';

/// Book Now / View all: list of officials.
class RefereeBrowseScreen extends StatelessWidget {
  const RefereeBrowseScreen({
    super.key,
    this.title = 'Book Officials',
    this.officials = dummyAvailableReferees,
    this.draft,
  });

  final String title;
  final List<RefereeOfficial> officials;
  final RefereeBookingDraft? draft;

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
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  itemCount: officials.length,
                  itemBuilder: (context, index) {
                    final official = officials[index];
                    return RefereeOfficialCard(
                      official: official,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RefereeDetailScreen(
                              official: official,
                              draft: draft,
                            ),
                          ),
                        );
                      },
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
