import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/match_info.dart';
import '../../models/match_data_parser.dart';
import '../home/providers/home_provider.dart';
import '../home/widgets/home_header.dart';
import '../home/widgets/home_search_bar.dart';
import '../home/widgets/sport_icon_button.dart';
import 'lmatch_detail_screen.dart';
import 'completed_match_detail_screen.dart';
import '../../models/completed_match_detail_info.dart';
import '../profile/notifications/notifications_screen.dart';
import 'widgets/match_feed_card.dart';
import 'widgets/match_feed_tabs.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int _selectedCategory = 0;
  int _tabIndex = 0;
  final ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listScrollController.addListener(_onListScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<HomeProvider>();
      if (provider.sportsList.isEmpty) {
        await provider.fetchSports();
      }
      if (provider.sportsList.isNotEmpty) {
        if (mounted) {
          final sportId = _selectedCategory == 0 ? '' : provider.sportsList[_selectedCategory - 1]['id'];
          provider.fetchLiveMatches(sportId, isRefresh: true);
          provider.fetchUpcomingMatches(sportId, isRefresh: true);
          provider.fetchAllMatches(sportId, isRefresh: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  dynamic _currentSportId(HomeProvider provider) {
    return _selectedCategory == 0 ? '' : provider.sportsList[_selectedCategory - 1]['id'];
  }

  void _onListScroll() {
    if (!_listScrollController.hasClients) return;
    if (_listScrollController.position.pixels < _listScrollController.position.maxScrollExtent - 200) {
      return;
    }

    final provider = context.read<HomeProvider>();
    if (provider.sportsList.isEmpty) return;
    final sportId = _currentSportId(provider);

    if (_tabIndex == 0) {
      if (!provider.isFetchingLiveMatches && !provider.isFetchingMoreLiveMatches) {
        provider.fetchLiveMatches(sportId, isRefresh: false);
      }
    } else if (_tabIndex == 1) {
      if (!provider.isFetchingUpcomingMatches && !provider.isFetchingMoreUpcomingMatches) {
        provider.fetchUpcomingMatches(sportId, isRefresh: false);
      }
    } else {
      if (!provider.isFetchingAllMatches && !provider.isFetchingMoreAllMatches) {
        provider.fetchAllMatches(sportId, isRefresh: false);
      }
    }
  }

  void _openMatchDetail(BuildContext context, Map<String, dynamic> matchData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiveMatchDetailScreen(
          matchId: matchData['id'] as int? ?? 3665,
        ),
      ),
    );
  }

  void _openCompletedDetail(Map<String, dynamic> matchData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompletedMatchDetailScreen(
          match: CompletedMatchDetailInfo.fromMatchData(matchData),
        ),
      ),
    );
  }

  /// Maps one `/matches` API item to a feed card. Shared parsing lives in
  /// [MatchDataParser] so live, upcoming and completed tabs stay consistent.
  Widget _buildMatchCard(Map<String, dynamic> matchData) {
    final sportName = matchData['sport']?['name']?.toString() ?? 'Unknown Sport';
    final tournamentName = matchData['tournament']?['name'];
    final formatName = matchData['format']?['name'];

    String title = 'Tournament';
    if (tournamentName != null && formatName != null) {
      title = '$tournamentName • $formatName';
    } else if (tournamentName != null) {
      title = tournamentName.toString();
    } else if (formatName != null) {
      title = formatName.toString();
    }

    final teamA = MatchDataParser.team(matchData, isA: true);
    final teamB = MatchDataParser.team(matchData, isA: false);
    final scoreA = MatchDataParser.score(matchData, teamA.id);
    final scoreB = MatchDataParser.score(matchData, teamB.id);

    final kind = _tabIndex == 0
        ? MatchFeedKind.live
        : _tabIndex == 1
            ? MatchFeedKind.upcoming
            : MatchFeedKind.completed;

    // The live card has no separate overs slot, so fold overs into the score.
    String withOvers(({String score, String overs, bool hasData}) s) =>
        s.overs.isNotEmpty ? '${s.score} (${s.overs})' : s.score;

    final String status = switch (kind) {
      MatchFeedKind.live => MatchDataParser.liveStatus(matchData),
      MatchFeedKind.upcoming => MatchDataParser.startsIn(matchData),
      MatchFeedKind.completed => matchData['status_label']?.toString() ?? 'Completed',
    };

    final matchInfo = MatchInfo(
      id: matchData['id'] as int? ?? 0,
      sport: sportName,
      title: title,
      teamA: teamA.name,
      teamB: teamB.name,
      scoreA: kind == MatchFeedKind.live ? withOvers(scoreA) : scoreA.score,
      scoreB: kind == MatchFeedKind.live ? withOvers(scoreB) : scoreB.score,
      status: status,
    );

    return MatchFeedCard(
      match: matchInfo,
      kind: kind,
      roundLabel: matchData['round']?['name']?.toString() ?? title,
      timeLabel: MatchDataParser.timeLabel(matchData),
      venue: matchData['venue']?['name']?.toString() ?? '',
      oversA: scoreA.overs,
      oversB: scoreB.overs,
      winnerName: MatchDataParser.winnerName(matchData),
      prizeLabel: '',
      onTap: () => kind == MatchFeedKind.completed
          ? _openCompletedDetail(matchData)
          : _openMatchDetail(context, matchData),
      onCta: () => kind == MatchFeedKind.completed
          ? _openCompletedDetail(matchData)
          : _openMatchDetail(context, matchData),
    );
  }

  void _selectSport(int index, dynamic sportId, HomeProvider homeProvider) {
    setState(() => _selectedCategory = index);
    homeProvider.fetchLiveMatches(sportId, isRefresh: true);
    homeProvider.fetchUpcomingMatches(sportId, isRefresh: true);
    homeProvider.fetchAllMatches(sportId, isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final sports = homeProvider.sportsList;

    final liveMatches = homeProvider.liveMatchesList;
    final isLoadingLive = homeProvider.isFetchingLiveMatches;

    final upcomingMatches = homeProvider.upcomingMatchesList;
    final isLoadingUpcoming = homeProvider.isFetchingUpcomingMatches;

    final allMatches = homeProvider.allMatchesList;
    final isLoadingAll = homeProvider.isFetchingAllMatches;

    final List<Map<String, dynamic>> items;
    final bool isLoading;
    final bool loadingMore;
    final String emptyMessage;
    if (_tabIndex == 1) {
      items = upcomingMatches;
      isLoading = isLoadingUpcoming;
      loadingMore = homeProvider.isFetchingMoreUpcomingMatches;
      emptyMessage = 'No upcoming matches.';
    } else if (_tabIndex == 2) {
      items = allMatches;
      isLoading = isLoadingAll;
      loadingMore = homeProvider.isFetchingMoreAllMatches;
      emptyMessage = 'No completed matches.';
    } else {
      items = liveMatches;
      isLoading = isLoadingLive;
      loadingMore = homeProvider.isFetchingMoreLiveMatches;
      emptyMessage = 'No live matches at the moment.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: HomeHeader(
            walletBalance: '₹ 500',
            onAddFunds: () {},
            onNotificationsTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: HomeSearchBar(),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 84,
          child: sports.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: sports.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 18),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return SportIconButton(
                        category: const {
                          'label': 'All',
                          'icon': Icons.sports_rounded,
                          'id': '',
                        },
                        selected: _selectedCategory == 0,
                        onTap: () => _selectSport(0, '', homeProvider),
                      );
                    }

                    final category = sports[index - 1];
                    return SportIconButton(
                      category: {
                        'label': category['name'],
                        'icon': category['icon'],
                        'id': category['id'],
                      },
                      selected: _selectedCategory == index,
                      onTap: () => _selectSport(index, category['id'], homeProvider),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: MatchFeedTabs(
            index: _tabIndex,
            liveCount: liveMatches.length,
            upcomingCount: upcomingMatches.length,
            onChanged: (index) {
              setState(() => _tabIndex = index);
              if (_listScrollController.hasClients) {
                _listScrollController.jumpTo(0);
              }
            },
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
              : items.isEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        final homeProvider = Provider.of<HomeProvider>(context, listen: false);
                        final sportId = _currentSportId(homeProvider);
                        if (_tabIndex == 0) {
                          await homeProvider.fetchLiveMatches(sportId, isRefresh: true);
                        } else if (_tabIndex == 1) {
                          await homeProvider.fetchUpcomingMatches(sportId, isRefresh: true);
                        } else {
                          await homeProvider.fetchAllMatches(sportId, isRefresh: true);
                        }
                      },
                      color: AppColors.mintGreen,
                      backgroundColor: AppColors.secondary,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                          Center(
                            child: Text(
                              emptyMessage,
                              style: const TextStyle(color: Colors.white54, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        final homeProvider = Provider.of<HomeProvider>(context, listen: false);
                        final sportId = _currentSportId(homeProvider);
                        if (_tabIndex == 0) {
                          await homeProvider.fetchLiveMatches(sportId, isRefresh: true);
                        } else if (_tabIndex == 1) {
                          await homeProvider.fetchUpcomingMatches(sportId, isRefresh: true);
                        } else {
                          await homeProvider.fetchAllMatches(sportId, isRefresh: true);
                        }
                      },
                      color: AppColors.mintGreen,
                      backgroundColor: AppColors.secondary,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _listScrollController,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        itemCount: items.length + (loadingMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index == items.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(color: AppColors.mintGreen),
                              ),
                            );
                          }
                          return _buildMatchCard(items[index]);
                        },
                      ),
                    ),
        ),
        // AdsBanner(onTap: () {}),
      ],
    );
  }
}
