import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_up_info.dart';
import 'team_up_event_screen.dart';
import 'widgets/team_up_tournament_card.dart';

/// Home → Team Up list. Tapping a tournament opens the event screen.
class TeamUpScreen extends StatefulWidget {
  const TeamUpScreen({super.key});

  @override
  State<TeamUpScreen> createState() => _TeamUpScreenState();
}

class _TeamUpScreenState extends State<TeamUpScreen> {
  int _sport = 0;
  int _filter = 0;

  List<TeamUpTournament> get _items {
    final sport = dummyTeamUpChipSports[_sport].$2;
    var list = dummyTeamUpTournaments
        .where((t) => sport == 'All' || t.sport == sport)
        .toList();
    switch (_filter) {
      case 1:
        list.sort((a, b) => a.closingDays.compareTo(b.closingDays));
      case 2:
        list.sort((a, b) => a.entryFee.compareTo(b.entryFee));
      case 3:
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      default:
        break;
    }
    return list;
  }

  void _openEvent(TeamUpTournament tournament) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeamUpEventScreen(tournament: tournament)),
    );
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
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Text(
                      'Team Up',
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    const _ListHeroCard(),
                    const SizedBox(height: 18),
                    Text(
                      'Choose Tournaments',
                      style: GoogleFonts.quicksand(
                        color: AppColors.infoBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dummyTeamUpChipSports.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final (icon, label) = dummyTeamUpChipSports[index];
                          final selected = _sport == index;
                          return GestureDetector(
                            onTap: () => setState(() => _sport = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.mintGreen : const Color(0xFF1A1E28),
                                borderRadius: BorderRadius.circular(14),
                                border: selected
                                    ? null
                                    : Border.all(color: AppColors.glassBorderStrong),
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
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dummyTeamUpFilters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final selected = _filter == index;
                          return GestureDetector(
                            onTap: () => setState(() => _filter = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected ? AppColors.infoBlue : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: selected ? AppColors.infoBlue : AppColors.glassBorderStrong,
                                ),
                              ),
                              child: Text(
                                dummyTeamUpFilters[index],
                                style: GoogleFonts.quicksand(
                                  color: selected ? Colors.black : Colors.white70,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Select Tournament',
                      style: GoogleFonts.quicksand(
                        color: AppColors.infoBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: Text(
                            'No Team Up tournaments yet',
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                          ),
                        ),
                      )
                    else
                      for (final t in items) ...[
                        TeamUpTournamentCard(
                          tournament: t,
                          onTap: () => _openEvent(t),
                        ),
                        const SizedBox(height: 12),
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

class _ListHeroCard extends StatelessWidget {
  const _ListHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  AppAssets.sportoLogo,
                  width: 52,
                  height: 52,
                  fit: BoxFit. contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 62,
                    height: 62,
                    alignment: Alignment.center,
                    color: const Color(0xFF222632),
                    child: Text(
                      'Spoto',
                      style: GoogleFonts.quicksand(
                        color: AppColors.amberAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPOTO TEAM UP',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"Don\'t have a team? No problem."',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts. aBeeZee(
                        color: Colors.red,
                        fontSize: 12.5,
                        fontStyle: FontStyle. normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.onboardingHeroCard,
              border: Border.all(color: AppColors. onboardingHeroCard ),
              // color: AppColors.mintGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Find a tournament. Register. Get matched with your team.',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                color: AppColors.mintGreen,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
