import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/playground_team_info.dart';
import 'join_team_payment_screen.dart';
import 'widgets/captain_card.dart';
import 'widgets/entry_fee_card.dart';
import 'widgets/squad_list_card.dart';
import 'widgets/team_detail_hero_card.dart';
import 'widgets/team_needs_banner.dart';
import 'widgets/team_stats_pill.dart';
import 'widgets/warning_notice_banner.dart';

/// Full profile of a team surfaced from the Playground "Teams Looking for
/// Players" list: roster stats, captain form, current squad, the
/// requester's entry fee share, and a "Join Team" call to action.
class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({super.key, required this.team});

  final PlaygroundTeamInfo team;

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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 14),
                    const Text(
                      'Team Details',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  children: [
                    TeamDetailHeroCard(team: team),
                    const SizedBox(height: 18),
                    TeamStatsPill(wins: team.wins, playersCount: team.playersCount, maxPlayers: team.maxPlayers),
                    const SizedBox(height: 14),
                    TeamNeedsBanner(position: team.neededPosition),
                    const SizedBox(height: 26),
                    const Text(
                      'Captain',
                      style: TextStyle(color: Colors.white60, fontSize: 13.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    CaptainCard(
                      name: team.captainShortName,
                      winRate: team.captainWinRate,
                      tournaments: team.captainTournaments,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Current Squad',
                      style: TextStyle(color: Colors.white60, fontSize: 13.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    SquadListCard(squad: team.squad),
                    const SizedBox(height: 24),
                    const Text(
                      'Your Individual Entry Fee',
                      style: TextStyle(color: Colors.white60, fontSize: 13.5, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    EntryFeeCard(playerShare: team.playerShareFee, total: team.totalFee),
                    const SizedBox(height: 18),
                    const WarningNoticeBanner(
                      message: "The captain must approve your request before you're confirmed on the roster.",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => JoinTeamPaymentScreen(team: team)),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.bannerGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A1E).withValues(alpha: 0.45),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Join Team',
                          style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ),
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
