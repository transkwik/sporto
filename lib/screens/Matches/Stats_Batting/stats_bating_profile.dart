import 'package:flutter/material.dart';

class PlayerProfilePage extends StatelessWidget {
  const PlayerProfilePage({super.key});

  static const Color bgColor = Color(0xFF080C0F);
  static const Color cardColor = Color(0xFF10161A);
  static const Color purple = Color(0xFF71365E);
  static const Color blue = Color(0xFF54C5FF);
  static const Color green = Color(0xFF19BC79);
  static const Color yellow = Color(0xFFFFAD00);
  static const Color pink = Color(0xFFE84BB4);
  static const Color red = Color(0xFFFF515B);
  static const Color muted = Color(0xFF858589);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              _buildProfileCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Batting'),
              const SizedBox(height: 12),
              _buildBattingStats(),
              const SizedBox(height: 24),
              _buildSectionTitle('Bowling & Fielding'),
              const SizedBox(height: 12),
              _buildBowlingStats(),
              const SizedBox(height: 26),
              _buildSectionTitle('Innings Log'),
              const SizedBox(height: 16),
              _buildInningsHeader(),
              const SizedBox(height: 12),
              _buildInningsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF202428),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 19,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Shravan Prajapati',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'TA-2026-0104  ·  Gachibowli Super Over Qualifier',
                style: TextStyle(color: muted, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: purple.withOpacity(0.65), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF211821), Color(0xFF1D151D), Color(0xFF21151E)],
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '#P-0101',
              style: TextStyle(color: muted.withOpacity(0.7), fontSize: 13),
            ),
          ),
          const SizedBox(height: 0),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFAC9A82),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(Icons.person, size: 65, color: Color(0xFF493D37)),
          ),
          const SizedBox(height: 24),
          const Text(
            'Shravan Prajapati',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Hyd Highlanders',
            style: TextStyle(
              color: blue,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Captain  ·  Batter',
            style: TextStyle(color: muted, fontSize: 13),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _profileStat('6', 'Matches', Colors.white)),
              const SizedBox(width: 3),
              Expanded(child: _profileStat('204', 'MVP pts', yellow)),
              const SizedBox(width: 3),
              Expanded(child: _profileStat('6', 'Wins', green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileStat(String value, String label, Color valueColor) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: green.withOpacity(0.12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: muted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFB2B2B4),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildBattingStats() {
    return _buildStatsGrid([
      _StatItem('6', 'Innings', Colors.white),
      _StatItem('77', 'Runs', Colors.white),
      _StatItem('58', 'Balls Faced', Colors.white),
      _StatItem('132.76', 'Strike Rate', green),
      _StatItem('23', 'Highest Score', yellow),
      _StatItem('5/4', 'Fours/Sixes', pink),
    ]);
  }

  Widget _buildBowlingStats() {
    return Column(
      children: [
        _buildStatsGrid([
          _StatItem('2', 'Overs', Colors.white),
          _StatItem('2', 'Wickets', red),
          _StatItem('8', 'Runs Conceded', Colors.white),
          _StatItem('4.0', 'Economy', Colors.white),
          _StatItem('2/8', 'Best Figures', green),
          _StatItem('8', 'Dot Balls', blue),
        ]),
        Container(
          width: double.infinity,
          height: 48,
          decoration: const BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(17),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Catches / Run-outs',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              const SizedBox(width: 10),
              const Text(
                '2/1',
                style: TextStyle(
                  color: pink,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(List<_StatItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1.38,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.only(
              topLeft: index == 0 ? const Radius.circular(18) : Radius.zero,
              topRight: index == 2 ? const Radius.circular(18) : Radius.zero,
              bottomLeft: index == 3 ? const Radius.circular(18) : Radius.zero,
              bottomRight: index == 5 ? const Radius.circular(18) : Radius.zero,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.value,
                style: TextStyle(
                  color: item.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted, fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInningsHeader() {
    return const Row(
      children: [
        Expanded(
          child: Text('Batting', style: TextStyle(color: muted, fontSize: 11)),
        ),
        SizedBox(
          width: 66,
          child: Text(
            'R&B',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            '4s',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            '6s',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildInningsList() {
    final innings = [
      'Delhi Warriors',
      'Malkajgiri Mustangs',
      'Uppal Uhlans',
      'LB Nagar Lions',
      'Malkajgiri Mustangs',
    ];

    return Column(
      children: innings.map((team) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFF14181C),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'vs ',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          TextSpan(
                            text: team,
                            style: const TextStyle(
                              color: blue,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Semi-final 2  ·  SPT-20481',
                      style: TextStyle(color: muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 66,
                child: Text(
                  '9 (15)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(
                width: 40,
                child: Text(
                  '2',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(
                width: 40,
                child: Text(
                  '4',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem {
  final String value;
  final String label;
  final Color color;

  const _StatItem(this.value, this.label, this.color);
}
