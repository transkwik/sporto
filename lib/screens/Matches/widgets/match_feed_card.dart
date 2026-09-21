import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/match_info.dart';

enum MatchFeedKind { live, upcoming, completed }

class MatchFeedCard extends StatelessWidget {
  const MatchFeedCard({
    super.key,
    required this.match,
    required this.kind,
    this.roundLabel,
    this.timeLabel,
    this.venue,
    this.oversA,
    this.oversB,
    this.winnerName,
    this.prizeLabel,
    this.onTap,
    this.onCta,
  });

  final MatchInfo match;
  final MatchFeedKind kind;
  final String? roundLabel;
  final String? timeLabel;
  final String? venue;
  final String? oversA;
  final String? oversB;
  final String? winnerName;
  final String? prizeLabel;
  final VoidCallback? onTap;
  final VoidCallback? onCta;

  String get _initials {
    final words = match.title.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    final t = match.title.trim();
    return t.isEmpty ? 'M' : t.substring(0, t.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (kind == MatchFeedKind.upcoming) {
      return _UpcomingMatchCard(
        match: match,
        initials: _initials,
        roundLabel: roundLabel ?? 'Match',
        timeLabel: timeLabel ?? '',
        venue: venue ?? '',
        onTap: onTap,
        onCta: onCta,
      );
    }

    if (kind == MatchFeedKind.completed) {
      return _CompletedMatchCard(
        match: match,
        initials: _initials,
        timeLabel: timeLabel ?? '',
        venue: venue ?? '',
        oversA: oversA ?? '',
        oversB: oversB ?? '',
        winnerName: winnerName ?? match.teamB,
        prizeLabel: prizeLabel ?? '',
        onTap: onTap,
      );
    }

    return _LiveMatchCard(
      match: match,
      initials: _initials,
      kind: kind,
      roundLabel: roundLabel ?? match.title,
      timeLabel: timeLabel ?? '',
      venue: venue ?? '',
      onTap: onTap,
      onCta: onCta,
    );
  }
}

class _UpcomingMatchCard extends StatelessWidget {
  const _UpcomingMatchCard({
    required this.match,
    required this.initials,
    required this.roundLabel,
    required this.timeLabel,
    required this.venue,
    this.onTap,
    this.onCta,
  });

  final MatchInfo match;
  final String initials;
  final String roundLabel;
  final String timeLabel;
  final String venue;
  final VoidCallback? onTap;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 360;
    final startsIn = match.status.isNotEmpty && match.status != 'Scheduled'
        ? match.status
        : 'Starts soon';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141820),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A3A32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (timeLabel.isNotEmpty)
                  Text(
                    timeLabel,
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF5AC8FA),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Expanded(
                  child: Center(
                    child: _OutlinePill(
                      label: roundLabel,
                      color: AppColors.mintGreen,
                    ),
                  ),
                ),
                const _OutlinePill(
                  label: 'Upcoming',
                  color: Color(0xFFFF8A4C),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A241C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    initials,
                    style: GoogleFonts.quicksand(
                      color: AppColors.mintGreen,
                      fontSize: 15,
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
                        match.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              match.sport,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: AppColors.amberAccent,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (venue.isNotEmpty) ...[
                            Text(
                              '  •  ',
                              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                            ),
                            const Icon(Icons.location_on_rounded, color: Color(0xFF5AC8FA), size: 13),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                venue,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF5AC8FA),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0x22FFFFFF)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.teamA,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Vs',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    match.teamB,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0x22FFFFFF)),
            const SizedBox(height: 12),
            if (narrow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    startsIn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFFE45AD4),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _ViewDetailsButton(onTap: onCta ?? onTap),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: Text(
                      startsIn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: const Color(0xFFE45AD4),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ViewDetailsButton(onTap: onCta ?? onTap),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CompletedMatchCard extends StatelessWidget {
  const _CompletedMatchCard({
    required this.match,
    required this.initials,
    required this.timeLabel,
    required this.venue,
    required this.oversA,
    required this.oversB,
    required this.winnerName,
    required this.prizeLabel,
    this.onTap,
  });

  final MatchInfo match;
  final String initials;
  final String timeLabel;
  final String venue;
  final String oversA;
  final String oversB;
  final String winnerName;
  final String prizeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141820),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A3A32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    timeLabel.isNotEmpty ? timeLabel : 'Completed',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF5AC8FA),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const _OutlinePill(label: 'Completed', color: Color(0xFF5AC8FA)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A241C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    initials,
                    style: GoogleFonts.quicksand(
                      color: AppColors.mintGreen,
                      fontSize: 15,
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
                        match.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              match.sport,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: AppColors.amberAccent,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (venue.isNotEmpty) ...[
                            Text(
                              '  •  ',
                              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                            ),
                            const Icon(Icons.location_on_rounded, color: Color(0xFF5AC8FA), size: 13),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                venue,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF5AC8FA),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0x22FFFFFF)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _TeamScoreBlock(
                    name: match.teamA,
                    score: match.scoreA,
                    overs: oversA,
                    alignEnd: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: Text(
                    'Vs',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: _TeamScoreBlock(
                    name: match.teamB,
                    score: match.scoreB,
                    overs: oversB,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _WinnerBanner(winnerName: winnerName, prizeLabel: prizeLabel),
          ],
        ),
      ),
    );
  }
}

