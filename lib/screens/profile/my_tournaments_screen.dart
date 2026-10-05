import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/apiServices/user_api.dart';
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
    (MyTournamentStatus.live, 'Live', '2'),
    (MyTournamentStatus.upcoming, 'Upcoming', '1'),
    (MyTournamentStatus.completed, 'Completed', '3'),
  ];

  final List<MyTournamentInfo> _items = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  int _lastPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchTournaments(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchTournaments(isRefresh: false);
    }
  }

  String get _sportLabel => _filters[_selectedSport].$2;
  String get _currentStatusStr => _tabs.firstWhere((t) => t.$1 == _tab).$3;

  Future<void> _fetchTournaments({required bool isRefresh}) async {
    if (isRefresh) {
      _currentPage = 1;
      setState(() => _isLoading = true);
      _items.clear();
    } else {
      if (_currentPage > _lastPage || _isFetchingMore) return;
      setState(() => _isFetchingMore = true);
    }

    try {
      final response = await UserApis().getMyTournaments(
        _currentPage,
        15,
        status: _currentStatusStr,
      );

      if (response != null && response['success'] == true) {
        final data = response['data'] as List<dynamic>?;
        if (data != null) {
          final mappedData = data.map((e) {
            final json = e as Map<String, dynamic>;
            final statusInt = json['status'] as int? ?? 0;
            MyTournamentStatus computedStatus;
            if (statusInt == 1) {
              computedStatus = MyTournamentStatus.upcoming;
            } else if (statusInt == 2) {
              computedStatus = MyTournamentStatus.live;
            } else {
              computedStatus = MyTournamentStatus.completed;
            }

            final teamA = json['my_participation']?['team_name']?.toString() ?? 'My Team';
            final teamB = json['next_match']?['opponent']?['name']?.toString() ?? 'TBD';
            final roundLabel = json['next_match']?['round']?['name']?.toString() ?? 'TBD';

            return MyTournamentInfo(
              id: json['id']?.toString() ?? '0',
              sport: json['sport']?['name']?.toString() ?? 'Unknown',
              status: computedStatus,
              roundLabel: roundLabel,
              title: json['name']?.toString() ?? 'Unknown Tournament',
              location: json['venue']?.toString() ?? '',
              teamA: teamA,
              teamB: teamB,
              statusLine: json['dates']?['tournament_start_at']?.toString() ?? '',
            );
          }).toList();

          setState(() {
            if (isRefresh) {
              _items.clear();
            }
            _items.addAll(mappedData);
            _currentPage++;
            _lastPage = response['meta']?['last_page'] ?? 1;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching my tournaments: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  void _openDetails(MyTournamentInfo tournament) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MyTournamentDetailsScreen(tournament: tournament),
      ),
    );
  }

  void _onCta(MyTournamentInfo tournament) {
    if (tournament.status == MyTournamentStatus.live) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const LiveMatchDetailScreen(
            match: dummyLiveMatchDetail,
            matchId: 3665, // Should update with actual match id later if available in my_tournaments API
          ),
        ),
      );
      return;
    }
    _openDetails(tournament);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
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
                  onSelect: (index) {
                    setState(() => _selectedSport = index);
                    // Usually we would pass sport_id, but the backend doesn't seem to filter by sport_id in this snippet unless we map it.
                    _fetchTournaments(isRefresh: true);
                  },
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    for (final (status, label, _) in _tabs)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _tab = status);
                            _fetchTournaments(isRefresh: true);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            children: [
                              Text(
                                label,
                                style: GoogleFonts.quicksand(
                                  color: _tab == status
                                      ? Colors.white
                                      : Colors.white54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: _tab == status
                                      ? const Color(0xFFFF8A1E)
                                      : Colors.transparent,
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : _items.isEmpty
                        ? Center(
                            child: Text(
                              'No ${_tab.name} $_sportLabel tournaments.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                            itemCount: _items.length + (_isFetchingMore ? 1 : 0),
                            separatorBuilder: (_, __) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              if (index == _items.length) {
                                return const Center(
                                  child: CircularProgressIndicator(color: AppColors.primary),
                                );
                              }
                              final tournament = _items[index];
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
