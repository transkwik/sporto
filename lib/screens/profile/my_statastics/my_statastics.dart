import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';

/// Profile → My Statistics: per-sport stats with a sport selector.
class MyStatastcs extends StatefulWidget {
  const MyStatastcs({super.key, this.onNewSport});

  /// Called when "+ New Sport" is tapped.
  final VoidCallback? onNewSport;

  @override
  State<MyStatastcs> createState() => _MyStatastcsState();
}

class _SportChip {
  const _SportChip(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _MyStatastcsState extends State<MyStatastcs> {
  int _selected = 0;

  static const _sports = [
    _SportChip('Cricket', Icons.sports_cricket),
    _SportChip('Football', Icons.sports_soccer),
    _SportChip('Football', Icons.sports_soccer),
    _SportChip('Football', Icons.sports_soccer),
    _SportChip('Basketball', Icons.sports_basketball),
    _SportChip('Tennis', Icons.sports_tennis),
    _SportChip('Hockey', Icons.sports_hockey),
    _SportChip('Volleyball', Icons.sports_volleyball),
  ];

  // Colors taken from the design
  static const _chipGreen = Color(0xFF27B86F);
  static const _amber = Color(0xFFF5B31B);
  static const _orange = Color(0xFFF29A1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              _buildSportChips(),
              const SizedBox(height: 22),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  child: _selected == 0
                      ? _buildCricketStats()
                      : _buildEmpty(_sports[_selected].label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Header ─────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          GlassBackButton(onTap: () => Navigator.of(context).pop()),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'My Statistics',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onNewSport,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF86D6FF), Color(0xFF3DB2F0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, color: Colors.black87, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'New Sport',
                    style: GoogleFonts.quicksand(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Sport chips ─────────────────────────

  Widget _buildSportChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _sports.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final sport = _sports[index];
          final selected = _selected == index;
          return GestureDetector(
            onTap: () => setState(() => _selected = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? _chipGreen : const Color(0xFF14181F),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? _chipGreen : const Color(0xFF2A2F3A),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    sport.icon,
                    size: 20,
                    color: selected ? Colors.black87 : Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sport.label,
                    style: GoogleFonts.quicksand(
                      color: selected ? Colors.black87 : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ───────────────────────── Cricket stats ─────────────────────────

  Widget _buildCricketStats() {
    return Column(
      children: [
        // Summary tiles
        Row(
          children: [
            _summaryTile('34', 'Matches'),
            const SizedBox(width: 10),
            _summaryTile('612', 'Runs'),
            const SizedBox(width: 10),
            _summaryTile('41', 'Wickets'),
            const SizedBox(width: 10),
            _summaryTile('5.8', 'Economy'),
          ],
        ),
        const SizedBox(height: 22),

        // Batting
        _StatSectionCard(
          title: 'Batting',
          titleColor: const Color(0xFFE958B8),
          highlightValue: '612',
          highlightLabel: 'Runs',
          backgroundColor: const Color(0xFF22132A),
          borderColor: const Color(0xFF5A2A63),
          tileColor: const Color(0xFF2F1830),
          tiles: const [
            _StatTileData('58', '4s', flex: 10),
            _StatTileData('21', '6s', flex: 10),
            _StatTileData('47*', 'Highest Score', flex: 12),
          ],
          footerLeftValue: '138.4',
          footerLeftLabel: 'Strike Rate',
          footerRightValue: '24.5',
          footerRightLabel: 'Average',
          highlightColor: _orange,
        ),
        const SizedBox(height: 16),

        // Bowling
        _StatSectionCard(
          title: 'Bowling',
          titleColor: const Color(0xFF4FB8F0),
          highlightValue: '41',
          highlightLabel: 'Wickets',
          backgroundColor: const Color(0xFF121F2B),
          borderColor: const Color(0xFF1F4B5E),
          tileColor: const Color(0xFF182C3B),
          tiles: const [
            _StatTileData('71.2', 'Overs Bowled'),
            _StatTileData('5.8', 'Economy'),
            _StatTileData('3/8', 'Best Figures'),
          ],
          note: 'Overs shown in Spoto Mini Overs (3 balls each).',
          highlightColor: _orange,
        ),
      ],
    );
  }

  Widget _summaryTile(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF141820),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF262B36)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.quicksand(
                color: _amber,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(String sport) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Text(
          'No $sport statistics yet',
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
        ),
      ),
    );
  }
}

// ───────────────────────── Reusable section card ─────────────────────────

class _StatTileData {
  const _StatTileData(this.value, this.label, {this.flex = 1});
  final String value;
  final String label;
  final int flex;
}

class _StatSectionCard extends StatelessWidget {
  const _StatSectionCard({
    required this.title,
    required this.titleColor,
    required this.highlightValue,
    required this.highlightLabel,
    required this.highlightColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.tileColor,
    required this.tiles,
    this.footerLeftValue,
    this.footerLeftLabel,
    this.footerRightValue,
    this.footerRightLabel,
    this.note,
  });

  final String title;
  final Color titleColor;
  final String highlightValue;
  final String highlightLabel;
  final Color highlightColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color tileColor;
  final List<_StatTileData> tiles;
  final String? footerLeftValue;
  final String? footerLeftLabel;
  final String? footerRightValue;
  final String? footerRightLabel;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.quicksand(
                    color: titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                highlightValue,
                style: GoogleFonts.quicksand(
                  color: highlightColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                highlightLabel,
                style: GoogleFonts.quicksand(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Inner tiles
          Row(
            children: [
              for (int i = 0; i < tiles.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  flex: tiles[i].flex,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tiles[i].value,
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            tiles[i].label,
                            maxLines: 1,
                            style: GoogleFonts.quicksand(
                              color: Colors.white60,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),

          // Footer (strike rate / average)
          if (footerLeftValue != null || footerRightValue != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (footerLeftValue != null)
                  _footerText(footerLeftValue!, footerLeftLabel ?? ''),
                if (footerRightValue != null)
                  _footerText(footerRightValue!, footerRightLabel ?? ''),
              ],
            ),
          ],

          // Note
          if (note != null) ...[
            const SizedBox(height: 16),
            Text(
              note!,
              style: GoogleFonts.quicksand(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _footerText(String value, String label) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: value,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' $label',
            style: GoogleFonts.quicksand(
              color: Colors.white60,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
