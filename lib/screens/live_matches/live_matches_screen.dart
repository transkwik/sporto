import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/live_match_detail_info.dart';
import '../../models/match_info.dart';
import '../Matches/lmatch_detail_screen.dart';
import '../home/widgets/home_search_bar.dart';
import '../home/widgets/section_header.dart';
import '../playground/widgets/playground_filter_chip.dart';
import 'widgets/live_match_list_card.dart';
import '../home/providers/home_provider.dart';

/// Dedicated "Live" tab: a searchable, filterable feed of every match
/// currently in progress across all sports.
class LiveMatchesScreen extends StatefulWidget {
  const LiveMatchesScreen({super.key});

  @override
  State<LiveMatchesScreen> createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen> {
  int _selectedFilter = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(isRefresh: true);
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
      _fetchData(isRefresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchData(isRefresh: false);
    }
  }

  void _fetchData({required bool isRefresh}) {
    final provider = context.read<HomeProvider>();
    String? sportId;
    if (_selectedFilter > 0 && provider.sportsList.length >= _selectedFilter) {
      final category = provider.sportsList[_selectedFilter - 1];
      sportId = category['id']?.toString();
    }

    if (isRefresh && provider.sportsList.isEmpty) {
      provider.fetchSports();
    }
    provider.fetchLiveMatches(
      sportId ?? '',
      isRefresh: isRefresh,
      search: _searchController.text,
    );
  }

  void _openMatchDetail(MatchInfo match) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            LiveMatchDetailScreen(match: dummyLiveMatchDetail, matchId: match.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final sports = provider.sportsList;
        final liveMatches = provider.liveMatchesList;
        
        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              'Live Matches',
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            HomeSearchBar(
              controller: _searchController,
              hintText: 'Search live matches...',
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sports.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return PlaygroundFilterChip(
                      label: 'All',
                      selected: _selectedFilter == 0,
                      onTap: () {
                        setState(() => _selectedFilter = 0);
                        _fetchData(isRefresh: true);
                      },
                    );
                  }
                  final category = sports[index - 1];
                  return PlaygroundFilterChip(
                    label: category['name'] ?? 'Sport',
                    selected: _selectedFilter == index,
                    onTap: () {
                      setState(() => _selectedFilter = index);
                      _fetchData(isRefresh: true);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const SectionHeader(dotColor: AppColors.primary, title: 'Live Now'),
                const Spacer(),
                Text(
                  '${liveMatches.length} Matches',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (provider.isFetchingLiveMatches && liveMatches.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (liveMatches.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'No live matches found.',
                    style: GoogleFonts.quicksand(color: Colors.white54),
                  ),
                ),
              )
            else
              ...liveMatches.map((matchData) {
                final match = MatchInfo.fromJson(matchData);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: LiveMatchListCard(
                    match: match,
                    onTap: () => _openMatchDetail(match),
                  ),
                );
              }),
            if (provider.isFetchingMoreLiveMatches)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        );
      },
    );
  }
}
