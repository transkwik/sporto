// pubspec.yaml -> dependencies:
//   fl_chart: ^0.69.0
//
// Run: flutter pub get && flutter run

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// ---------------------------------------------------------------- THEME
class AppColors {
  static const bg = Color(0xFF07070C);
  static const card = Color(0xFF12121A);
  static const chartBg = Color(0xFF0B0B12);
  static const blue = Color(0xFF4FB3F6);
  static const pink = Color(0xFFF05BD0);
  static const orange = Color(0xFFF08A00);
  static const green = Color(0xFF2ECC71);
  static const yellow = Color(0xFFF5B400);
  static const grey = Color(0xFF8A8A96);
  static const barDone = Color(0xFF6B2A6E);
  static const wicket = Color(0xFFFF2D2D);
}

// ---------------------------------------------------------------- DATA
const hydRuns = [20, 11, 14, 8, 12, 15];
const delRuns = [12, 9, 18, 6, 11, 5];
const hydWickets = [false, true, false, false, true, false];
const delWickets = [true, true, false, true, false, false];

const hydWorm = [0.0, 10.0, 21.0, 64.0, 75.0, 85.0, 126.0];
const delWorm = [0.0, 6.0, 17.0, 50.0, 81.0, 77.0, 120.0];

// ---------------------------------------------------------------- PAGE
class GraphPage extends StatefulWidget {
  const GraphPage({super.key});
  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  int teamIdx = 1; // 0 = Hyd, 1 = Delhi
  int inningsIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          children: [
            // const _Header(),
            // const _TabsBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                children: [
                  const _ScoreCard(),
                  const SizedBox(height: 16),
                  _sectionTitle('Manhattan', '(runs per over)', '9.8 avg'),
                  _manhattanCard(),
                  const SizedBox(height: 16),
                  _sectionTitle('Worm', '(cumulative runs)', '9.8 avg'),
                  _wormCard(),
                  const SizedBox(height: 16),
                  _inningsToggle(),
                  const SizedBox(height: 12),
                  _commentaryList(),
                  const SizedBox(height: 16),
                  _insights(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------ section title
  Widget _sectionTitle(String title, String sub, String avg) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 5),
        Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.grey)),
        const Spacer(),
        Text(avg, style: const TextStyle(fontSize: 10, color: AppColors.grey)),
      ],
    ),
  );

  // ------------------------------------------------------ Manhattan
  Widget _manhattanCard() {
    final runs = teamIdx == 0 ? hydRuns : delRuns;
    final wk = teamIdx == 0 ? hydWickets : delWickets;
    const currentOver = 5; // index of the over in progress

    final groups = List.generate(runs.length, (i) {
      final isCurrent = i == currentOver;
      return BarChartGroupData(
        x: i + 1,
        showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: runs[i].toDouble(),
            width: 38,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isCurrent
                  ? [const Color(0xFFFF5BE0), const Color(0xFFD060B0)]
                  : [const Color(0xFF6B2A6E), const Color(0xFF55285A)],
            ),
          ),
        ],
      );
    });

    return _Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _teamChip('Hyd Highlanders', 0),
              const SizedBox(width: 8),
              _teamChip('Delhi Warriors', 1),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 230,
            padding: const EdgeInsets.fromLTRB(6, 10, 10, 4),
            decoration: BoxDecoration(
              color: AppColors.chartBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 6, bottom: 4),
                  child: Text(
                    'Runs',
                    style: TextStyle(fontSize: 10, color: AppColors.grey),
                  ),
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: 21,
                      minY: 0,
                      alignment: BarChartAlignment.spaceAround,
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: 3,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: Colors.redAccent.withOpacity(0.35),
                          strokeWidth: 0.6,
                          dashArray: [4, 4],
                        ),
                      ),
                      titlesData: _barTitles(),
                      barTouchData: BarTouchData(
                        enabled: false,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => Colors.transparent,
                          tooltipPadding: EdgeInsets.zero,
                          tooltipMargin: 2,
                          getTooltipItem: (group, gi, rod, ri) {
                            final hasWicket = wk[gi];
                            return BarTooltipItem(
                              hasWicket ? '●\n' : '',
                              const TextStyle(
                                color: AppColors.wicket,
                                fontSize: 9,
                                height: 1.1,
                              ),
                              children: [
                                TextSpan(
                                  text: rod.toY.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      barGroups: groups,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _legend(AppColors.barDone, 'Over Completed'),
              const SizedBox(width: 10),
              _legend(AppColors.pink, 'Current Over'),
              const SizedBox(width: 10),
              _legend(AppColors.wicket, 'Wicket'),
              const Spacer(),
              const Text(
                'Full Screen',
                style: TextStyle(fontSize: 11, color: AppColors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  FlTitlesData _barTitles() => FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 24,
        interval: 3,
        getTitlesWidget: (v, _) => Text(
          v.toInt().toString(),
          style: const TextStyle(fontSize: 10, color: AppColors.grey),
        ),
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTitlesWidget: (v, _) => Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            v.toInt().toString(),
            style: const TextStyle(fontSize: 10, color: AppColors.grey),
          ),
        ),
      ),
    ),
  );

  Widget _teamChip(String name, int idx) {
    final selected = teamIdx == idx;
    return GestureDetector(
      onTap: () => setState(() => teamIdx = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFF08A00), Color(0xFFD4A020)],
                )
              : null,
          color: selected ? null : const Color(0xFF1B1B25),
          border: selected ? null : Border.all(color: Colors.white12),
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.grey,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------ Worm
  Widget _wormCard() {
    List<FlSpot> spots(List<double> d) => [
      for (int i = 0; i < d.length; i++) FlSpot(i.toDouble(), d[i]),
    ];

    LineChartBarData line(List<double> d, Color c, Set<int> dots) =>
        LineChartBarData(
          spots: spots(d),
          color: c,
          barWidth: 1.5,
          isCurved: false,
          dotData: FlDotData(
            checkToShowDot: (s, _) => dots.contains(s.x.toInt()),
            getDotPainter: (s, p, b, i) => FlDotCirclePainter(
              radius: 3.5,
              color: c,
              strokeWidth: 1,
              strokeColor: Colors.white24,
            ),
          ),
        );

    return _Card(
      child: Column(
        children: [
          Container(
            height: 230,
            padding: const EdgeInsets.fromLTRB(6, 10, 14, 4),
            decoration: BoxDecoration(
              color: AppColors.chartBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 6, bottom: 4),
                  child: Text(
                    'Runs',
                    style: TextStyle(fontSize: 10, color: AppColors.grey),
                  ),
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: 130,
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: Colors.redAccent.withOpacity(0.3),
                          strokeWidth: 0.6,
                          dashArray: [4, 4],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 26,
                            interval: 20,
                            getTitlesWidget: (v, _) => Text(
                              v.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            interval: 1,
                            getTitlesWidget: (v, _) => v == 0
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      v.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      lineBarsData: [
                        line(hydWorm, AppColors.blue, {2, 3, 5, 6}),
                        line(delWorm, AppColors.pink, {2, 4, 5, 6}),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _legend(AppColors.blue, 'Hyd Highlanders'),
              const SizedBox(width: 12),
              _legend(AppColors.pink, 'Delhi Warriors'),
              const Spacer(),
              const Text(
                'Full Screen',
                style: TextStyle(fontSize: 11, color: AppColors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color c, String t) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 4),
      Text(t, style: const TextStyle(fontSize: 10, color: AppColors.grey)),
    ],
  );

  // ------------------------------------------------------ Innings toggle
  Widget _inningsToggle() {
    Widget item(String t, int i) {
      final sel = inningsIdx == i;
      return GestureDetector(
        onTap: () => setState(() => inningsIdx = i),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: sel ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            t,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: sel ? Colors.white : AppColors.grey,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF10201A),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [item('1st Innings', 0), item('2nd Innings', 1)],
        ),
      ),
    );
  }

  // ------------------------------------------------------ Commentary
  Widget _commentaryList() => Column(
    children: List.generate(
      5,
      (i) => Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        color: i.isEven ? const Color(0xFF14141C) : const Color(0xFF101018),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F2A),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                '16.4',
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Shravan to Amit Kumar 4 runs.',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
            const Text(
              '10:20 AM',
              style: TextStyle(fontSize: 10, color: AppColors.grey),
            ),
          ],
        ),
      ),
    ),
  );

  // ------------------------------------------------------ Insights
  Widget _insights() {
    Widget row(String label, String over, String value, {bool last = false}) =>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: last
                ? null
                : const Border(bottom: BorderSide(color: Colors.white10)),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const Spacer(),
              Text(
                over,
                style: const TextStyle(fontSize: 11, color: AppColors.grey),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  '•',
                  style: TextStyle(fontSize: 11, color: AppColors.grey),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Match Insights', '', '9.8 avg'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              row('Highest scoring over', '3rd Over', '16 runs'),
              row('Lowest scoring over', '6th Over', '5 runs'),
              row('Most boundaries in an over', '3rd Over', '2 4s · 1 6s'),
              row('Over with most wickets', '1st Over', '1 wicket', last: true),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- WIDGETS
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white10),
    ),
    child: child,
  );
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A22),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.chevron_left, size: 22),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Asia Cup 2026',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text(
                  'Quarter Final',
                  style: TextStyle(fontSize: 10, color: AppColors.green),
                ),
                SizedBox(width: 6),
                Text(
                  '•',
                  style: TextStyle(fontSize: 10, color: AppColors.grey),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.location_on_outlined,
                  size: 11,
                  color: AppColors.grey,
                ),
                SizedBox(width: 2),
                Text(
                  'Hyderabad',
                  style: TextStyle(fontSize: 10, color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

class _TabsBar extends StatelessWidget {
  const _TabsBar();
  @override
  Widget build(BuildContext context) {
    const tabs = ['Scorecard', 'Info', 'States', 'Graph', 'Commentary'];
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((t) {
          final sel = t == 'Graph';
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: sel ? AppColors.orange : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              t,
              style: TextStyle(
                fontSize: 12,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                color: sel ? Colors.white : AppColors.grey,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white12),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1F2A33), Color(0xFF2A2A15)],
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Text(
            'HH',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0A2A40),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hyd Highlanders',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: const [
                  Text(
                    '80/2',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '4/6',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Text(
                'Delhi W  102/5 (6.0)',
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
        ),
        const Text(
          '1',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.yellow,
          ),
        ),
        const SizedBox(width: 24),
      ],
    ),
  );
}
