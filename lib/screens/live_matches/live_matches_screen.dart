import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/live_match_detail_info.dart';
import '../../models/match_info.dart';
import '../../models/sport_category.dart';
import '../Matches/lmatch_detail_screen.dart';
import '../home/widgets/home_search_bar.dart';
import '../home/widgets/section_header.dart';
import '../playground/widgets/playground_filter_chip.dart';
import 'widgets/live_match_list_card.dart';

/// Dedicated "Live" tab: a searchable, filterable feed of every match
/// currently in progress across all sports.
class LiveMatchesScreen extends StatefulWidget {
  const LiveMatchesScreen({super.key});

  @override
  State<LiveMatchesScreen> createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen> {
  int _selectedFilter = 0;

  void _openMatchDetail(MatchInfo match) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LiveMatchDetailScreen(match: dummyLiveMatchDetail)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
          Text(
          'Live Matches',
          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 18),
        const HomeSearchBar(hintText: 'Search tournaments...'),
        const SizedBox(height: 18),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dummySportCategories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index == 0) {
                return PlaygroundFilterChip(
                  label: 'All',
                  selected: _selectedFilter == 0,
                  onTap: () => setState(() => _selectedFilter = 0),
                );
              }
              final category = dummySportCategories[index - 1];
              return PlaygroundFilterChip(
                label: category.label,
                icon: category.icon,
                selected: _selectedFilter == index,
                onTap: () => setState(() => _selectedFilter = index),
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
              '${dummyLiveMatches.length} Matches',
              style: const TextStyle(color: Colors.white54, fontSize: 12.5, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final match in dummyLiveMatches) ...[
          LiveMatchListCard(match: match, onTap: () => _openMatchDetail(match)),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
