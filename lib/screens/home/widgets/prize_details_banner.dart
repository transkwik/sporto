import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/apiServices/user_api.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/prize_utils.dart';
import '../prize_details_screen.dart';

/// Loads the user's latest prize payout and shows [PrizeDetailsBanner] for it.
/// Renders nothing while loading, on error, or when the user has no prizes.
/// Change [Key] (e.g. via a refresh counter) to reload.
class LatestPrizeBanner extends StatefulWidget {
  const LatestPrizeBanner({super.key});

  @override
  State<LatestPrizeBanner> createState() => _LatestPrizeBannerState();
}

class _LatestPrizeBannerState extends State<LatestPrizeBanner> {
  Map<String, dynamic>? _payout;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await UserApis().getMyPrizes(1, 20);
      if (res is! Map || res['success'] != true || res['data'] is! List) return;
      Map<String, dynamic>? pick;
      for (final item in res['data'] as List) {
        if (item is! Map) continue;
        final p = Map<String, dynamic>.from(item);
        if (PrizeUtils.tournamentId(p) == null) continue;
        // Prefer a payout still in progress; otherwise the first (latest) one.
        final s = PrizeUtils.status(p);
        if (s == PayoutStatus.pending || s == PayoutStatus.processing) {
          pick = p;
          break;
        }
        pick ??= p;
      }
      if (!mounted) return;
      setState(() => _payout = pick);
    } catch (_) {
      // Banner is optional; stay hidden on failure.
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _payout;
    if (p == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: PrizeDetailsBanner(
        payout: p,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PrizeDetailsScreen(
                tournamentId: PrizeUtils.tournamentId(p)!,
                tournamentName: PrizeUtils.tournamentName(p),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Home dashboard prize card above Needs Your Attention.
class PrizeDetailsBanner extends StatelessWidget {
  const PrizeDetailsBanner({super.key, this.onTap, required this.payout});

  final VoidCallback? onTap;
  final Map<String, dynamic> payout;

  String get _statusText => switch (PrizeUtils.status(payout)) {
        PayoutStatus.credited => 'Your prize has been credited.',
        PayoutStatus.failed => 'Your prize payout failed.',
        PayoutStatus.processing => 'Your prize is being processed.',
        PayoutStatus.pending => 'Your prize is pending.',
      };

  static const _gold = Color(0xFFE3A93D);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF3AD7E8).withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3AD7E8).withValues(alpha: 0.18),
              blurRadius: 16,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.prizeBackground,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.55, 0),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF071018),
                        const Color(0xF2081420),
                        const Color(0x990A1828),
                        Colors.black.withValues(alpha: 0.15),
                      ],
                      stops: const [0, 0.38, 0.58, 1],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events_rounded, color: _gold, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            'Prize Won!',
                            style: GoogleFonts.quicksand(
                              color: _gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(right: 72),
                      child: Text(
                        PrizeUtils.tournamentName(payout),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 72),
                      child: Text.rich(
                        TextSpan(
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                          children: [
                            const TextSpan(text: 'You won '),
                            TextSpan(
                              text: PrizeUtils.title(payout),
                              style: GoogleFonts.quicksand(
                                color: _gold,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                            ),
                            TextSpan(text: ' · ${PrizeUtils.formatAmount(payout)}'),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            _statusText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white70,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.infoBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Prize Details  >',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
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
