import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/fan_tip_info.dart';
import 'fan_tip_details_screen.dart';

/// Profile → My Fan Tips: sent / via team / individual tip history.
class MyFanTipsScreen extends StatefulWidget {
  const MyFanTipsScreen({super.key, this.tips = dummyFanTips});

  final List<FanTip> tips;

  @override
  State<MyFanTipsScreen> createState() => _MyFanTipsScreenState();
}

class _MyFanTipsScreenState extends State<MyFanTipsScreen> {
  int _filter = 0;

  static const _chips = ['Sent', 'Via Team', 'Individual'];

  String get _subtitle {
    switch (_filter) {
      case 1:
        return "Tips you've sent through a team wallet.";
      case 2:
        return "Tips you've sent directly to individual players.";
      default:
        return "Tips you've sent directly to individual players.";
    }
  }

  List<FanTip> get _visible {
    switch (_filter) {
      case 1:
        return widget.tips.where((t) => t.channel == FanTipChannel.viaTeam).toList();
      case 2:
        return widget.tips.where((t) => t.channel == FanTipChannel.individual).toList();
      default:
        return widget.tips;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _visible;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Fan Tips',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _chips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final selected = _filter == index;
                    return GestureDetector(
                      onTap: () => setState(() => _filter = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.mintGreen : AppColors.glassFillLighter,
                          borderRadius: BorderRadius.circular(20),
                          border: selected ? null : Border.all(color: AppColors.glassBorder),
                        ),
                        child: Text(
                          _chips[index],
                          style: GoogleFonts.quicksand(
                            color: selected ? Colors.black87 : Colors.white,
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
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No fan tips yet',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _FanTipCard(
                          tip: items[index],
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FanTipDetailsScreen(tip: items[index]),
                              ),
                            );
                          },
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

class _FanTipCard extends StatelessWidget {
  const _FanTipCard({required this.tip, required this.onTap});

  final FanTip tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF222632),
              shape: BoxShape.circle,
            ),
            child: Icon(tip.sportIcon, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.playerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tip.teamLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tip.dateLabel,
                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                tip.amountLabel,
                style: GoogleFonts.quicksand(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
