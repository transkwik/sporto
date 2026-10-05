import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/sponsor_info.dart';
import 'sponsorship_screen.dart';
import 'widgets/sponsor_tournament_card.dart';

/// Home → Sponsors: browse tournaments that still need prize funding.
class SponsorScreen extends StatefulWidget {
  const SponsorScreen({super.key, this.tournaments = dummySponsorTournaments});

  final List<SponsorTournament> tournaments;

  @override
  State<SponsorScreen> createState() => _SponsorScreenState();
}

class _SponsorScreenState extends State<SponsorScreen> {
  int _sport = 0;

  void _openSponsorship(SponsorTournament tournament) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SponsorshipScreen(tournament: tournament)),
    );
  }

  List<SponsorTournament> get _items {
    final sport = dummySponsorSports[_sport].$2;
    if (sport == 'All') return widget.tournaments;
    return widget.tournaments.where((t) => t.sport == sport).toList();
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
                            'Sponsor A Tournament',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Browse upcoming tournaments and sponsor prize.',
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
                  itemCount: dummySponsorSports.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final (icon, label) = dummySponsorSports[index];
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
                          'No tournaments to sponsor yet',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return SponsorTournamentCard(
                            tournament: items[index],
                            onSponsor: () => _openSponsorship(items[index]),
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
