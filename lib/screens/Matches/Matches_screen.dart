import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/match_info.dart';
import '../../models/sport_category.dart';
import '../../models/live_match_detail_info.dart';
import '../home/widgets/ads_banner.dart';
import '../home/widgets/home_header.dart';
import '../home/widgets/home_search_bar.dart';
import '../home/widgets/live_match_spotlight_card.dart';
import '../home/widgets/section_header.dart';
import '../home/widgets/sport_icon_button.dart';
import 'lmatch_detail_screen.dart';

/// Matches tab: dedicated live-matches dashboard — the same header, search
/// bar, and sport filter chrome as Home, spotlighting whichever match is
/// currently live.
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int _selectedCategory = 0;

  void _openMatchDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LiveMatchDetailScreen(match: dummyLiveMatchDetail)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        HomeHeader(
          greeting: 'Good Evening',
          userName: 'Shrvn.Prjpti',
          walletBalance: '₹ 500',
          onAddFunds: () {},
          onNotificationsTap: () {},
        ),
        const SizedBox(height: 18),
        const HomeSearchBar(),
        const SizedBox(height: 22),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dummySportCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              final category = dummySportCategories[index];
              return SportIconButton(
                category: category,
                selected: _selectedCategory == index,
                onTap: () => setState(() => _selectedCategory = index),
              );
            },
          ),
        ),
        const SizedBox(height: 22),
        const SectionHeader(dotColor: AppColors.primary, title: 'Live Now'),
        const SizedBox(height: 14),
        LiveMatchSpotlightCard(
          match: dummyLiveMatch,
          onWatch: () => _openMatchDetail(context),
          onTap: () => _openMatchDetail(context),
        ),
        const SizedBox(height: 20),
        AdsBanner(onTap: () {}),
      ],
    );
  }
}
