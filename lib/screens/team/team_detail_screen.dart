import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../home/providers/home_provider.dart';
import 'join_team_payment_screen.dart';
import 'invite_player_screen.dart';
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

  final Map<String, dynamic> team;

  @override
  Widget build(BuildContext context) {
    final maxPlayers = team['total_players'] ?? 11;
    final playersCount = team['members']?['current_count'] ?? 0;
    final captainName = team['captain']?['profile']?['full_name'] ?? team['captain']?['name'] ?? 'Unknown Captain';

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
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
                    TeamStatsPill(
                      wins: 0,
                      playersCount: playersCount,
                      maxPlayers: maxPlayers,
                    ),
                    const SizedBox(height: 14),
                    TeamNeedsBanner(
                      position: 'Any',
                      onInvite: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => InvitePlayerScreen(team: team),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Captain',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CaptainCard(
                      name: captainName,
                      winRate: 'N/A',
                      tournaments: 0,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Current Squad',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SquadListCard(squad: []),
                    const SizedBox(height: 24),
                    const Text(
                      'Your Individual Entry Fee',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const EntryFeeCard(playerShare: '₹0', total: '₹0'),
                    const SizedBox(height: 18),
                    const WarningNoticeBanner(
                      message:
                          "The captain must approve your request before you're confirmed on the roster.",
                    ),
                  ],
                ),
              ),
              Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  final bool apiHasRequested = team['join_request']?['request_sent'] == true;
                  final hasRequested = apiHasRequested || homeProvider.hasRequestedToJoin(
                    team['id'] ?? -1,
                  );

                  if (hasRequested) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.glassFillLighter,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: const Text(
                          'Request Sent',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => JoinTeamPaymentScreen(team: team),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: AppColors.bannerGradient,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFF7A1E,
                              ).withValues(alpha: 0.45),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
