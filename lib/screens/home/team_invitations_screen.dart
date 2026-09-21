import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../core/widgets/glass_back_button.dart';

enum TeamInviteStatus { live, registered }

class TeamInvitation {
  const TeamInvitation({
    required this.id,
    required this.teamName,
    required this.captain,
    required this.sport,
    required this.status,
    required this.eventLabel,
    required this.sideLabel,
    required this.timeRemaining,
  });

  final String id;
  final String teamName;
  final String captain;
  final String sport;
  final TeamInviteStatus status;
  final String eventLabel;
  final String sideLabel;
  final String timeRemaining;
}

const _dummyInvites = [
  TeamInvitation(
    id: '1',
    teamName: 'SPOTO Warriors',
    captain: 'Rahul Kumar',
    sport: 'Cricket',
    status: TeamInviteStatus.live,
    eventLabel: 'Hyderabad Super League',
    sideLabel: 'Match in progress',
    timeRemaining: '13:38',
  ),
  TeamInvitation(
    id: '2',
    teamName: 'Hyderabad Strikers',
    captain: 'Arjun Reddy',
    sport: 'Cricket',
    status: TeamInviteStatus.registered,
    eventLabel: 'Telangana City Qualifiers',
    sideLabel: 'Starts 24 Sep',
    timeRemaining: '11:14',
  ),
  TeamInvitation(
    id: '3',
    teamName: 'City Challengers',
    captain: 'Vijay Kumar',
    sport: 'Cricket',
    status: TeamInviteStatus.registered,
    eventLabel: 'City Cup 2026',
    sideLabel: 'Starts 28 Sep',
    timeRemaining: '09:42',
  ),
];

/// Attention hub → Team Invitations: accept or reject pending team invites.
class TeamInvitationsScreen extends StatefulWidget {
  const TeamInvitationsScreen({super.key});

  @override
  State<TeamInvitationsScreen> createState() => _TeamInvitationsScreenState();
}

class _TeamInvitationsScreenState extends State<TeamInvitationsScreen> {
  late List<TeamInvitation> _invites = List.of(_dummyInvites);

  void _respond(TeamInvitation invite, bool accepted) {
    setState(() => _invites.removeWhere((item) => item.id == invite.id));
    MCP.showMessage(
      context,
      accepted
          ? 'You joined ${invite.teamName}.'
          : 'Invitation from ${invite.teamName} declined.',
    );
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                  _invites.isEmpty
                      ? 'You have no team invitations'
                      : 'You have ${_invites.length} Team Invitation${_invites.length == 1 ? '' : 's'}',
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: _invites.isEmpty
                    ? Center(
                        child: Text(
                          'All caught up.',
                          style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 14),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                        itemCount: _invites.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
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
    final isLive = invite.status == TeamInviteStatus.live;
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
                child: const Icon(Icons.sports_cricket_rounded, color: AppColors.amberAccent, size: 22),
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
                      'Captain: ${invite.captain}',
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLive
                        ? const Color(0xFFFF4D30).withValues(alpha: 0.16)
                        : AppColors.mintGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      if (isLive)
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF4D30),
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.emoji_events_rounded, color: AppColors.mintGreen, size: 13),
                        ),
                      Expanded(
                        child: Text(
                          isLive ? 'LIVE  •  ${invite.eventLabel}' : 'Registered  •  ${invite.eventLabel}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            color: isLive ? const Color(0xFFFF8A80) : AppColors.mintGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 2,
                child: Text(
                  invite.sideLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white38, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Time remaining',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                invite.timeRemaining,
                style: GoogleFonts.quicksand(
                  color: AppColors.mintGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
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
