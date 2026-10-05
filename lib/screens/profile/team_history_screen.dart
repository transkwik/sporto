import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sporto/core/globalefunction/global_functions.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/apiServices/user_api.dart';
import 'team_tournament_matches_screen.dart';
import '../team/widgets/add_player_sheet.dart';

class _AddPlayerSheetProxy extends StatefulWidget {
  final int teamId;
  final VoidCallback onAdded;

  const _AddPlayerSheetProxy({required this.teamId, required this.onAdded});

  @override
  State<_AddPlayerSheetProxy> createState() => _AddPlayerSheetProxyState();
}

class _AddPlayerSheetProxyState extends State<_AddPlayerSheetProxy> {
  void _sendInvitation(String name, String phone) async {
    final res = await UserApis().inviteTeamPlayer(widget.teamId, {
      'player_name': name,
      'mobile_number': phone,
    });

    if (!mounted) return;

    if (res != null && res['success'] == true) {
      MCP.showMessage(
        context,
        "Player added successfully!",
        backgroundColor: Colors.green.shade600,
      );
      Navigator.of(context).pop();
      widget.onAdded();
    } else {
      MCP.showMessage(context, res?['message'] ?? "Failed to add player");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddPlayerSheet(playerNumber: 0, onSend: _sendInvitation);
  }
}

/// Profile → My Teams → team card: recap of titles, prize money, and past cups.
class TeamHistoryScreen extends StatefulWidget {
  const TeamHistoryScreen({super.key, required this.team});

  final Map<String, dynamic> team;

  @override
  State<TeamHistoryScreen> createState() => _TeamHistoryScreenState();
}

class _TeamHistoryScreenState extends State<TeamHistoryScreen> {
  late Map<String, dynamic> _currentTeam;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentTeam = widget.team;
    _fetchTeamDetails();
  }

