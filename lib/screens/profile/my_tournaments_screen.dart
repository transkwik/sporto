import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/live_match_detail_info.dart';
import '../../models/my_tournament_info.dart';
import '../../models/profile_info.dart';
import '../Matches/lmatch_detail_screen.dart';
import 'my_tournament_details_screen.dart';
import 'widgets/my_tournament_card.dart';
import 'widgets/profile_sport_chips.dart';

/// Profile → My Tournaments: sport filter plus Live / Upcoming / Completed.
class MyTournamentsScreen extends StatefulWidget {
  const MyTournamentsScreen({super.key});

  @override
  State<MyTournamentsScreen> createState() => _MyTournamentsScreenState();
}

class _MyTournamentsScreenState extends State<MyTournamentsScreen> {
  int _selectedSport = 0;
  MyTournamentStatus _tab = MyTournamentStatus.live;

  static const _filters = dummyProfileSports;
  static const _tabs = [
    (MyTournamentStatus.live, 'Live'),
    (MyTournamentStatus.upcoming, 'Upcoming'),
    (MyTournamentStatus.completed, 'Completed'),
  ];

  String get _sportLabel => _filters[_selectedSport].$2;

  List<MyTournamentInfo> get _items => dummyMyTournaments
      .where((t) => t.sport == _sportLabel && t.status == _tab)
      .toList();

  void _openDetails(MyTournamentInfo tournament) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MyTournamentDetailsScreen(tournament: tournament)),
    );
  }

  void _onCta(MyTournamentInfo tournament) {
    if (tournament.status == MyTournamentStatus.live) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const LiveMatchDetailScreen(match: dummyLiveMatchDetail),
        ),
      );
      return;
    }
    _openDetails(tournament);
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
                      'My Tournaments',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProfileSportChips(
                  sports: _filters,
                  selectedIndex: _selectedSport,
                  onSelect: (index) => setState(() => _selectedSport = index),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    for (final (status, label) in _tabs)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tab = status),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            children: [
                              Text(
                                label,
                                style: GoogleFonts.quicksand(
                                  color: _tab == status ? Colors.white : Colors.white54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: _tab == status ? const Color(0xFFFF8A1E) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No ${_tab.name} $_sportLabel tournaments.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final tournament = items[index];
                          return MyTournamentCard(
                            tournament: tournament,
                            onTap: () => _openDetails(tournament),
                            onCta: () => _onCta(tournament),
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
