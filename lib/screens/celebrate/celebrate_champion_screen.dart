import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/celebrate_info.dart';
import 'celebrate_pick_player_screen.dart';
import 'celebrate_tip_screen.dart';
import 'widgets/celebrate_team_hero.dart';

/// Celebrate list → champion / fan-support detail.
class CelebrateChampionScreen extends StatelessWidget {
  const CelebrateChampionScreen({super.key, required this.campaign});

  final CelebrateCampaign campaign;

  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);

  void _openTip(BuildContext context, CelebrateTipKind kind) {
    if (kind == CelebrateTipKind.player) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CelebratePickPlayerScreen(campaign: campaign),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CelebrateTipScreen(campaign: campaign, kind: kind),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = campaign;

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
                      'Champion',
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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    CelebrateTeamHero(campaign: c),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _StatBox(value: '${c.championships}', label: 'Championships')),
                        const SizedBox(width: 8),
                        Expanded(child: _StatBox(value: '${c.tournamentWins}', label: 'Tournament Wins')),
                        const SizedBox(width: 8),
                        Expanded(child: _StatBox(value: '${c.mvpAwards}', label: 'MVP Awards')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          size: 14,
                          color: c.isOpen ? _pink : _pink.withValues(alpha: 0.45),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          c.isOpen ? 'Fan Support Open' : 'Fan Support Closed',
                          style: GoogleFonts.quicksand(
                            color: c.isOpen ? _pink : Colors.white38,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1220),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _pink.withValues(alpha: 0.55)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _SupportStat(
                                  value: c.totalSupportShort.isEmpty ? c.amountLabel : c.totalSupportShort,
                                  label: 'Total Support',
                                ),
                              ),
                              Expanded(
                                child: _SupportStat(value: '${c.fans}', label: 'Supporters'),
                              ),
                              Expanded(
                                child: _SupportStat(value: '${c.tipsCount}', label: 'Tips'),
                              ),
                            ],
                          ),
                          if (c.remainingLabel != null && c.remainingLabel!.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.schedule_rounded, color: _gold, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  c.remainingLabel!,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Recent Fan Messages',
                      style: GoogleFonts.quicksand(
                        color: AppColors.infoBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (c.messages.isEmpty)
                      Text(
                        'No fan messages yet',
                        style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13),
                      )
                    else
                      for (final m in c.messages) ...[
                        _MessageCard(message: m),
                        const SizedBox(height: 8),
                      ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.celebration_rounded, color: _gold, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Celebrate The Champion',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Loved their game? Show them your support.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                    ),
                    const SizedBox(height: 14),
                    _TipActionCard(
                      title: 'Tip Winning Team',
                      subtitle: 'Send a celebration tip to the whole winning team.',
                      actionLabel: 'Tip Team',
                      actionColor: _pink,
                      borderColor: _pink.withValues(alpha: 0.7),
                      onTap: () => _openTip(context, CelebrateTipKind.team),
                    ),
                    const SizedBox(height: 10),
                    _TipActionCard(
                      title: 'Tip a Player',
                      subtitle: 'Recognize and support an individual champion.',
                      actionLabel: 'Tip A Player',
                      actionColor: _gold,
                      borderColor: _gold.withValues(alpha: 0.75),
                      onTap: () => _openTip(context, CelebrateTipKind.player),
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

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _SupportStat extends StatelessWidget {
  const _SupportStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final CelebrateFanMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.name,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.note,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            message.amountLabel,
            style: GoogleFonts.quicksand(
              color: CelebrateChampionScreen._pink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipActionCard extends StatelessWidget {
  const _TipActionCard({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.actionColor,
    required this.borderColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final Color actionColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: actionColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              actionLabel,
              style: GoogleFonts.quicksand(
                color: actionColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
