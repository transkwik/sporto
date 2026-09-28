import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/prize_details_info.dart';
import 'prize_distribution_screen.dart';

/// Prize Details → See Prize Calculation.
class PrizeCalculationScreen extends StatelessWidget {
  const PrizeCalculationScreen({super.key, this.details = dummyPrizeDetails});

  final PrizeDetailsInfo details;

  @override
  Widget build(BuildContext context) {
    final d = details;
    final individual = d.yourPrizes.where((p) => p.label != 'Winning Team Prize').toList();

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prize Calculation',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            d.dateLabel,
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    _LeagueCard(details: d),
                    const SizedBox(height: 18),
                    Text(
                      'Winning Team Prize',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          _KV(label: 'Team Prize', value: d.teamPrize, valueColor: AppColors.amberAccent),
                          const SizedBox(height: 12),
                          _KV(label: 'Eligible Players', value: d.eligiblePlayers),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6,
                            runSpacing: 8,
                            children: [
                              for (var i = 1; i <= d.eligibleCount; i++)
                                _SlotChip(index: i, isYou: i == d.yourSlot),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            d.formulaLabel,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _KV(label: 'Your Share', value: d.expectedShare, valueColor: AppColors.amberAccent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Individual Awards',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          for (final item in individual) ...[
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: AppColors.amberAccent, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.amountLabel,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          _KV(label: 'Total Individual Awards', value: d.individualAwardsTotal),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3A93D),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Prize',
                            style: GoogleFonts.quicksand(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d.totalPrize,
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            d.totalBreakdown,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              color: Colors.black87,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      d.walletTxnNote,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PrizeDistributionScreen(details: d),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.amberAccent),
                        ),
                        child: Text(
                          'Prize Distribution',
                          style: GoogleFonts.quicksand(
                            color: AppColors.amberAccent,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeagueCard extends StatelessWidget {
  const _LeagueCard({required this.details});

  final PrizeDetailsInfo details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            details.sport,
            style: GoogleFonts.quicksand(
              color: AppColors.amberAccent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            details.tournamentTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(
                icon: Icons.check_circle,
                label: details.eventStatus,
                color: AppColors.mintGreen,
              ),
              _Chip(
                icon: Icons.schedule_rounded,
                label: details.prizeStatus,
                color: AppColors.infoBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.quicksand(color: color, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.index, required this.isYou});

  final int index;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isYou ? 36 : 28,
      height: isYou ? 36 : 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isYou ? const Color(0xFFE3A93D) : const Color(0xFF2A303C),
        shape: BoxShape.circle,
      ),
      child: Text(
        isYou ? 'You' : '$index',
        style: GoogleFonts.quicksand(
          color: isYou ? Colors.black : Colors.white70,
          fontSize: isYou ? 8.5 : 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _KV extends StatelessWidget {
  const _KV({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.quicksand(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
