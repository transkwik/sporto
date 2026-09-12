import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/home_provider.dart';
import '../auth/providers/auth_provider.dart';
import '../auth/providers/location_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/live_match_detail_info.dart';
import '../../models/match_info.dart';
import '../../models/next_match_info.dart';
import '../../models/sport_category.dart';
import '../../models/tournament_info.dart';
import '../Matches/lmatch_detail_screen.dart';
import '../Matches/Matches_screen.dart';
import '../live_matches/live_matches_screen.dart';
import '../playground/playground_screen.dart';
import '../profile/profile_screen.dart';
import '../tournament/tournament_detail_screen.dart';
import 'widgets/ads_banner.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/live_match_spotlight_card.dart';
import 'widgets/next_match_card.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/section_header.dart';
import 'widgets/sport_icon_button.dart';
import 'widgets/tournament_card.dart';

/// App shell shown after a successful onboarding flow. Hosts the bottom
/// navigation and swaps between the tournaments dashboard and other tabs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  Future<void> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2128),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Exit App', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to quit?', style: GoogleFonts.quicksand(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: GoogleFonts.quicksand(color: Colors.white70, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Quit', style: GoogleFonts.quicksand(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: AppColors.authBackgroundBottom,
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
          child: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _tabIndex,
              children: const [
                _HomeTabBody(),
                LiveMatchesScreen(),
                MatchesScreen(),
                PlaygroundScreen(),
                ProfileScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: HomeBottomNav(
          selectedIndex: _tabIndex,
          onSelect: (index) => setState(() => _tabIndex = index),
        ),
      ),
    );
  }
}

class _HomeTabBody extends StatefulWidget {
  const _HomeTabBody();

  @override
  State<_HomeTabBody> createState() => _HomeTabBodyState();
}

class _HomeTabBodyState extends State<_HomeTabBody> {
  int _selectedCategory = 0;
  final ScrollController _scrollController = ScrollController();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.fetchSports();
      
