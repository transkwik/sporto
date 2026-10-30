import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../models/completed_match_detail_info.dart';
import '../../../models/match_data_parser.dart';
import '../../../models/my_tournament_info.dart';
import '../../../models/profile_info.dart';
import '../../Matches/completed_match_detail_screen.dart';
import '../../Matches/lmatch_detail_screen.dart';
import '../../home/providers/home_provider.dart';
import 'widgets/my_tournament_card.dart';
import '../widgets/profile_sport_chips.dart';

/// Profile → All Tournaments: same Live / Upcoming / Completed cards as
/// My Tournaments, backed by the Live / Upcoming / History match APIs.
class AllTournamentsScreen extends StatefulWidget {
  const AllTournamentsScreen({super.key});

  @override
  State<AllTournamentsScreen> createState() => _AllTournamentsScreenState();
}

class _AllTournamentsScreenState extends State<AllTournamentsScreen> {
  int _selectedSport = 0;
  MyTournamentStatus _tab = MyTournamentStatus.live;
  final ScrollController _scrollController = ScrollController();

  static const _tabs = [
    (MyTournamentStatus.live, 'Live'),
    (MyTournamentStatus.upcoming, 'Upcoming'),
    (MyTournamentStatus.completed, 'Completed'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAll(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  IconData _iconForSport(String name) {
    switch (name.toLowerCase()) {
      case 'cricket':
        return Icons.sports_cricket_rounded;
      case 'football':
        return Icons.sports_soccer_rounded;
      case 'badminton':
        return Icons.sports_tennis_rounded;
      case 'kabaddi':
        return Icons.sports_martial_arts_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  List<(IconData, String)> _sportFilters(HomeProvider provider) {
    if (provider.sportsList.isEmpty) {
      return [(Icons.apps_rounded, 'All'), ...dummyProfileSports];
    }
    return [
      (Icons.apps_rounded, 'All'),
      ...provider.sportsList.map((s) {
        final name = (s is Map ? s['name'] : null)?.toString() ?? 'Sport';
        return (_iconForSport(name), name);
      }),
    ];
  }

  String _currentSportId(HomeProvider provider) {
    if (_selectedSport == 0 || provider.sportsList.isEmpty) return '';
    final index = _selectedSport - 1;
    if (index < 0 || index >= provider.sportsList.length) return '';
    return provider.sportsList[index]['id']?.toString() ?? '';
  }

  void _fetchAll({required bool isRefresh}) {
    final provider = context.read<HomeProvider>();
    if (isRefresh && provider.sportsList.isEmpty) {
      provider.fetchSports();
    }
    final sportId = _currentSportId(provider);
    provider.fetchLiveMatches(sportId, isRefresh: isRefresh);
    provider.fetchUpcomingMatches(sportId, isRefresh: isRefresh);
    provider.fetchAllMatches(sportId, isRefresh: isRefresh);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }
    final provider = context.read<HomeProvider>();
    final sportId = _currentSportId(provider);

    switch (_tab) {
      case MyTournamentStatus.live:
        if (!provider.isFetchingLiveMatches &&
            !provider.isFetchingMoreLiveMatches) {
          provider.fetchLiveMatches(sportId, isRefresh: false);
        }
      case MyTournamentStatus.upcoming:
        if (!provider.isFetchingUpcomingMatches &&
            !provider.isFetchingMoreUpcomingMatches) {
          provider.fetchUpcomingMatches(sportId, isRefresh: false);
        }
      case MyTournamentStatus.completed:
        if (!provider.isFetchingAllMatches &&
            !provider.isFetchingMoreAllMatches) {
          provider.fetchAllMatches(sportId, isRefresh: false);
        }
    }
  }

  MyTournamentInfo _toTournamentInfo(Map<String, dynamic> matchData) {
    final nested = matchData['match'];
    final id = matchData['id'] ??
        (nested is Map ? nested['id'] : null) ??
        0;

    final sportName =
        matchData['sport']?['name']?.toString() ?? 'Unknown Sport';
    final tournamentName = matchData['tournament']?['name'];
    final formatName = matchData['format']?['name'];

    String title = 'Tournament';
    if (tournamentName != null && formatName != null) {
      title = '$tournamentName • $formatName';
    } else if (tournamentName != null) {
      title = tournamentName.toString();
    } else if (formatName != null) {
      title = formatName.toString();
    } else if (matchData['title'] != null) {
      title = matchData['title'].toString();
    }

    final location = matchData['venue']?['name']?.toString() ??
        matchData['ground']?.toString() ??
        matchData['city']?.toString() ??
        '';

    final roundLabel = matchData['round']?['name']?.toString() ??
        (matchData['stage'] is Map
            ? matchData['stage']['name']?.toString()
            : matchData['stage']?.toString()) ??
        'Match';

    final teamA = MatchDataParser.team(matchData, isA: true).name;
    final teamB = MatchDataParser.team(matchData, isA: false).name;

    final timeLabel = MatchDataParser.timeLabel(matchData);
    final String statusLine = switch (_tab) {
      MyTournamentStatus.live => MatchDataParser.liveStatus(matchData),
      MyTournamentStatus.upcoming =>
        timeLabel.isNotEmpty ? timeLabel : MatchDataParser.startsIn(matchData),
      MyTournamentStatus.completed =>
        matchData['status_label']?.toString() ?? 'Completed',
    };

    return MyTournamentInfo(
      id: id.toString(),
      sport: sportName,
      status: _tab,
      roundLabel: roundLabel,
      title: title,
      location: location,
      teamA: teamA,
      teamB: teamB,
      statusLine: statusLine,
      ctaLabel: _tab == MyTournamentStatus.live ? 'Watch Live Now' : null,
      dateRange: MatchDataParser.dateShort(matchData),
      championTeam: MatchDataParser.winnerName(matchData),
    );
  }

  void _openMatchDetails(Map<String, dynamic> matchData) {
    if (_tab == MyTournamentStatus.completed) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CompletedMatchDetailScreen(
            match: CompletedMatchDetailInfo.fromMatchData(matchData),
          ),
        ),
      );
      return;
    }

    final nested = matchData['match'];
    final rawId = matchData['id'] ?? (nested is Map ? nested['id'] : null);
    final matchId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 3665;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiveMatchDetailScreen(matchId: matchId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        final filters = _sportFilters(provider);
        final safeSportIndex = _selectedSport.clamp(0, filters.length - 1);
        final sportLabel = filters[safeSportIndex].$2;

        final List<Map<String, dynamic>> rawItems;
        final bool isLoading;
        final bool isFetchingMore;

        switch (_tab) {
          case MyTournamentStatus.live:
            rawItems = provider.liveMatchesList;
            isLoading = provider.isFetchingLiveMatches && rawItems.isEmpty;
            isFetchingMore = provider.isFetchingMoreLiveMatches;
          case MyTournamentStatus.upcoming:
            rawItems = provider.upcomingMatchesList;
            isLoading = provider.isFetchingUpcomingMatches && rawItems.isEmpty;
            isFetchingMore = provider.isFetchingMoreUpcomingMatches;
          case MyTournamentStatus.completed:
            rawItems = provider.allMatchesList;
            isLoading = provider.isFetchingAllMatches && rawItems.isEmpty;
            isFetchingMore = provider.isFetchingMoreAllMatches;
        }

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
                        GlassBackButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'All Tournaments',
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
                      sports: filters,
                      selectedIndex: safeSportIndex,
                      onSelect: (index) {
                        setState(() => _selectedSport = index);
                        _fetchAll(isRefresh: true);
                      },
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
                              onTap: () {
                                setState(() => _tab = status);
                                if (_scrollController.hasClients) {
                                  _scrollController.jumpTo(0);
                                }
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
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : rawItems.isEmpty
                            ? RefreshIndicator(
                                onRefresh: () async =>
                                    _fetchAll(isRefresh: true),
                                color: AppColors.mintGreen,
                                backgroundColor: const Color(0xFF161A24),
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    ),
                                    Center(
                                      child: Text(
                                        'No ${_tab.name} ${sportLabel == 'All' ? '' : '$sportLabel '}tournaments.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.quicksand(
                                          color: Colors.white54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () async =>
                                    _fetchAll(isRefresh: true),
                                color: AppColors.mintGreen,
                                backgroundColor: const Color(0xFF161A24),
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    16,
                                    20,
                                    28,
                                  ),
                                  itemCount: rawItems.length +
                                      (isFetchingMore ? 1 : 0),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 14),
                                  itemBuilder: (context, index) {
                                    if (index == rawItems.length) {
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: CircularProgressIndicator(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      );
                                    }
                                    final matchData = rawItems[index];
                                    final tournament =
                                        _toTournamentInfo(matchData);
                                    return MyTournamentCard(
                                      tournament: tournament,
                                      onTap: () =>
                                          _openMatchDetails(matchData),
                                      onCta: () =>
                                          _openMatchDetails(matchData),
                                    );
                                  },
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
