import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/match_info.dart';
import '../../models/live_match_detail_info.dart';
import '../home/providers/home_provider.dart';
import '../home/widgets/home_header.dart';
import '../home/widgets/home_search_bar.dart';
import '../home/widgets/sport_icon_button.dart';
import 'lmatch_detail_screen.dart';
import 'completed_match_detail_screen.dart';
import '../../models/completed_match_detail_info.dart';
import '../profile/notifications_screen.dart';
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

  void _openMatchDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LiveMatchDetailScreen(match: dummyLiveMatchDetail),
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

  /// Same API → MatchInfo mapping as before. Only the card widget is new.
  Widget _buildMatchCard(Map<String, dynamic> matchData) {
    final match = matchData['match'];
    final status = match?['status'] ?? 'Scheduled';

    final sportName = matchData['sport']?['name'] ?? 'Unknown Sport';
    final title = matchData['format']?['name'] ?? 'Tournament';

    final teams = matchData['teams'] as List<dynamic>? ?? [];
    final teamA = teams.isNotEmpty ? teams[0]['name'] : 'Team A';
    final teamB = teams.length > 1 ? teams[1]['name'] : 'Team B';

    final scoreA = match?['score_a']?.toString() ??
        match?['scoreA']?.toString() ??
        (teams.isNotEmpty ? teams[0]['score']?.toString() : null) ??
        '0/0';
    final scoreB = match?['score_b']?.toString() ??
        match?['scoreB']?.toString() ??
        (teams.length > 1 ? teams[1]['score']?.toString() : null) ??
        '0/0';

    final matchInfo = MatchInfo(
      sport: sportName,
      title: title,
      teamA: teamA,
      teamB: teamB,
      scoreA: scoreA,
      scoreB: scoreB,
      status: status,
    );

    final kind = _tabIndex == 0
        ? MatchFeedKind.live
        : _tabIndex == 1
            ? MatchFeedKind.upcoming
            : MatchFeedKind.completed;

    final overs = match?['overs']?.toString() ?? matchData['overs']?.toString() ?? '';
    final winner = match?['winner']?['name']?.toString() ??
        matchData['winner']?['name']?.toString() ??
        match?['winner']?.toString() ??
        matchData['winner']?.toString() ??
        teamB;
    final prize = match?['prize']?.toString() ??
        matchData['prize']?.toString() ??
        matchData['prize_money']?.toString() ??
        '';

    return MatchFeedCard(
      match: matchInfo,
      kind: kind,
      roundLabel: matchData['round']?['name']?.toString() ??
          matchData['stage']?.toString() ??
          title,
      timeLabel: match?['start_time']?.toString() ??
          match?['time']?.toString() ??
          matchData['time']?.toString() ??
          '',
      venue: matchData['venue']?['name']?.toString() ??
          matchData['ground']?.toString() ??
          match?['venue']?.toString() ??
          '',
      oversA: teams.isNotEmpty ? (teams[0]['overs']?.toString() ?? overs) : overs,
      oversB: teams.length > 1 ? (teams[1]['overs']?.toString() ?? overs) : overs,
      winnerName: winner,
      prizeLabel: prize,
      onTap: () => kind == MatchFeedKind.completed
          ? _openCompletedDetail(matchData)
          : _openMatchDetail(context),
      onCta: () => kind == MatchFeedKind.completed
          ? _openCompletedDetail(matchData)
          : _openMatchDetail(context),
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
                  ? Center(
                      child: Text(
                        emptyMessage,
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    )
                  : ListView.separated(
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
        // AdsBanner(onTap: () {}),
      ],
    );
  }
}
