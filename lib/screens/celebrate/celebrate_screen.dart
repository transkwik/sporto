import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/celebrate_info.dart';
import 'celebrate_champion_screen.dart';
import 'widgets/celebrate_campaign_card.dart';

/// Home → Celebrate: champion teams with open or closed fan support.
class CelebrateScreen extends StatefulWidget {
  const CelebrateScreen({super.key, this.campaigns = dummyCelebrateCampaigns});

  final List<CelebrateCampaign> campaigns;

  @override
  State<CelebrateScreen> createState() => _CelebrateScreenState();
}

class _CelebrateScreenState extends State<CelebrateScreen> {
  int _sport = 0;

  List<CelebrateCampaign> get _items {
    final sport = dummyCelebrateSports[_sport].$2;
    if (sport == 'All') return widget.campaigns;
    return widget.campaigns.where((c) => c.sport == sport).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Celebrate',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Show your support to the athletes who gave it their all',
                            style: GoogleFonts.quicksand(
                              color: Colors.white54,
                              fontSize: 12.5,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: dummyCelebrateSports.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final (icon, label) = dummyCelebrateSports[index];
                    final selected = _sport == index;
                    return GestureDetector(
                      onTap: () => setState(() => _sport = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.mintGreen : const Color(0xFF1A1E28),
                          borderRadius: BorderRadius.circular(20),
                          border: selected ? null : Border.all(color: AppColors.glassBorderStrong),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(
                                icon,
                                size: 15,
                                color: selected ? Colors.black87 : Colors.white70,
                              ),
                              const SizedBox(width: 7),
                            ],
                            Text(
                              label,
                              style: GoogleFonts.quicksand(
                                color: selected ? Colors.black87 : Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No Celebrate campaigns yet',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final campaign = items[index];
                          void open() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CelebrateChampionScreen(campaign: campaign),
                              ),
                            );
                          }

                          return CelebrateCampaignCard(
                            campaign: campaign,
                            onTap: open,
                            onAction: open,
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
