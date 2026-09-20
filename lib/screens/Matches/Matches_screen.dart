import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/match_info.dart';
import '../../models/live_match_detail_info.dart';
import '../home/providers/home_provider.dart';
import '../home/widgets/ads_banner.dart';
import '../home/widgets/home_header.dart';
import '../home/widgets/home_search_bar.dart';
import '../home/widgets/live_match_spotlight_card.dart';
import '../home/widgets/section_header.dart';
import '../home/widgets/sport_icon_button.dart';
import 'lmatch_detail_screen.dart';
import '../profile/notifications_screen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int _selectedCategory = 0;
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _liveScrollController = ScrollController();
  final ScrollController _upcomingScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _liveScrollController.addListener(_onLiveScroll);
    _upcomingScrollController.addListener(_onUpcomingScroll);
    _mainScrollController.addListener(_onMainScroll);

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
    _mainScrollController.dispose();
    _liveScrollController.dispose();
    _upcomingScrollController.dispose();
    super.dispose();
  }

  void _onLiveScroll() {
    if (_liveScrollController.position.pixels >= _liveScrollController.position.maxScrollExtent - 200) {
      final provider = context.read<HomeProvider>();
      if (!provider.isFetchingLiveMatches && !provider.isFetchingMoreLiveMatches && provider.sportsList.isNotEmpty) {
        final sportId = _selectedCategory == 0 ? '' : provider.sportsList[_selectedCategory - 1]['id'];
        provider.fetchLiveMatches(sportId, isRefresh: false);
      }
    }
  }

  void _onUpcomingScroll() {
    if (_upcomingScrollController.position.pixels >= _upcomingScrollController.position.maxScrollExtent - 200) {
      final provider = context.read<HomeProvider>();
      if (!provider.isFetchingUpcomingMatches && !provider.isFetchingMoreUpcomingMatches && provider.sportsList.isNotEmpty) {
        final sportId = _selectedCategory == 0 ? '' : provider.sportsList[_selectedCategory - 1]['id'];
        provider.fetchUpcomingMatches(sportId, isRefresh: false);
      }
    }
  }

  void _onMainScroll() {
    if (_mainScrollController.position.pixels >= _mainScrollController.position.maxScrollExtent - 200) {
      final provider = context.read<HomeProvider>();
      if (!provider.isFetchingAllMatches && !provider.isFetchingMoreAllMatches && provider.sportsList.isNotEmpty) {
        final sportId = _selectedCategory == 0 ? '' : provider.sportsList[_selectedCategory - 1]['id'];
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

  Widget _buildMatchCard(Map<String, dynamic> matchData, double? width) {
    final match = matchData['match'];
    final status = match?['status'] ?? 'Scheduled';
    
    final sportName = matchData['sport']?['name'] ?? 'Unknown Sport';
    final title = matchData['format']?['name'] ?? 'Tournament';
    
    final teams = matchData['teams'] as List<dynamic>? ?? [];
    final teamA = teams.isNotEmpty ? teams[0]['name'] : 'Team A';
    final teamB = teams.length > 1 ? teams[1]['name'] : 'Team B';

    final matchInfo = MatchInfo(
      sport: sportName,
      title: title,
      teamA: teamA,
      teamB: teamB,
      scoreA: '0/0',
      scoreB: '0/0',
      status: status,
    );

    Widget card = LiveMatchSpotlightCard(
      match: matchInfo,
      onWatch: () => _openMatchDetail(context),
      onTap: () => _openMatchDetail(context),
    );

    if (width != null) {
      return SizedBox(width: width, child: card);
    }
    return card;
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

    return ListView(
      controller: _mainScrollController,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        HomeHeader(
          walletBalance: '₹ 500',
          onAddFunds: () {},
          onNotificationsTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          },
        ),
        const SizedBox(height: 18),
        const HomeSearchBar(),
        const SizedBox(height: 22),
        SizedBox(
          height: 84,
          child: sports.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
              : ListView.separated(
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
                        onTap: () {
                          setState(() => _selectedCategory = 0);
                          homeProvider.fetchLiveMatches('', isRefresh: true);
                          homeProvider.fetchUpcomingMatches('', isRefresh: true);
                          homeProvider.fetchAllMatches('', isRefresh: true);
                        },
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
                      onTap: () {
                        setState(() => _selectedCategory = index);
                        homeProvider.fetchLiveMatches(category['id'], isRefresh: true);
                        homeProvider.fetchUpcomingMatches(category['id'], isRefresh: true);
                        homeProvider.fetchAllMatches(category['id'], isRefresh: true);
                      },
                    );
                  },
                ),
        ),
        const SizedBox(height: 22),
        
        // --- Live Now ---
        const SectionHeader(dotColor: AppColors.primary, title: 'Live Now'),
        const SizedBox(height: 14),
        SizedBox(
          height: 185,
          child: isLoadingLive
              ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
              : liveMatches.isEmpty
                  ? const Center(
                      child: Text('No live matches at the moment.', style: TextStyle(color: Colors.white54, fontSize: 14)),
                    )
                  : ListView.separated(
                      controller: _liveScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: liveMatches.length + (homeProvider.isFetchingMoreLiveMatches ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        if (index == liveMatches.length) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.mintGreen));
                        }
                        return _buildMatchCard(liveMatches[index], MediaQuery.of(context).size.width * 0.85);
                      },
                    ),
        ),
        const SizedBox(height: 22),

        // --- Upcoming Matches ---
        const SectionHeader(dotColor: AppColors.primary, title: 'Upcoming Matches'),
        const SizedBox(height: 14),
        SizedBox(
          height: 185,
          child: isLoadingUpcoming
              ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
              : upcomingMatches.isEmpty
                  ? const Center(
                      child: Text('No upcoming matches.', style: TextStyle(color: Colors.white54, fontSize: 14)),
                    )
                  : ListView.separated(
                      controller: _upcomingScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: upcomingMatches.length + (homeProvider.isFetchingMoreUpcomingMatches ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        if (index == upcomingMatches.length) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.mintGreen));
                        }
                        return _buildMatchCard(upcomingMatches[index], MediaQuery.of(context).size.width * 0.85);
                      },
                    ),
        ),
        const SizedBox(height: 22),

        // --- All Matches ---
        const SectionHeader(dotColor: AppColors.primary, title: 'Matches'),
        const SizedBox(height: 14),
        isLoadingAll
            ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
            : allMatches.isEmpty
                ? const Center(
                    child: Text('No matches found.', style: TextStyle(color: Colors.white54, fontSize: 14)),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allMatches.length + (homeProvider.isFetchingMoreAllMatches ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == allMatches.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(color: AppColors.mintGreen),
                          ),
                        );
                      }
                      return _buildMatchCard(allMatches[index], null);
                    },
                  ),

        const SizedBox(height: 20),
        // AdsBanner(onTap: () {}),
      ],
    );
  }
}
