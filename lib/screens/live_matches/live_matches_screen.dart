import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/completed_match_detail_info.dart';
import '../../models/live_match_detail_info.dart';
import '../../models/match_info.dart';
import '../Matches/completed_match_detail_screen.dart';
import '../Matches/lmatch_detail_screen.dart';
import '../Matches/widgets/match_feed_card.dart';
import '../home/providers/home_provider.dart';
import '../home/widgets/tournament_card.dart';
import '../playground/widgets/playground_filter_chip.dart';
import '../tournament/tournament_detail_screen.dart';
import 'widgets/tournament_hub_tabs.dart';

/// Tournaments bottom-nav tab: browse tournaments plus live / upcoming /
/// history match feeds. Layout matches the tournament hub design; lists
/// come from the existing APIs.
class LiveMatchesScreen extends StatefulWidget {
  const LiveMatchesScreen({super.key});

  @override
  State<LiveMatchesScreen> createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen> {
  int _selectedFilter = 0;
  int _tabIndex = 0;
  bool _searchOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAll(isRefresh: true);
    });
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _fetchAll(isRefresh: true);
    });
  }

  String _sportId(HomeProvider provider) {
    final sports = _sports(provider);
    if (sports.isEmpty) return '';
    if (_selectedFilter >= sports.length) return '';
    return sports[_selectedFilter]['id']?.toString() ?? '';
  }

  List<dynamic> _sports(HomeProvider provider) {
    return provider.sportsList;
  }

  void _onScroll() {
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }
    final provider = context.read<HomeProvider>();
    final sportId = _sportId(provider);
    if (_tabIndex == 0) {
      provider.fetchTournaments(isRefresh: false, sportId: sportId);
    } else if (_tabIndex == 1) {
      provider.fetchLiveMatches(sportId, isRefresh: false, search: _searchController.text);
    } else if (_tabIndex == 2) {
      provider.fetchUpcomingMatches(sportId, isRefresh: false);
    } else {
      provider.fetchAllMatches(sportId, isRefresh: false);
    }
  }

  void _fetchAll({required bool isRefresh}) {
    final provider = context.read<HomeProvider>();
    if (isRefresh && provider.sportsList.isEmpty) {
      provider.fetchSports();
    }
    final sportId = _sportId(provider);
    provider.fetchTournaments(isRefresh: isRefresh, sportId: sportId);
    provider.fetchLiveMatches(
      sportId,
      isRefresh: isRefresh,
      search: _searchController.text,
    );
    provider.fetchUpcomingMatches(sportId, isRefresh: isRefresh);
    provider.fetchAllMatches(sportId, isRefresh: isRefresh);
  }

  bool _matchesQuery(String text) {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return text.toLowerCase().contains(q);
  }

  List<Map<String, dynamic>> _tournamentItems(HomeProvider provider) {
    final api = provider.tournamentsList
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    return api.where((item) {
      final name = (item['name'] ?? item['title'] ?? '').toString();
      final itemSport = (item['sport'] is Map ? item['sport']['name'] : item['sport'] ?? '').toString();
      return _matchesQuery('$name $itemSport');
    }).toList();
  }

  List<Map<String, dynamic>> _liveItems(HomeProvider provider) {
    return _filterMatchMaps(provider.liveMatchesList, provider);
  }

  List<Map<String, dynamic>> _upcomingItems(HomeProvider provider) {
    return _filterMatchMaps(provider.upcomingMatchesList, provider);
  }

  List<Map<String, dynamic>> _historyItems(HomeProvider provider) {
    return _filterMatchMaps(provider.allMatchesList, provider);
  }

  List<Map<String, dynamic>> _filterMatchMaps(
    List<Map<String, dynamic>> source,
    HomeProvider provider,
  ) {
    return source.where((item) {
      final match = MatchInfo.fromJson(item);
      return _matchesQuery('${match.title} ${match.teamA} ${match.teamB} ${match.sport}');
    }).toList();
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

  void _openTournament(Map<String, dynamic> tournament) {
    final id = int.tryParse(tournament['id']?.toString() ?? '') ?? 0;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TournamentDetailScreen(
          tournamentId: id,
          fallbackTournament: tournament,
        ),
      ),
    );
  }

  void _openLive(Map<String, dynamic> matchData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiveMatchDetailScreen(
          match: dummyLiveMatchDetail,
          matchId: matchData['id'] as int? ?? 3665,
        ),
      ),
    );
  }

  void _openCompleted(Map<String, dynamic> matchData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompletedMatchDetailScreen(
          match: CompletedMatchDetailInfo.fromMatchData(matchData),
        ),
      ),
    );
  }

  Widget _matchCard(Map<String, dynamic> matchData, MatchFeedKind kind) {
    final match = MatchInfo.fromJson(matchData);
    final nested = matchData['match'];
    return MatchFeedCard(
      match: match,
      kind: kind,
      roundLabel: matchData['round']?['name']?.toString() ??
          matchData['stage']?.toString() ??
          'Quarter Final',
      timeLabel: nested is Map
          ? (nested['start_time'] ?? nested['time'] ?? '').toString()
          : (matchData['time']?.toString() ?? ''),
      venue: matchData['venue']?['name']?.toString() ??
          matchData['ground']?.toString() ??
          'Ground A',
      winnerName: matchData['winner']?['name']?.toString() ?? match.teamA,
      prizeLabel: matchData['prize']?.toString() ?? '',
      onTap: () => kind == MatchFeedKind.completed ? _openCompleted(matchData) : _openLive(matchData),
      onCta: () => kind == MatchFeedKind.completed ? _openCompleted(matchData) : _openLive(matchData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final sports = _sports(provider);
        final tournaments = _tournamentItems(provider);
        final live = _liveItems(provider);
        final upcoming = _upcomingItems(provider);
        final history = _historyItems(provider);

        final bool loading;
        final bool loadingMore;
        final List<Widget> cards;
        if (_tabIndex == 0) {
          loading = provider.isLoading && provider.tournamentsList.isEmpty;
          loadingMore = provider.isFetchingMoreTournaments;
          cards = [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Browse Tournaments',
                style: GoogleFonts.quicksand(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...tournaments.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TournamentCard(
                  tournament: item,
                  onTap: () => _openTournament(item),
                ),
              ),
            ),
          ];
        } else if (_tabIndex == 1) {
          loading = provider.isFetchingLiveMatches && provider.liveMatchesList.isEmpty;
          loadingMore = provider.isFetchingMoreLiveMatches;
          cards = live.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _matchCard(item, MatchFeedKind.live),
              )).toList();
        } else if (_tabIndex == 2) {
          loading = provider.isFetchingUpcomingMatches && provider.upcomingMatchesList.isEmpty;
          loadingMore = provider.isFetchingMoreUpcomingMatches;
          cards = upcoming.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _matchCard(item, MatchFeedKind.upcoming),
              )).toList();
        } else {
          loading = provider.isFetchingAllMatches && provider.allMatchesList.isEmpty;
          loadingMore = provider.isFetchingMoreAllMatches;
          cards = history.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _matchCard(item, MatchFeedKind.completed),
              )).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tournaments',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _searchOpen = !_searchOpen),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.glassFillLighter,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: Colors.white70, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Search',
                            style: GoogleFonts.quicksand(
                              color: Colors.white70,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_searchOpen) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search tournaments & matches',
                    hintStyle: GoogleFonts.quicksand(color: Colors.white38, fontSize: 14),
                    filled: true,
                    fillColor: AppColors.glassFillLighter,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.mintGreen),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: sports.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = sports[index];
                  final name = category['name']?.toString() ?? 'Sport';
                  return PlaygroundFilterChip(
                    label: name,
                    icon: _iconForSport(name),
                    selected: _selectedFilter == index,
                    onTap: () {
                      setState(() => _selectedFilter = index);
                      _fetchAll(isRefresh: true);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TournamentHubTabs(
                index: _tabIndex,
                upcomingCount: upcoming.length,
                onChanged: (index) {
                  setState(() => _tabIndex = index);
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0);
                  }
                },
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : cards.length <= (_tabIndex == 0 ? 1 : 0)
                      ? Center(
                          child: Text(
                            'Nothing to show yet.',
                            style: GoogleFonts.quicksand(color: Colors.white54),
                          ),
                        )
                      : ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                          children: [
                            ...cards,
                            if (loadingMore)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(color: AppColors.primary),
                                ),
                              ),
                          ],
                        ),
            ),
          ],
        );
      },
    );
  }
}
