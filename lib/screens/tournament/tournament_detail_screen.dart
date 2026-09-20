import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sporto/screens/team/team_roster_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import 'package:provider/provider.dart';
import '../home/providers/home_provider.dart';
import '../team/select_team_screen.dart';
import 'widgets/award_box.dart';
import 'widgets/format_info_box.dart';
import 'widgets/prize_rank_row.dart';
import 'widgets/tournament_stat_box.dart';

String _formatDate(String? dateStr) {
  if (dateStr == null) return 'TBD';
  try {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  } catch (_) {
    return 'TBD';
  }
}

/// Full tournament detail screen shown when tapping a tournament
class TournamentDetailScreen extends StatefulWidget {
  const TournamentDetailScreen({super.key, required this.tournamentId});

  final int tournamentId;

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  bool _showAllPrizes = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(
        context,
        listen: false,
      ).fetchTournamentDetail(widget.tournamentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: Consumer<HomeProvider>(
            builder: (context, provider, child) {
              if (provider.isFetchingDetail) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        children: [
                          GlassBackButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                );
              }

              final t = provider.tournamentDetail;
              if (t == null) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        children: [
                          GlassBackButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          provider.errorMessage ?? 'Tournament not found',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ],
                );
              }

              final title = t['name'] ?? 'Unnamed Tournament';
              final location = t['location'] is Map
                  ? (t['location']['name'] ?? 'Unknown Location')
                  : (t['location']?.toString() ?? 'Unknown Location');
              final teamsCount = t['maximum_teams']?.toString() ?? 'Open';
              final entryFee = t['registration_fee'] != null
                  ? '₹${t['registration_fee']}'
                  : 'Free';
              final kickoffLabel = _formatDate(
                t['tournament_start_at'],
              ).split(',').first;

              // Best Batsman / Best Bowler from custom fields? Right now we just set them to null as it's not in the JSON schema.
              final String? bestBatsmanPrize = null;
              final String? bestBowlerPrize = null;

              bool isRegistrationClosed = false;
              if (t['registration_end_at'] != null) {
                try {
                  final regEnd = DateTime.parse(t['registration_end_at']);
                  if (regEnd.isBefore(DateTime.now())) {
                    isRegistrationClosed = true;
                  }
                } catch (_) {}
              }

              final rawPrizes = t['prizes'] as List<dynamic>? ?? [];
              final visiblePrizes = _showAllPrizes
                  ? rawPrizes
                  : rawPrizes.take(3).toList();

              final formatRules = [
                'Sport Format: ${t['sport_format']?['name'] ?? 'Standard'}',
                'Tournament Type: ${t['tournament_type']?['name'] ?? 'Standard'}',
              ];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      children: [
                        GlassBackButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white54,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12.5,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                      children: [
                        _HeroCard(t: t),
                        const SizedBox(height: 12),
                        _RegistrationBar(t: t),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: TournamentStatBox(
                                value: teamsCount,
                                label: 'Teams',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TournamentStatBox(
                                value: entryFee,
                                label: 'Entry Fee',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TournamentStatBox(
                                value: kickoffLabel,
                                label: 'Kickoff',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            const Icon(
                              Icons.emoji_events_rounded,
                              color: AppColors.amberAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Tournament Prizes',
                              style: TextStyle(
                                color: AppColors.amberAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (bestBatsmanPrize != null ||
                            bestBowlerPrize != null) ...[
                          Row(
                            children: [
                              if (bestBatsmanPrize != null)
                                Expanded(
                                  child: AwardBox(
                                    label: 'Best Batsman',
                                    value: bestBatsmanPrize,
                                  ),
                                ),
                              if (bestBatsmanPrize != null &&
                                  bestBowlerPrize != null)
                                const SizedBox(width: 10),
                              if (bestBowlerPrize != null)
                                Expanded(
                                  child: AwardBox(
                                    label: 'Best Bowler',
                                    value: bestBowlerPrize,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        for (final p in visiblePrizes)
                          PrizeRankRow(
                            rank: p['id'] ?? 1,
                            label: p['title'] ?? 'Prize',
                            amount: p['amount'] != null
                                ? '₹${p['amount']}'
                                : '₹0',
                            badgeColor: const Color(0xFFE9A825),
                          ),
                        if (rawPrizes.length > 3) ...[
                          const SizedBox(height: 4),
                          Center(
                            child: GestureDetector(
                              onTap: () => setState(
                                () => _showAllPrizes = !_showAllPrizes,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.glassFillLighter,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.glassBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _showAllPrizes
                                          ? 'View Less'
                                          : 'View More',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      _showAllPrizes
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 26),
                        const Text(
                          'Format',
                          style: TextStyle(
                            color: AppColors.mintGreen,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        FormatInfoBox(rules: formatRules),
                      ],
                    ),
                  ),
                  if (!isRegistrationClosed || t['my_registration'] != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: GestureDetector(
                        onTap: () {
                          if (t['my_registration'] != null &&
                              t['team'] != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TeamRosterScreen(
                                  team: t['team'],
                                  tournament: t,
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SelectTeamScreen(tournament: t),
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: AppColors.bannerGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t['my_registration'] != null
                                    ? 'View My Team'
                                    : 'Register',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.t});

  final Map<String, dynamic> t;

  @override
  Widget build(BuildContext context) {
    final stage = t['tournament_type']?['name'] ?? 'Tournament';
    final dateLabel = _formatDate(t['tournament_start_at']);
    final teamA = 'TBD';
    final teamB = 'TBD';
    final matchPrize = t['prize_amount'] != null
        ? '₹${t['prize_amount']}'
        : '₹0';
    final regFee = t['registration_fee'] != null
        ? '₹${t['registration_fee']}'
        : 'Free';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.tournamentHeroGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.roseTag,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  stage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                dateLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Text(
          //         teamA,
          //         style: const TextStyle(
          //           color: Colors.white,
          //           fontSize: 15,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //     ),
          //     const Text(
          //       'VS',
          //       style: TextStyle(
          //         color: Colors.white54,
          //         fontSize: 11,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     Expanded(
          //       child: Text(
          //         teamB,
          //         textAlign: TextAlign.right,
          //         style: const TextStyle(
          //           color: Colors.white,
          //           fontSize: 15,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Text(
            t['name'] ?? 'Unnamed Tournament',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: AppColors.glassBorder),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Match Prize',
                      style: TextStyle(color: Colors.white54, fontSize: 11.5),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.emoji_events_rounded,
                          color: AppColors.amberAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          matchPrize,
                          style: const TextStyle(
                            color: AppColors.amberAccent,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 38, color: AppColors.glassBorder),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Reg. Fee',
                      style: TextStyle(color: Colors.white54, fontSize: 11.5),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      regFee,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RegistrationBar extends StatelessWidget {
  const _RegistrationBar({required this.t});

  final Map<String, dynamic> t;

  @override
  Widget build(BuildContext context) {
    final maxPlayers = t['sport']?['max_players']?.toString() ?? 'Open';
    final regEndsLabel = _formatDate(t['registration_end_at']);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.mintGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Max Players: $maxPlayers',
              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Reg. Ends: ',
                    style: TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                  TextSpan(
                    text: regEndsLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
