import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/celebrate_info.dart';
import 'celebrate_tip_screen.dart';
import 'widgets/celebrate_team_hero.dart';

/// Tip a Player → pick which champion to tip.
class CelebratePickPlayerScreen extends StatelessWidget {
  const CelebratePickPlayerScreen({super.key, required this.campaign});

  final CelebrateCampaign campaign;

  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);

  void _tipPlayer(BuildContext context, CelebrateChampionPlayer player) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CelebrateTipScreen(
          campaign: campaign,
          kind: CelebrateTipKind.player,
          player: player,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = campaign.players.isEmpty ? dummyCelebratePlayers : campaign.players;

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
                      child: Text(
                        'Celebrate The Champion',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    CelebrateTeamHero(campaign: campaign),
                    const SizedBox(height: 18),
                    Text(
                      "Choose a champion you'd like to celebrate.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: _pink,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final player in players) ...[
                      GestureDetector(
                        onTap: () => _tipPlayer(context, player),
                        child: _PlayerCard(
                          player: player,
                          onTip: () => _tipPlayer(context, player),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
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

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({required this.player, required this.onTip});

  final CelebrateChampionPlayer player;
  final VoidCallback onTip;

  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF2A2230),
                child: Text(
                  player.initials,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${player.role}  •  ${player.mvpAwards} MVP Awards',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (player.awardLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B3A2A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _gold.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events_rounded, color: _gold, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        player.awardLabel!,
                        style: GoogleFonts.quicksand(
                          color: _gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
              const Spacer(),
              GestureDetector(
                onTap: onTip,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A1848),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _pink.withValues(alpha: 0.7)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.celebration_rounded, color: Colors.white, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        'Tip Player',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