class _TeamScoreBlock extends StatelessWidget {
  const _TeamScoreBlock({
    required this.name,
    required this.score,
    required this.overs,
    required this.alignEnd,
  });

  final String name;
  final String score;
  final String overs;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final align = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final textAlign = alignEnd ? TextAlign.end : TextAlign.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: score,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (overs.isNotEmpty)
                TextSpan(
                  text: '  •  $overs',
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
        ),
      ],
    );
  }
}

class _WinnerBanner extends StatelessWidget {
  const _WinnerBanner({required this.winnerName, required this.prizeLabel});

  final String winnerName;
  final String prizeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2414), Color(0xFF1A1210), Color(0xFF2A1A10)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: const Color(0x33E3A93D)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE3A93D), width: 1.4),
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFE3A93D), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Winner',
                  style: GoogleFonts.quicksand(
                    color: const Color(0xFFE3A93D),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  winnerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (prizeLabel.isNotEmpty) ...[
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                prizeLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: GoogleFonts.quicksand(
                  color: const Color(0xFFE3A93D),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LiveMatchCard extends StatelessWidget {
  const _LiveMatchCard({
    required this.match,
    required this.initials,
    required this.kind,
    required this.roundLabel,
    required this.timeLabel,
    required this.venue,
    this.onTap,
    this.onCta,
  });

  final MatchInfo match;
  final String initials;
  final MatchFeedKind kind;
  final String roundLabel;
  final String timeLabel;
  final String venue;
  final VoidCallback? onTap;
  final VoidCallback? onCta;

  String get _ctaLabel => kind == MatchFeedKind.completed ? 'View Results' : 'Open Live Match';

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 360;
    final isLive = kind == MatchFeedKind.live;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          gradient: AppColors.liveCardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isLive) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFFFF3B3B), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Live',
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    roundLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: AppColors.mintGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (timeLabel.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    timeLabel,
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF5AC8FA),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2218),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.45)),
                  ),
                  child: Text(
                    initials,
                    style: GoogleFonts.quicksand(
                      color: AppColors.mintGreen,
                      fontSize: 14,
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
                        match.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              match.sport,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: AppColors.amberAccent,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (venue.isNotEmpty) ...[
                            Text(
                              '  •  ',
                              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                            ),
                            const Icon(Icons.location_on_rounded, color: AppColors.amberAccent, size: 13),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                venue,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF5AC8FA),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.teamA,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        match.scoreA,
                        style: GoogleFonts.quicksand(
                          color: AppColors.mintGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Vs',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        match.teamB,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        match.scoreB,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (narrow)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (match.status.isNotEmpty)
                    Text(
                      match.status,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12.5),
                    ),
                  if (match.status.isNotEmpty) const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _FilledCta(label: _ctaLabel, onTap: onCta ?? onTap),
                  ),
                ],
              )
            else
              Row(
                children: [
                  if (match.status.isNotEmpty)
                    Expanded(
                      child: Text(
                        match.status,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12.5),
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(width: 10),
                  _FilledCta(label: _ctaLabel, onTap: onCta ?? onTap),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _OutlinePill extends StatelessWidget {
  const _OutlinePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.7)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.quicksand(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ViewDetailsButton extends StatelessWidget {
  const _ViewDetailsButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E28),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          'View Details',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _FilledCta extends StatelessWidget {
  const _FilledCta({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