  Future<void> _fetchTeamDetails() async {
    try {
      final response = await UserApis().getMyTeamDetails(
        int.parse(widget.team['id']?.toString() ?? '0'),
      );
      if (response != null && response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>;

        final Map<String, dynamic> updatedTeam = Map<String, dynamic>.from(
          _currentTeam,
        );
        updatedTeam.addAll(data);

        setState(() {
          _currentTeam = updatedTeam;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _openTournament(BuildContext context, Map<String, dynamic> item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TeamTournamentMatchesScreen(tournament: item),
      ),
    );
  }

  void _handleAddPlayer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _AddPlayerSheetProxy(
            teamId: int.tryParse(widget.team['id']?.toString() ?? '0') ?? 0,
            onAdded: _fetchTeamDetails,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prizeEarned = _currentTeam['prizeEarned'] ?? 0;
    final prize = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(prizeEarned);

    final titles = _currentTeam['stats']?['titles'] ?? 0;
    final wins = _currentTeam['stats']?['wins'] ?? 0;
    final tournamentsPlayed = _currentTeam['stats']?['tournaments_played'] ?? 0;
    final matchesCount = _currentTeam['matchesCount'] ?? 0;
    final history = _currentTeam['history'] as List<dynamic>? ?? [];

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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Text(
                      'Team History',
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mintGreen,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchTeamDetails,
                        color: AppColors.mintGreen,
                        backgroundColor: AppColors.secondary,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                          children: [
                            _TeamHeroCard(
                              team: _currentTeam,
                              onCompleteTeamTap: _handleAddPlayer,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatTile(
                                    value: '$titles',
                                    label: 'Titles',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _StatTile(
                                    value: '$wins',
                                    label: 'Wins',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _StatTile(
                                    value: '$tournamentsPlayed',
                                    label: 'Tournaments',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _StatTile(
                                    value: '$matchesCount',
                                    label: 'Matches',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _PrizeBar(amount: prize),
                            const SizedBox(height: 22),
                                  Text(
                                    'Team Members',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if ((_currentTeam['roster'] as List<dynamic>?)?.isEmpty ?? true)
                                    Text(
                                      'No players found.',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white38,
                                        fontSize: 13.5,
                                      ),
                                    )
                                  else
                                    for (final player in _currentTeam['roster'] as List<dynamic>) ...[
                                      _PlayerTile(player: player as Map<String, dynamic>),
                                      const SizedBox(height: 8),
                                    ],
                                  const SizedBox(height: 22),
                                  Row(
                                    children: [
                                      Text(
                                        'Tournament History',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: history.isEmpty
                                      ? null
                                      : () => _openTournament(
                                          context,
                                          history.first,
                                        ),
                                  child: Text(
                                    'View all  >',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white38,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (history.isEmpty)
                              Text(
                                'No tournaments yet.',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white38,
                                  fontSize: 13.5,
                                ),
                              )
                            else
                              for (final item in history) ...[
                                _HistoryCard(
                                  item: item,
                                  onTap: () => _openTournament(context, item),
                                ),
                                const SizedBox(height: 12),
                              ],
                          ],
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

class _TeamHeroCard extends StatelessWidget {
  const _TeamHeroCard({required this.team, this.onCompleteTeamTap});

  final Map<String, dynamic> team;
  final VoidCallback? onCompleteTeamTap;

  @override
  Widget build(BuildContext context) {
    final teamName = team['team_name']?.toString() ?? 'Unknown';
    final avatarInitials = teamName.isNotEmpty
        ? teamName.substring(0, 1).toUpperCase()
        : 'T';
    final city = team['city']?.toString() ?? '';
    final playersCount = team['players']?['current'] ?? 0;
    final maxPlayers = team['players']?['maximum'];
    final captainName =
        team['captain']?['profile']?['full_name']?.toString() ?? 'No Captain';

    final completion = team['completion'];
    final isActionRequired = completion?['action_required'] == true;
    final action = completion?['action'];
    final actionLabel = completion?['action_label'] ?? 'Complete Team';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5A2B), Color(0xFF2A1810)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: const Color(0xFFE3A93D), width: 1.4),
              image: team['team_logo_url'] != null
                  ? DecorationImage(
                      image: NetworkImage(team['team_logo_url']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: team['team_logo_url'] == null
                ? Text(
                    avatarInitials,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (city.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white38,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        city,
                        style: GoogleFonts.quicksand(
                          color: Colors.white54,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  maxPlayers != null
                      ? '$playersCount/$maxPlayers Players  •  Captain: $captainName'
                      : '$playersCount Players  •  Captain: $captainName',
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                if (isActionRequired &&
                    action == 'COMPLETE_TEAM' &&
                    onCompleteTeamTap != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onCompleteTeamTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mintGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_circle_outline,
                            color: Colors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            actionLabel,
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2420), Color(0xFF1A1E28)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _PrizeBar extends StatelessWidget {
  const _PrizeBar({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF143322), Color(0xFF1F6A3A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total Prize Money Earned',
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.quicksand(
              color: AppColors.mintGreen,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, this.onTap});

  final Map<String, dynamic> item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = item['title']?.toString() ?? 'Tournament';
    final dateRange = item['dateRange']?.toString() ?? '';
    final resultLabel = item['resultLabel']?.toString() ?? '';
    final location = item['location']?.toString() ?? '';
    final championTeam = item['championTeam']?.toString() ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF141820),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: const Icon(
                    Icons.sports_cricket_rounded,
                    color: Colors.white70,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white38,
                            size: 13,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            location,
                            style: GoogleFonts.quicksand(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  dateRange,
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3A2418), Color(0xFF1A1E28)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFFE3A93D),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    resultLabel,
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFFFF8A1E),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    championTeam,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerTile extends StatelessWidget {
  const _PlayerTile({required this.player});

  final Map<String, dynamic> player;

  @override
  Widget build(BuildContext context) {
    // The player object has 'user' which contains 'profile' or it might have a direct 'player_name' / 'name'
    final userProfile = player['user']?['profile'];
    final name = userProfile?['full_name']?.toString() ?? player['name']?.toString() ?? player['player_name']?.toString() ?? 'Unknown Player';
    
    // Check if the player is a captain
    final isCaptain = player['is_captain'] == 1 || player['role'] == 1;
    final avatarInitials = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'P';
    
    // Avatar image
    final profilePictureUrl = userProfile?['profile_picture_url']?.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2A2420),
              image: profilePictureUrl != null && profilePictureUrl.isNotEmpty
                  ? DecorationImage(image: NetworkImage(profilePictureUrl), fit: BoxFit.cover)
                  : null,
            ),
            alignment: Alignment.center,
            child: profilePictureUrl == null || profilePictureUrl.isEmpty
                ? Text(
                    avatarInitials,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isCaptain) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Captain',
                    style: GoogleFonts.quicksand(
                      color: AppColors.mintGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
