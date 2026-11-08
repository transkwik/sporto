import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sporto/screens/Matches/Stats_Batting/Commentary.dart';
import 'package:sporto/screens/Matches/Stats_Batting/Graph_live_tournament.dart';
import 'package:sporto/screens/Matches/Stats_Batting/stats_bating_profile.dart';

// COLORS
class AppColors {
  static const bg = Color(0xFF0A0D14);
  static const card = Color(0xFF0F1622);
  static const headerCard = Color(0xFF101A26);
  static const row = Color(0xFF121722);
  static const backBtn = Color(0xFF1A1D23);
  static const textPrimary = Colors.white;
  static const textMuted = Color(0xFF8A919E);
  static const amber = Color(0xFFFFB81C);
  static const pink = Color(0xFFFF5FC8);
  static const green = Color(0xFF2DBE7A);
  static const blue = Color(0xFF4FB3F6);
  static const chipBlueBg = Color(0xFF14263A);
  static const avatarBg = Color(0xFF2A2314);
  static const orange = Color(0xFFFF8A4C);
}

// MODEL
class PlayerStat {
  final String name;
  final String team;
  final int innings;
  final double strikeRate;
  final int value;
  final String initials;

  const PlayerStat({
    required this.name,
    required this.team,
    required this.innings,
    required this.strikeRate,
    required this.value,
    required this.initials,
  });
}

const _players = <PlayerStat>[
  PlayerStat(
    name: 'Shravan Prajapati',
    team: 'Hyd Highlanders',
    innings: 6,
    strikeRate: 132.76,
    value: 40,
    initials: 'SP',
  ),
  PlayerStat(
    name: 'Kunal Kumar',
    team: 'Hyd Highlanders',
    innings: 6,
    strikeRate: 132.76,
    value: 38,
    initials: 'KK',
  ),
  PlayerStat(
    name: 'Amit Sen',
    team: 'Hyd Highlanders',
    innings: 6,
    strikeRate: 132.76,
    value: 35,
    initials: 'AS',
  ),
  PlayerStat(
    name: 'Ritik P',
    team: 'Hyd Highlanders',
    innings: 6,
    strikeRate: 132.76,
    value: 34,
    initials: 'RP',
  ),
  PlayerStat(
    name: 'Pavan K',
    team: 'Hyd Highlanders',
    innings: 6,
    strikeRate: 132.76,
    value: 30,
    initials: 'PK',
  ),
  PlayerStat(
    name: 'Mayur Sinha',
    team: 'Hyd Highlanders',
    innings: 6,
    strikeRate: 132.76,
    value: 25,
    initials: 'MS',
  ),
  PlayerStat(
    name: 'Rahul Dev',
    team: 'Hyd Highlanders',
    innings: 6,
    strikeRate: 132.76,
    value: 20,
    initials: 'RD',
  ),
];

// SCREEN
class TournamentDetailsScreen extends StatefulWidget {
  const TournamentDetailsScreen({super.key});

