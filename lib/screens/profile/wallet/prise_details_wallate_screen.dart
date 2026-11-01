import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sporto/models/prize_details_info.dart';
import 'package:sporto/screens/profile/wallet/prize_calculation_wallate_screen.dart';
import 'package:sporto/screens/profile/wallet/prise_distubution_wallate_screen.dart';
import 'package:sporto/screens/profile/wallet/my_tournament_details_wallate_screen.dart';

class PrizeDetailsWallateScreen extends StatefulWidget {
  const PrizeDetailsWallateScreen({
    super.key,
    this.details = dummyPrizeDetails,
  });

  final PrizeDetailsInfo details;

  @override
  State<PrizeDetailsWallateScreen> createState() =>
      _PrizeDetailsWallateScreenState();
}

class _PrizeDetailsWallateScreenState extends State<PrizeDetailsWallateScreen> {
  bool _showAllPrizes = true;

  static const Color _background = Color(0xFF080B0E);
  static const Color _card = Color(0xFF1C2026);
  static const Color _muted = Color(0xFF999DA3);
  static const Color _amber = Color(0xFFFFB900);
  static const Color _green = Color(0xFF62EF91);

  TextStyle get _mutedStyle =>
      GoogleFonts.quicksand(color: _muted, fontSize: 11.5);

  void _openCalculation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrizeCalculationWallateScreen(details: widget.details),
      ),
    );
  }

  void _openDistribution() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrizeDistributionWallateScreen(details: widget.details),
      ),
    );
  }

  void _openTournamentDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MyTournamentDetailswallateScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.details;
    final prizes = d.yourPrizes;
    final visiblePrizes = _showAllPrizes ? prizes : prizes.take(3).toList();

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(d),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                children: [
                  _buildMatchCard(d),
                  const SizedBox(height: 14),
                  _buildInfoCard(d),
                  const SizedBox(height: 20),

                  // Compact statistic cards, using fields already in the model.
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          value: d.eligiblePlayers,
                          label: 'Eligible Players',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          value: d.teamPrize,
                          label: 'Team Prize',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          value: d.expectedShare,
                          label: 'Your Share',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: _amber,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Tournament Prizes',
                        style: GoogleFonts.quicksand(
                          color: _amber,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text('${prizes.length} Prizes', style: _mutedStyle),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Special prize cards are shown only when prize entries exist.
                  if (prizes.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: _buildSpecialPrize(
                            'Best Batsman',
                            prizes.first.amountLabel,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildSpecialPrize(
                            'Best Bowler',
                            prizes.length > 1 ? prizes[1].amountLabel : '—',
                          ),
                        ),
                      ],
                    ),
                  if (prizes.isNotEmpty) const SizedBox(height: 10),

                  _buildPrizeList(visiblePrizes),
                  if (prizes.length > 3) ...[
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _showAllPrizes = !_showAllPrizes);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF252E3B),
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: const Color(0xFF35475D)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _showAllPrizes
                                    ? 'View Less'
                                    : 'View All Prizes',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                _showAllPrizes
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white70,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 22),
                  Text(
                    'Format',
                    style: GoogleFonts.quicksand(
                      color: _green,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildFormatCard(d),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(PrizeDetailsInfo d) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF202328),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.tournamentTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: _muted,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        d.dateLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _mutedStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(PrizeDetailsInfo d) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF53342F), Color(0xFF102D21), Color(0xFF28331A)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE92343),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      d.eventStatus,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    d.dateLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.quicksand(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 5, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    d.winningEventTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Vs',
                    style: GoogleFonts.quicksand(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    d.winningEventSubtitle,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Match Prize', style: _mutedStyle),
                      const SizedBox(height: 5),
                      Text(
                        '🏆 ${d.teamPrize}',
                        style: GoogleFonts.quicksand(
                          color: _amber,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Prize Status', style: _mutedStyle),
                      const SizedBox(height: 5),
                      Text(
                        d.prizeStatus,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(PrizeDetailsInfo d) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        gradient: const LinearGradient(
          colors: [Color(0xFF14291F), Color(0xFF111B19)],
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _infoColumn('Sport', d.sport)),
          Expanded(
            child: _infoColumn(
              'Eligible Players',
              d.eligiblePlayers,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label, style: _mutedStyle),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String value, required String label}) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF24231C),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(color: _muted, fontSize: 9.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialPrize(String title, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title, style: _mutedStyle),
          const SizedBox(height: 5),
          Text(
            amount,
            style: GoogleFonts.quicksand(
              color: _amber,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizeList(List<PrizeLineItem> prizes) {
    if (prizes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Center(
          child: Text('No prize details available', style: _mutedStyle),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(17),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < prizes.length; i++)
            _buildPrizeRow(prizes[i], i, i == prizes.length - 1),
        ],
      ),
    );
  }

  Widget _buildPrizeRow(PrizeLineItem item, int index, bool isLast) {
    final List<Color> badgeColors = [
      const Color(0xFFFFCC32),
      const Color(0xFF70F59A),
      const Color(0xFFFF8055),
      const Color(0xFF383C42),
    ];

    final Color badgeColor = index < badgeColors.length
        ? badgeColors[index]
        : badgeColors[3];
    final Color numberColor = index < 3 ? Colors.black : Colors.white54;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                height: 27,
                width: 27,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.quicksand(
                    color: numberColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.amountLabel,
                style: GoogleFonts.quicksand(
                  color: index < 3 ? _amber : Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Container(height: 1, color: Colors.black.withValues(alpha: 0.65)),
      ],
    );
  }

  Widget _buildFormatCard(PrizeDetailsInfo d) {
    if (d.steps.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF244333)),
        ),
        child: Text(
          'Tournament format details will be updated soon.',
          style: _mutedStyle,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF244333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < d.steps.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == d.steps.length - 1 ? 0 : 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle_outlined, size: 9, color: _green),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.steps[i].title,
                          style: GoogleFonts.quicksand(
                            color: _muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (d.steps[i].subtitle.isNotEmpty)
                          Text(
                            d.steps[i].subtitle,
                            style: GoogleFonts.quicksand(
                              color: _muted,
                              fontSize: 11.5,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