      final locProvider = Provider.of<LocationProvider>(context, listen: false);
      double? lat = locProvider.latitude != 0.0 ? locProvider.latitude : null;
      double? lng = locProvider.longitude != 0.0 ? locProvider.longitude : null;
      homeProvider.fetchTournaments(isRefresh: true, lat: lat, lng: lng);
      homeProvider.fetchLiveMatches('', isRefresh: true);
      homeProvider.fetchUpcomingMatches('', isRefresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      if (!homeProvider.isFetchingMoreTournaments) {
        final locProvider = Provider.of<LocationProvider>(context, listen: false);
        double? lat = locProvider.latitude != 0.0 ? locProvider.latitude : null;
        double? lng = locProvider.longitude != 0.0 ? locProvider.longitude : null;
        homeProvider.fetchTournaments(lat: lat, lng: lng);
      }
      if (!homeProvider.isFetchingLiveMatches && !homeProvider.isFetchingMoreLiveMatches && homeProvider.sportsList.isNotEmpty) {
        final sportId = _selectedCategory == 0 ? '' : homeProvider.sportsList[_selectedCategory - 1]['id'];
        homeProvider.fetchLiveMatches(sportId, isRefresh: false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final userProfile = authProvider.checkResponse?['profile'] ?? {};
    
    final String userName = userProfile['full_name'] ?? 'Player';
    final String city = userProfile['city'] ?? '';
    final String state = userProfile['state'] ?? '';
    
    String location = 'Unknown Location';
    if (locationProvider.address != 'Unknown location' && locationProvider.address.isNotEmpty) {
      location = locationProvider.address;
    } else if (city.isNotEmpty && state.isNotEmpty) {
      location = '$city, $state';
    } else if (city.isNotEmpty) {
      location = city;
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        HomeHeader(
          walletBalance: '₹ 500',
          onAddFunds: () {},
          onNotificationsTap: () {},
        ),
        const SizedBox(height: 10),
        Center(
          child: _LocationRow(location: location),
        ),
        const SizedBox(height: 18),
        const HomeSearchBar(),
        const SizedBox(height: 20),
        Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            final liveMatches = homeProvider.liveMatchesList;
            final isLoadingLive = homeProvider.isFetchingLiveMatches;
            
            if (isLoadingLive) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(dotColor: AppColors.primary, title: 'Live Now'),
                  const SizedBox(height: 14),
                  const Center(child: CircularProgressIndicator(color: AppColors.mintGreen)),
                  const SizedBox(height: 26),
                ],
              );
            }
            
            if (liveMatches.isEmpty) {
              return const SizedBox.shrink(); // Pass empty container
            }
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(dotColor: AppColors.primary, title: 'Live Now'),
                const SizedBox(height: 14),
                SizedBox(
                  height: 185,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: liveMatches.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final matchData = liveMatches[index];
                      final teamA = matchData['participants']?['team_a']?['name'] ?? 'Team A';
                      final teamB = matchData['participants']?['team_b']?['name'] ?? 'Team B';
                      final sportName = matchData['tournament']?['sport']?['name'] ?? 'Unknown Sport';
                      final title = matchData['tournament']?['name'] ?? 'Tournament';
                      final status = matchData['status'] ?? 'Scheduled';

                      final matchInfo = MatchInfo(
                        sport: sportName,
                        title: title,
                        teamA: teamA,
                        teamB: teamB,
                        scoreA: '0/0',
                        scoreB: '0/0',
                        status: status,
                      );

                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: LiveMatchSpotlightCard(
                          match: matchInfo,
                          onWatch: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const LiveMatchDetailScreen(match: dummyLiveMatchDetail)),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const LiveMatchDetailScreen(match: dummyLiveMatchDetail)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 26),
              ],
            );
          },
        ),
        SizedBox(
          height: 84,
          child: Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              if (homeProvider.isLoading && homeProvider.sportsList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              
              final sports = homeProvider.sportsList.isEmpty
                  ? [{'label': 'All', 'icon': Icons.apps_rounded, 'id': null}, ...dummySportCategories.map((c) => {'label': c.label, 'icon': c.icon, 'id': c.id})]
                  : [{'label': 'All', 'icon': Icons.apps_rounded, 'id': null}, ...homeProvider.sportsList];

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sports.length,
                separatorBuilder: (_, __) => const SizedBox(width: 18),
                itemBuilder: (context, index) {
                  final category = sports[index] as Map<String, dynamic>;
                  return SportIconButton(
                    category: category,
                    selected: _selectedCategory == index,
                    onTap: () {
                      setState(() => _selectedCategory = index);
                      final locProvider = Provider.of<LocationProvider>(context, listen: false);
                      double? lat = locProvider.latitude != 0.0 ? locProvider.latitude : null;
                      double? lng = locProvider.longitude != 0.0 ? locProvider.longitude : null;
                      
                      homeProvider.fetchTournaments(
                        isRefresh: true,
                        lat: lat,
                        lng: lng,
                        sportId: category['id'] != null ? category['id'].toString() : '',
                      );
                      homeProvider.fetchLiveMatches(
                        category['id'] != null ? category['id'].toString() : '',
                        isRefresh: true,
                      );
                      homeProvider.fetchUpcomingMatches(
                        category['id'] != null ? category['id'].toString() : '',
                        isRefresh: true,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: const [
            Expanded(child: QuickActionButton(icon: Icons.groups_rounded, label: 'My Teams')),
            SizedBox(width: 10),
            Expanded(child: QuickActionButton(icon: Icons.event_note_rounded, label: 'Fixtures')),
            SizedBox(width: 10),
            Expanded(child: QuickActionButton(icon: Icons.leaderboard_rounded, label: 'Rankings')),
          ],
        ),
        const SizedBox(height: 25),
        Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            final upcomingMatches = homeProvider.upcomingMatchesList;
            final isLoadingUpcoming = homeProvider.isFetchingUpcomingMatches;
            
            if (isLoadingUpcoming) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Matches',
                    style: GoogleFonts.quicksand(color: AppColors.amberAccent, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  const SizedBox(height: 25),
                ],
              );
            }
            
            if (upcomingMatches.isEmpty) {
              return const SizedBox.shrink();
            }
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Matches',
                  style: GoogleFonts.quicksand(color: AppColors.amberAccent, fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 185,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: upcomingMatches.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final matchData = upcomingMatches[index];
                      final teamA = matchData['participants']?['team_a']?['name'] ?? 'Team A';
                      final teamB = matchData['participants']?['team_b']?['name'] ?? 'Team B';
                      final sportName = matchData['tournament']?['sport']?['name'] ?? 'Unknown Sport';
                      final title = matchData['tournament']?['name'] ?? 'Tournament';
                      final status = matchData['status'] ?? 'Scheduled';

                      // Since NextMatchCard needs a lot of detailed info not present in the basic 
                      // upcoming match API (like maxPlayers, regFee), we'll use LiveMatchSpotlightCard 
                      // which handles basic MatchInfo gracefully, as we did in MatchesScreen.
                      final matchInfo = MatchInfo(
                        sport: sportName,
                        title: title,
                        teamA: teamA,
                        teamB: teamB,
                        scoreA: '0/0',
                        scoreB: '0/0',
                        status: status,
                      );

                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: LiveMatchSpotlightCard(
                          match: matchInfo,
                          onWatch: () {}, // Detail screen navigation can be added here
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
              ],
            );
          },
        ),
         Text(
          'Browse Tournaments',
          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            final list = homeProvider.tournamentsList;
            
            if (homeProvider.isLoading && list.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            
            if (list.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text('No tournaments found', style: GoogleFonts.quicksand(color: Colors.white54)),
                ),
              );
            }
            
            return SizedBox(
              height: 400, // Fixed height box for independent scrolling
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: list.length + (homeProvider.isFetchingMoreTournaments ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  }
                  final t = list[index] as Map<String, dynamic>;
                  return TournamentCard(
                    tournament: t,
                    onTap: () {
                      final id = t['id'];
                      if (id != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TournamentDetailScreen(tournamentId: id),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        AdsBanner(onTap: () {}),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.location_on_outlined, color: Colors.white38, size: 14),
        const SizedBox(width: 4),
        Text(location, style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

