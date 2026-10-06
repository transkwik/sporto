import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/my_tournament_info.dart';
import '../../models/team_up_info.dart';
import '../profile/tournaments/my_tournament_details_screen.dart';
import 'team_up_register_screen.dart';
import 'widgets/team_up_featured_card.dart';

/// Opened from the Team Up list after tapping a tournament card.
class TeamUpEventScreen extends StatefulWidget {
  const TeamUpEventScreen({super.key, required this.tournament});

  final TeamUpTournament tournament;

  @override
  State<TeamUpEventScreen> createState() => _TeamUpEventScreenState();
}

class _TeamUpEventScreenState extends State<TeamUpEventScreen> {
  late int _sport;
  late TeamUpTournament _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.tournament;
    final index = dummyTeamUpSports.indexWhere((s) => s.label == widget.tournament.sport);
    _sport = index < 0 ? 0 : index;
  }

  void _selectSport(int index) {
    setState(() {
      _sport = index;
      final label = dummyTeamUpSports[index].label;
      if (_selected.sport != label) {
        final next = dummyTeamUpTournaments.where((t) => t.sport == label);
        if (next.isNotEmpty) _selected = next.first;
      }
    });
  }

  void _openRegister(TeamUpTournament t) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeamUpRegisterScreen(tournament: t)),
    );
  }

  void _openDetails(TeamUpTournament t) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MyTournamentDetailsScreen(
          tournament: MyTournamentInfo(
            id: t.id,
            sport: t.sport,
            status: MyTournamentStatus.upcoming,
            roundLabel: 'Open',
            title: t.title.replaceAll('\n', ' '),
            location: t.venue,
            teamA: 'Your match',
            teamB: 'TBD',
            statusLine: t.dateLabel,
            ctaLabel: 'View Details',
            dateRange: t.dateLabel,
            prizeEarned: t.prizePool,
            prizeCaption: 'Prize pool',
            squad: const [
              MyTournamentPlayerStat(
                name: 'You',
                role: 'To be matched',
                runs: 0,
                wickets: 0,
                isYou: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    const _HeroCard(),
                    const SizedBox(height: 18),
                    Text(
                      'Choose a Sport',
                      style: GoogleFonts.quicksand(
                        color: AppColors.infoBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 118,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        primary: false,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(right: 16),
                        itemCount: dummyTeamUpSports.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final sport = dummyTeamUpSports[index];
                          return _SportTile(
                            sport: sport,
                            selected: _sport == index,
                            onTap: () => _selectSport(index),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Tournament History',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View all',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TeamUpFeaturedCard(
                      tournament: _selected,
                      onTap: () => _openDetails(_selected),
                    ),
                    const SizedBox(height: 16),
                    const _HowItWorksCard(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GestureDetector(
                  onTap: () => _openRegister(_selected),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: AppColors.bannerGradient,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8A1E).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'Register Individually',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SportTile extends StatelessWidget {
  const _SportTile({
    required this.sport,
    required this.selected,
    required this.onTap,
  });

  final TeamUpSportOption sport;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.onboardingHeroCard.withValues(alpha: 0.5),
            border: Border.all(color: AppColors.onboardingHeroCard),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF15181F),
                  gradient: selected
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7EB6D8), Color(0xFF3E7CA8)],
                        )
                      : RadialGradient(
                          center: const Alignment(0, -0.35),
                          radius: 0.95,
                          colors: sport.tileColors,
                        ),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF8EC4E0)
                        : const Color(0xFF2A2E38),
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4A8BB8).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Icon(sport.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                sport.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: selected ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  AppAssets.sportoLogo,
                  width: 62,
                  height: 62,
                  fit: BoxFit. contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 52,
                    height: 52,
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
                      style: GoogleFonts.quicksand(
                        color: const Color(0xFFE85A6B),
                        fontSize: 12.5,
                        // fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.onboardingHeroCard.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.onboardingHeroCard),
            ),
            child: Text(
              'SPOTO Finds Your Team',
              style: GoogleFonts.quicksand(
                color: AppColors.mintGreen,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How Team Up Works',
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < dummyTeamUpHowItWorks.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3A93D),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: GoogleFonts.quicksand(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    dummyTeamUpHowItWorks[i],
                    style: GoogleFonts.quicksand(
                      color: Colors.white70,
                      fontSize: 13.5,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (i < dummyTeamUpHowItWorks.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
