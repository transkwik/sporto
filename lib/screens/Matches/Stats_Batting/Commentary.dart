import 'package:flutter/material.dart';

// ---------------------------------------------------------------- COLORS
// Named CmColors so it doesn't clash with other AppColors classes.
class CmColors {
  static const bg = Color(0xFF0A0D14);
  static const backBtn = Color(0xFF1A1D23);
  static const muted = Color(0xFF8A919E);
  static const green = Color(0xFF2DBE7A);
  static const blue = Color(0xFF4FB3F6);
  static const amber = Color(0xFFFFB81C);
  static const orange = Color(0xFFF08A00);
  static const chaseBg = Color(0xFF141A28);
  static const rowA = Color(0xFF141824);
  static const rowB = Color(0xFF10131C);
  static const chip = Color(0xFF0B0D13);
}

// ---------------------------------------------------------------- MODEL
class CommentaryItem {
  final String over;
  final String text;
  final String time;
  const CommentaryItem(this.over, this.text, this.time);
}

const _items = <CommentaryItem>[
  CommentaryItem('16.4', 'Shravan to Amit Kumar 4 runs.', '10:20 AM'),
  CommentaryItem('16.4', 'Shravan to Amit Kumar 4 runs.', '10:20 AM'),
  CommentaryItem('16.4', 'Shravan to Amit Kumar 4 runs.', '10:20 AM'),
  CommentaryItem('16.4', 'Shravan to Amit Kumar 4 runs.', '10:20 AM'),
  CommentaryItem('16.4', 'Shravan to Amit Kumar 4 runs.', '10:20 AM'),
];

// ---------------------------------------------------------------- FULL SCREEN
// Standalone screen: header + tabs + commentary content.
class MatchCommentaryScreen extends StatelessWidget {
  const MatchCommentaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CmColors.bg,
      body: SafeArea(
        child: Column(children: const [Expanded(child: CommentaryPage())]),
      ),
    );
  }
}

// ---------------------------------------------------------------- CONTENT
// Use this directly inside a tab (e.g. in _buildTabContent) if you
// already have your own header and tabs.
class CommentaryPage extends StatelessWidget {
  const CommentaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CmColors.bg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
        children: [
          const _ScoreCard(),
          const SizedBox(height: 18),
          const Text(
            'Commentary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                for (int i = 0; i < _items.length; i++)
                  _CommentaryRow(item: _items[i], even: i.isEven),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- SCORE CARD
class _ScoreCard extends StatelessWidget {
  const _ScoreCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CmColors.chaseBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // Gradient score area
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A2A28),
                  Color(0xFF12271E),
                  Color(0xFF2E3318),
                ],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF8CD8FF), Color(0xFF3FB0F0)],
                              ),
                            ),
                            child: const Text(
                              'HH',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0A2A40),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hyd Highlanders',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: const [
                                  Text(
                                    '80/2',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: CmColors.blue,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '4/6',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Text(
                            'Delhi W',
                            style: TextStyle(
                              fontSize: 10,
                              color: CmColors.muted,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '102/5',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '(6.0)',
                            style: TextStyle(
                              fontSize: 10,
                              color: CmColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Diagonal divider
                Transform.rotate(
                  angle: 0.2,
                  child: Container(
                    width: 1,
                    height: 54,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white24, Colors.transparent],
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: CmColors.amber,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Chase info
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Text(
              'Hyd Highlanders need 22 runs in 12 balls',
              style: TextStyle(fontSize: 11, color: CmColors.amber),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- ROW
class _CommentaryRow extends StatelessWidget {
  final CommentaryItem item;
  final bool even;
  const _CommentaryRow({required this.item, required this.even});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: even ? CmColors.rowA : CmColors.rowB,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            decoration: BoxDecoration(
              color: CmColors.chip,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.over,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            item.time,
            style: const TextStyle(fontSize: 9, color: CmColors.muted),
          ),
        ],
      ),
    );
  }
}
