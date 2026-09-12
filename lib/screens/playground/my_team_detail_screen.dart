import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/apiServices/user_api.dart';

class MyTeamDetailScreen extends StatefulWidget {
  final int teamId;

  const MyTeamDetailScreen({super.key, required this.teamId});

  @override
  State<MyTeamDetailScreen> createState() => _MyTeamDetailScreenState();
}

class _MyTeamDetailScreenState extends State<MyTeamDetailScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _teamDetails;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await UserApis().getMyTeamDetails(widget.teamId);
      if (response != null && response['success'] == true) {
        setState(() {
          _teamDetails = response['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response?['message'] ?? 'Failed to load team details.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
                    : _errorMessage != null
                        ? Center(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                            ),
                          )
                        : _teamDetails == null
                            ? const Center(
                                child: Text(
                                  'Team details not found.',
                                  style: TextStyle(color: Colors.white54, fontSize: 14),
                                ),
                              )
                            : ListView(
                                padding: const EdgeInsets.all(20),
                                children: [
                                  _buildHeaderCard(),
                                  const SizedBox(height: 20),
                                  _buildCaptainCard(),
                                  const SizedBox(height: 20),
                                  _buildSportRulesCard(),
                                  const SizedBox(height: 20),
                                  _buildPlayersList(),
                                ],
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final teamName = _teamDetails?['team_name'] ?? 'Unknown Team';
    final sportName = _teamDetails?['sport']?['name'] ?? 'Unknown Sport';
    final city = _teamDetails?['city'] ?? 'Unknown City';
    final totalPlayers = _teamDetails?['total_players']?.toString() ?? '0';
    final currentCount = _teamDetails?['members']?['current_count']?.toString() ?? '0';
    final code = _teamDetails?['code'] ?? 'N/A';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF333947)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                teamName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$currentCount/$totalPlayers Players',
                style: const TextStyle(
                  color: AppColors.mintGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sportName,
            style: const TextStyle(
              color: AppColors.amberAccent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              Text(
                city,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.tag, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              Text(
                code,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaptainCard() {
    final captain = _teamDetails?['captain'];
    if (captain == null) return const SizedBox.shrink();

    final profile = captain['profile'];
    final name = captain['name'] ?? profile?['full_name'] ?? 'Unknown';
    final mobile = captain['mobile_number'] ?? 'No Mobile';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF333947)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Captain Details',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.glassBorder,
                child: Icon(Icons.person, color: Colors.white54),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mobile,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSportRulesCard() {
    final rules = _teamDetails?['sport_rules'] as List<dynamic>?;
    if (rules == null || rules.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF333947)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sport Rules',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...rules.map((rule) {
            final name = rule['name'] ?? 'Rule';
            final value = rule['value']?.toString() ?? 'N/A';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlayersList() {
    final players = _teamDetails?['players'] as List<dynamic>?;
    if (players == null || players.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2430),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF333947)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Players List',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...players.map((player) {
            final name = player['player_name'] ?? 'Unknown Player';
            final isCaptain = player['is_captain'] == true;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.white54, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  if (isCaptain) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.amberAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.amberAccent.withValues(alpha: 0.3)),
                      ),
                      child: const Text(
                        'C',
                        style: TextStyle(color: AppColors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
