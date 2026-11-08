// pubspec.yaml -> dependencies:
//   google_fonts: ^6.2.1
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ───────────── Colors ─────────────
const kBg = Color(0xFF07090B);
const kCard = Color(0xFF14171B);
const kIconBox = Color(0xFF1D2025);
const kGold = Color(0xFFF5B50A);
const kGreen = Color(0xFF6BF58F);
const kRed = Color(0xFFFF5C6C);
const kMuted = Color(0xFF8A8D93);
const kDimText = Color(0xFF5E6168);

TextStyle _t(
  double size, {
  FontWeight w = FontWeight.w500,
  Color c = Colors.white,
}) => GoogleFonts.quicksand(fontSize: size, fontWeight: w, color: c);

// ───────────── Model ─────────────
class PointTx {
  final String emoji, title, subtitle, ref, date;
  final int points;
  const PointTx(
    this.emoji,
    this.title,
    this.subtitle,
    this.points, {
    this.ref = 'Ptx-100031',
    this.date = '06 July 2026, 10:20 AM',
  });
}

const _history = <PointTx>[
  PointTx('📅', 'Daily login', 'Opened SPOTO', 5),
  PointTx('📅', 'Daily login', 'Opened SPOTO', 5),
  PointTx('📝', 'Tournament registration', 'SPOTO Weekend Football Cup', 25),
  PointTx(
    '📅',
    'Adjustment',
    'Kukatpally Weekend Cup cancelled — regis...',
    -25,
  ),
  PointTx(
    '⭐',
    'Sports achievement',
    'Player of the Tournament — ABC Premier...',
    30,
  ),
  PointTx('🥇', 'Tournament champion', 'ABC Premier League 2026', 50),
  PointTx('🏆', 'Match victory bonus', 'Warriors FC beat Skyline FC', 10),
  PointTx('🏟️', 'Match played', 'Warriors FC vs Skyline FC', 15),
  PointTx('✅', 'Correct prediction', 'Warriors CC vs Colony Kings', 5),
  PointTx('🎯', 'Predict & Win entry', 'Warriors CC vs Colony Kings', 5),
  PointTx('👤', 'Profile completed', 'Profile 100% complete', 20),
];

// ───────────── Screen ─────────────
class SpotoPointsScreenHistory extends StatefulWidget {
  const SpotoPointsScreenHistory({super.key});

  @override
  State<SpotoPointsScreenHistory> createState() =>
      _SpotoPointsScreenHistoryState();
}

class _SpotoPointsScreenHistoryState extends State<SpotoPointsScreenHistory> {
  int _tab = 0;
  static const _tabs = ['History', 'How To Earn', 'Leaderboard'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
          children: [
            _header(context),
            const SizedBox(height: 18),
            const _BalanceCard(),
            const SizedBox(height: 14),
            Center(child: _tabBar()),
            const SizedBox(height: 14),
            if (_tab == 0)
              ..._history.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _TxTile(tx: e),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: Text(_tabs[_tab], style: _t(13, c: kMuted)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Row(
    children: [
      InkWell(
        onTap: () => Navigator.maybePop(context),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(
            Icons.chevron_left_rounded,
            size: 22,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text('My Spoto Points', style: _t(14, w: FontWeight.w600)),
    ],
  );

  Widget _tabBar() => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: const Color(0xFF0E1614),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF1B2A26)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_tabs.length, (i) {
        final sel = i == _tab;
        return GestureDetector(
          onTap: () => setState(() => _tab = i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: sel ? const Color(0xFF22B573) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _tabs[i],
              style: _t(10.5, w: sel ? FontWeight.w700 : FontWeight.w500),
            ),
          ),
        );
      }),
    ),
  );
}

// ───────────── Balance card ─────────────
class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A2C1A), Color(0xFF2A1F1C), Color(0xFF2E1E1C)],
        ),
        border: Border.all(color: const Color(0xFF6B4A22), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A4C).withOpacity(0.15),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Points Balance', style: _t(9, c: kGold)),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 10,
                    color: kGold,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.arrow_downward_rounded,
                    size: 10,
                    color: kGreen,
                  ),
                  const SizedBox(width: 2),
                  Text('+5', style: _t(10, w: FontWeight.w700)),
                  const SizedBox(width: 3),
                  Text('today', style: _t(10, c: kMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('570', style: _t(32, w: FontWeight.w700)),
              const SizedBox(width: 4),
              Text('pts', style: _t(15)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 4,
              child: LayoutBuilder(
                builder: (_, c) => Stack(
                  children: [
                    Container(color: const Color(0xFF1A1A1C)),
                    Container(
                      width: c.maxWidth * 0.53,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF07F00), Color(0xFFD4A62A)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '500',
                      style: _t(9.5, c: kMuted),
                    ),
                    TextSpan(
                      text: ' Pro',
                      style: _t(9.5, c: kDimText),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '1,430',
                      style: _t(9.5, c: kMuted),
                    ),
                    TextSpan(
                      text: ' pts to Champion',
                      style: _t(9.5, c: kDimText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                child: _StatTile(value: '+5', label: 'Today'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatTile(value: '+10', label: 'This week'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatTile(value: '+570', label: 'Lifetime'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value, label;
  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.04),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white12),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: _t(15, w: FontWeight.w700, c: kGold),
        ),
        const SizedBox(height: 2),
        Text(label, style: _t(10, c: kMuted)),
      ],
    ),
  );
}

// ───────────── Transaction tile ─────────────
class _TxTile extends StatelessWidget {
  final PointTx tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final positive = tx.points >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kIconBox,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(tx.emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: _t(12, w: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  tx.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _t(10, c: kMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  '${tx.ref}  •  ${tx.date}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _t(8.5, c: kDimText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${positive ? '+' : ''}${tx.points}',
            style: _t(13, w: FontWeight.w700, c: positive ? kGreen : kRed),
          ),
        ],
      ),
    );
  }
}