  @override
  State<TournamentDetailsScreen> createState() =>
      _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen> {
  int _mainTab = 3;
  int _segment = 0;
  int _statTab = 0;

  final _mainTabs = const [
    'Info',
    'Matches',
    'Teams',
    'Stats',

    'Graph',
    'Commentary',
  ];

  final _segments = const ['Batting', 'Bowling', 'Overall'];

  final _statTabs = const [
    'Most Runs',
    'Most Sixes',
    'Most Fours',
    'Highest Individual Score',
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildAppBar(),
            const SizedBox(height: 12),
            _buildStatusCard(),
            const SizedBox(height: 8),
            _buildMainTabs(),
            const SizedBox(height: 12),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  // APP BAR
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.backBtn,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tournament Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'TA-2026-0104 • Miyapur Weekend Cup',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STATUS CARD
  Widget _buildStatusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.headerCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const GraphPage()),
              // );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.chipBlueBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          const Text(
            'Cricket',
            style: TextStyle(
              color: AppColors.amber,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Flexible(
            child: Text(
              '05 Aug 2026, 9:00 AM',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  // MAIN TABS
  Widget _buildMainTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: _mainTabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 22),
        itemBuilder: (_, i) {
          final selected = i == _mainTab;

          return GestureDetector(
            onTap: () => setState(() => _mainTab = i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _mainTabs[i],
                  style: TextStyle(
                    fontSize: 13,
                    color: selected ? AppColors.amber : AppColors.textMuted,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 3,
                  width: selected ? 24 : 0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9A7418),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_mainTabs[_mainTab]) {
      case 'Graph':
        return const GraphPage(); // has its own ListView
      case 'Commentary':
        return const MatchCommentaryScreen(); // has its own ListView
      case 'Stats':
        return SingleChildScrollView(
          // your existing stats UI
          child: Column(
            children: [
              Center(child: _buildSegmentedControl()),
              const SizedBox(height: 12),
              _buildStatTabs(),
              const SizedBox(height: 8),
              _buildStatsCard(),
              const SizedBox(height: 16),
            ],
          ),
        );
      case 'Info':
        return const Center(
          child: Text('Info', style: TextStyle(color: Colors.white)),
        );
      case 'Matches':
        return const Center(
          child: Text('Matches', style: TextStyle(color: Colors.white)),
        );
      case 'Teams':
        return const Center(
          child: Text('Teams', style: TextStyle(color: Colors.white)),
        );
      case 'Financials':
        return const Center(
          child: Text('Financials', style: TextStyle(color: Colors.white)),
        );
      default:
        return const SizedBox();
    }
  }

  // SEGMENTED CONTROL
  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A17),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF16231F)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_segments.length, (i) {
          final selected = i == _segment;

          return GestureDetector(
            onTap: () => setState(() => _segment = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i == _segments.length - 1 ? 0 : 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.green : const Color(0xFF181C24),
                borderRadius: BorderRadius.circular(25),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.green.withOpacity(0.25),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                _segments[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? const Color(0xFF06231A) : Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // STAT CATEGORY TABS
  Widget _buildStatTabs() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _statTabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (_, i) {
          final selected = i == _statTab;

          return GestureDetector(
            onTap: () => setState(() => _statTab = i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _statTabs[i],
                  style: TextStyle(
                    fontSize: 13,
                    color: selected ? AppColors.pink : AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? const Color(0xFF8E3B7C)
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // STATS CARD
  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _statTabs[_statTab],
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    'runs',
                    style: TextStyle(color: Color(0xFF5E6573), fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          for (int i = 0; i < _players.length; i++) ...[
            PlayerRow(rank: i + 1, player: _players[i]),
            const SizedBox(height: 6),
          ],

          const SizedBox(height: 3),
          _buildViewAll(),
        ],
      ),
    );
  }

  // VIEW ALL
  Widget _buildViewAll() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.row,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View All (64)',
              style: TextStyle(color: AppColors.blue, fontSize: 13),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.arrow_right_alt_rounded,
              color: AppColors.blue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// PLAYER ROW
class PlayerRow extends StatelessWidget {
  final int rank;
  final PlayerStat player;

  const PlayerRow({super.key, required this.rank, required this.player});

  Color get _rankColor {
    switch (rank) {
      case 1:
        return AppColors.amber;
      case 2:
        return AppColors.green;
      case 3:
        return AppColors.orange;
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PlayerProfilePage()),
        );
        // PlayerProfilePage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.row,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // RANK
            Container(
              width: 27,
              height: 27,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _rankColor, width: 1.2),
              ),
              child: Text(
                '$rank',
                style: TextStyle(
                  color: _rankColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 9),

            // AVATAR
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.avatarBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                player.initials,
                style: const TextStyle(
                  color: AppColors.amber,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // PLAYER DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${player.team} · ${player.innings} inns · ${player.strikeRate.toStringAsFixed(2)} sr',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),

            // VALUE
            Text(
              '${player.value}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(width: 3),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.blue,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}
