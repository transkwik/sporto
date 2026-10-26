import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/prize_utils.dart';
import '../../../core/widgets/glass_back_button.dart';
import 'prize_status_style.dart';
import 'prize_transaction_details_screen.dart';
import 'providers/my_prizes_provider.dart';
import '../bank/withdraw_to_bank_screen.dart';

class MyPrizesScreen extends StatefulWidget {
  const MyPrizesScreen({super.key});

  @override
  State<MyPrizesScreen> createState() => _MyPrizesScreenState();
}

class _MyPrizesScreenState extends State<MyPrizesScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<MyPrizesProvider>();
    provider.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) provider.fetchMyPrizes();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      'My Prizes',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<MyPrizesProvider>(
                  builder: (context, prov, _) => _buildBody(prov),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(MyPrizesProvider prov) {
    if (prov.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.mintGreen));
    }
    if (prov.error != null) {
      return _MessageView(
        icon: Icons.cloud_off_rounded,
        message: prov.error!,
        actionLabel: 'Retry',
        onAction: prov.fetchMyPrizes,
      );
    }

    final items = prov.visible;
    final filter = prov.filter;
    final chips = <(String, bool)>[
      ('All (${prov.prizes.length})', false),
      ('Pending (${prov.count(PayoutStatus.pending)})', false),
      ('Processing (${prov.count(PayoutStatus.processing)})', false),
      ('Credited (${prov.count(PayoutStatus.credited)})', false),
      ('Failed (${prov.count(PayoutStatus.failed)})', true),
    ];

    return RefreshIndicator(
      onRefresh: () => prov.fetchMyPrizes(refresh: true),
      color: AppColors.mintGreen,
      backgroundColor: AppColors.secondary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3A93D),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Earned',
                        style: GoogleFonts.quicksand(
                          color: Colors.black87,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          PrizeUtils.formatMoney(prov.creditedAmount, prov.currency),
                          style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WithdrawToBankScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2410),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Withdraw to bank',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  value: '${prov.teamPrizeCount}',
                  label: 'Team\nPrizes',
                  valueColor: const Color(0xFFE3A93D),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  value: '${prov.individualCount}',
                  label: 'Individual\nAwards',
                  valueColor: const Color(0xFFE85AD4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatTile(
                  value: PrizeUtils.formatMoney(prov.pendingAmount, prov.currency),
                  label: 'Pending',
                  valueColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final (label, failedLook) = chips[index];
                final selected = filter == index;
                final Color bg;
                final Color fg;
                if (selected && failedLook) {
                  bg = const Color(0xFFE85A6B);
                  fg = Colors.white;
                } else if (selected) {
                  bg = const Color(0xFFE3A93D);
                  fg = Colors.black87;
                } else {
                  bg = const Color(0xFF1A1E28);
                  fg = Colors.white70;
                }
                return GestureDetector(
                  onTap: () => prov.setFilter(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(18),
                      border: selected ? null : Border.all(color: AppColors.glassBorder),
                    ),
                    child: Text(
                      label,
                      style: GoogleFonts.quicksand(
                        color: fg,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events_outlined, color: Colors.white24, size: 44),
                  const SizedBox(height: 10),
                  Text(
                    prov.prizes.isEmpty ? 'No prizes yet' : 'No prizes in this category',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            )
          else
            for (final prize in items) ...[
              _PrizeRow(
                prize: prize,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PrizeTransactionDetailsScreen(prize: prize),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white38, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3A93D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  actionLabel,
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.quicksand(
                color: valueColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5, height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _PrizeRow extends StatelessWidget {
  const _PrizeRow({required this.prize, required this.onTap});

  final Map<String, dynamic> prize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = PrizeStatusStyle.of(PrizeUtils.status(prize));
    final tournamentName = PrizeUtils.tournamentName(prize);
    final team = PrizeUtils.teamName(prize);
    final tournamentLine = team == null ? tournamentName : '$tournamentName  •  $team';
    final date = PrizeUtils.listDate(prize);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: Colors.white70, size: 15),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    tournamentLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF141820),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(PrizeUtils.icon(prize), color: Colors.white70, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        PrizeUtils.title(prize),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(style.icon, color: style.color, size: 13),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              PrizeUtils.statusLabel(prize),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: style.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
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
                    Text(
                      PrizeUtils.formatAmount(prize),
                      style: GoogleFonts.quicksand(
                        color: style.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (date.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11),
                      ),
                    ],
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
