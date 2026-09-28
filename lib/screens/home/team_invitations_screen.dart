import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../core/apiServices/user_api.dart';

class TeamInvitation {
  TeamInvitation({
    required this.id,
    required this.teamName,
    required this.captain,
    required this.sport,
    required this.logoUrl,
    required this.createdAt,
  });

  final int id;
  final String teamName;
  final String captain;
  final String sport;
  final String? logoUrl;
  final String createdAt;

  factory TeamInvitation.fromJson(Map<String, dynamic> json) {
    final team = json['team'] ?? {};
    final invitedBy = json['invited_by_user'] ?? {};
    final sportObj = team['sport'] ?? {};
    
    return TeamInvitation(
      id: json['id'] as int,
      teamName: team['name'] ?? 'Unknown Team',
      captain: invitedBy['name'] ?? 'Captain',
      sport: sportObj['name'] ?? 'Unknown Sport',
      logoUrl: team['logo_url'],
      createdAt: json['created_at'] ?? '',
    );
  }
}

/// Attention hub → Team Invitations: accept or reject pending team invites.
class TeamInvitationsScreen extends StatefulWidget {
  const TeamInvitationsScreen({super.key});

  @override
  State<TeamInvitationsScreen> createState() => _TeamInvitationsScreenState();
}

class _TeamInvitationsScreenState extends State<TeamInvitationsScreen> {
  final List<TeamInvitation> _invites = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _perPage = 10;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _currentSearch = '';

  @override
  void initState() {
    super.initState();
    _fetchInvitations();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMore) {
        _currentPage++;
        _fetchInvitations(isLoadMore: true);
      }
    }
  }

  Future<void> _fetchInvitations({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() => _isLoadingMore = true);
    } else {
      setState(() => _isLoading = true);
    }

    try {
      final res = await UserApis().getInvitations(_currentPage, _perPage, _currentSearch);
      if (res != null && res['success'] == true && res['data'] is List) {
        final List<dynamic> data = res['data'];
        final newInvites = data.map((json) => TeamInvitation.fromJson(json)).toList();
        
        setState(() {
          if (isLoadMore) {
            _invites.addAll(newInvites);
          } else {
            _invites.clear();
            _invites.addAll(newInvites);
          }
          final meta = res['meta'];
          if (meta != null) {
            _hasMore = _currentPage < (meta['last_page'] ?? 1);
          } else {
            _hasMore = newInvites.length == _perPage;
          }
          _isLoading = false;
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _onSearchChanged(String val) {
    _currentSearch = val;
    _currentPage = 1;
    _hasMore = true;
    _fetchInvitations();
  }

  Future<void> _respond(TeamInvitation invite, bool accepted) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.mintGreen)),
    );

    try {
      final res = accepted
          ? await UserApis().acceptInvitation(invite.id)
          : await UserApis().rejectInvitation(invite.id);

      if (mounted) Navigator.pop(context); // close loader

      if (res != null && res['success'] == true) {
        setState(() => _invites.removeWhere((item) => item.id == invite.id));
        if (mounted) {
          MCP.showMessage(
            context,
            res['message'] ?? (accepted ? 'Invitation accepted.' : 'Invitation rejected.'),
            backgroundColor: accepted ? Colors.green.shade600 : Colors.red.shade600,
          );
        }
      } else {
        if (mounted) {
          MCP.showMessage(context, res?['message'] ?? 'Failed to process invitation');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        MCP.showMessage(context, 'An error occurred.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Team Invitations',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search by team or sport...',
                    hintStyle: GoogleFonts.quicksand(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: AppColors.glassFillLighter,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              if (!_isLoading)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    _invites.isEmpty
                        ? 'You have no team invitations'
                        : 'You have ${_invites.length} pending invitation${_invites.length == 1 ? '' : 's'}',
                    style: GoogleFonts.quicksand(
                      color: Colors.white54,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.mintGreen))
                    : _invites.isEmpty
                    ? Center(
                        child: Text(
                          'All caught up.',
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                        itemCount: _invites.length + (_isLoadingMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == _invites.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(color: AppColors.mintGreen),
                              ),
                            );
                          }
                          final invite = _invites[index];
                          return _InviteCard(
                            invite: invite,
                            onAccept: () => _respond(invite, true),
                            onReject: () => _respond(invite, false),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  const _InviteCard({
    required this.invite,
    required this.onAccept,
    required this.onReject,
  });

  final TeamInvitation invite;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 360;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                child: invite.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(invite.logoUrl!, width: 42, height: 42, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.sports_cricket_rounded, color: AppColors.amberAccent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invite.teamName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Invited by: ${invite.captain}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invite.sport,
                      style: GoogleFonts.quicksand(
                        color: AppColors.mintGreen,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, color: Colors.white38, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  invite.createdAt.split('T').first,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Flex(
            direction: narrow ? Axis.vertical : Axis.horizontal,
            children: [
              _ActionButton(label: 'Accept', filled: true, onTap: onAccept, expand: !narrow),
              SizedBox(width: narrow ? 0 : 10, height: narrow ? 10 : 0),
              _ActionButton(label: 'Reject', filled: false, onTap: onReject, expand: !narrow),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
    required this.expand,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF1F8A4A) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: filled ? null : Border.all(color: const Color(0xFFFF6B7A)),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            color: filled ? Colors.white : const Color(0xFFFF6B7A),
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );

    return expand ? Expanded(child: button) : button;
  }
}
