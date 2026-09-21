import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/profile_info.dart';
import '../../models/ranking_info.dart';
import 'player_ranking_detail_screen.dart';
import 'team_ranking_detail_screen.dart';
import '../profile/widgets/profile_sport_chips.dart';

/// Home → Rankings: sport filter, Teams / Players, and a points leaderboard.
class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  int _selectedSport = 0;
  RankingKind _kind = RankingKind.teams;

  static const _filters = dummyProfileSports;

  String get _sportLabel => _filters[_selectedSport].$2;

  List<RankingEntry> get _items {
    final rows = dummyRankings
        .where((e) => e.sport == _sportLabel && e.kind == _kind)
        .toList()
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
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
                    Expanded(
                      child: Text(
                        'Rankings',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
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
                  onSelect: (index) => setState(() => _selectedSport = index),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF12161E),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _KindToggle(
                          kind: _kind,
                          onChanged: (kind) => setState(() => _kind = kind),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: items.isEmpty
                              ? Center(
                                  child: Text(
                                    'No ${_kind == RankingKind.teams ? 'team' : 'player'} rankings for $_sportLabel.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 20),
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final entry = items[index];
                                    return _RankingRow(
                                      entry: entry,
                                      onTap: () {
                                        if (entry.kind == RankingKind.players) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => PlayerRankingDetailScreen(
                                                detail: PlayerRankingDetail.fromEntry(entry),
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => TeamRankingDetailScreen(
                                                detail: TeamRankingDetail.fromEntry(entry),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KindToggle extends StatelessWidget {
  const _KindToggle({required this.kind, required this.onChanged});

  final RankingKind kind;
  final ValueChanged<RankingKind> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1218),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _KindChip(
            icon: Icons.add_rounded,
            label: 'Teams',
            selected: kind == RankingKind.teams,
            onTap: () => onChanged(RankingKind.teams),
          ),
          _KindChip(
            icon: Icons.groups_rounded,
            label: 'Players',
            selected: kind == RankingKind.players,
            onTap: () => onChanged(RankingKind.players),
          ),
        ],
      ),
    );
  }
}

class _KindChip extends StatelessWidget {
  const _KindChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.mintGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: selected ? Colors.black87 : Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.quicksand(
                color: selected ? Colors.black87 : Colors.white70,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({required this.entry, this.onTap});

  final RankingEntry entry;
  final VoidCallback? onTap;

  String get _initials {
    final words = entry.name.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    final t = entry.name.trim();
    return t.isEmpty ? '?' : t.substring(0, t.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final delta = entry.delta;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE3A93D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${entry.rank}',
              style: GoogleFonts.quicksand(
                color: Colors.black87,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF141820),
              border: Border.all(color: const Color(0xFFE3A93D).withValues(alpha: 0.55)),
            ),
            child: Text(
              _initials,
              style: GoogleFonts.quicksand(
                color: const Color(0xFFE3A93D),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${entry.matches} Matches',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
                      ),
                    ),
                    Text(
                      '  •  ',
                      style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5),
                    ),
                    const Icon(Icons.emoji_events_rounded, color: Color(0xFFE3A93D), size: 12),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        '${entry.awards} Awards',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'pts  ',
                    style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11),
                  ),
                  Text(
                    '${entry.points}',
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              if (delta == null)
                Text('—', style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12))
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      delta > 0 ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                      size: 18,
                      color: delta > 0 ? AppColors.mintGreen : const Color(0xFFFF5A5A),
                    ),
                    Text(
                      '${delta.abs()}',
                      style: GoogleFonts.quicksand(
                        color: delta > 0 ? AppColors.mintGreen : const Color(0xFFFF5A5A),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
