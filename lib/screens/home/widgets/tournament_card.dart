import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import 'package:intl/intl.dart';

/// Glass row card for a single entry in the "Browse Tournaments" list.
class TournamentCard extends StatelessWidget {
  const TournamentCard({super.key, required this.tournament, this.onTap});

  final Map<String, dynamic> tournament;
  final VoidCallback? onTap;

  String _locationLabel() {
    final loc = tournament['location'];
    if (loc is Map) return loc['name']?.toString() ?? 'Unknown Location';
    if (loc != null && loc.toString().isNotEmpty) return loc.toString();
    return 'Unknown Location';
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '';
    if (amount is num && amount >= 1000 && amount % 1000 == 0 && amount >= 100000) {
      return '₹${(amount / 1000).toStringAsFixed(0)}k';
    }
    if (amount is num) {
      final formatted = NumberFormat('#,##,###').format(amount);
      return '₹$formatted';
    }
    final text = amount.toString();
    if (text.startsWith('₹')) return text;
    return '₹$text';
  }

  @override
  Widget build(BuildContext context) {
    final title = (tournament['title'] ?? tournament['name'] ?? 'Unnamed Tournament').toString();
    final sportName = tournament['sport']?['name']?.toString() ?? 'Sport';
    final location = _locationLabel();
    final distance = tournament['distance_km']?.toString();
    final startString = tournament['tournament_start_at'] ?? tournament['start_date'];
    final regEndString = tournament['registration_end_at'] ?? tournament['end_date'];

    String dateLabel = 'TBA';
    try {
      if (startString != null) {
        final parsed = DateTime.parse(startString.toString());
        dateLabel = DateFormat('dd MMMM yyyy').format(parsed);
      }
    } catch (_) {}

    String footerLabel = 'Registration Ends : TBA';
    try {
      if (regEndString != null) {
        final parsed = DateTime.parse(regEndString.toString());
        footerLabel = 'Registration Ends : ${DateFormat('dd MMMM yyyy').format(parsed)}';
      }
    } catch (_) {}

    final prizeAmount = tournament['prize_amount'] ?? tournament['prize'];
    final prize = prizeAmount == null || prizeAmount == 0 ? 'No Prize Pool' : _formatAmount(prizeAmount);

    final maxTeams = int.tryParse(tournament['maximum_teams']?.toString() ?? '') ?? 0;
    final regTeams = int.tryParse(tournament['registered_teams']?.toString() ?? '') ?? 0;
    final progress = maxTeams > 0 ? (regTeams / maxTeams).clamp(0.0, 1.0) : 0.0;
    final isFootball = sportName.toLowerCase() == 'football';

    String initials = '?';
    final words = title.trim().split(RegExp(r'\s+'));
    if (words.length >= 2 && words[0].isNotEmpty && words[1].isNotEmpty) {
      initials = '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (title.isNotEmpty) {
      initials = title.substring(0, title.length >= 2 ? 2 : 1).toUpperCase();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141820),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isFootball) ...[
              Text(
                '$sportName  •  $dateLabel',
                style: GoogleFonts.quicksand(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF1A241C),
                    border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.45)),
                  ),
                  child: Text(
                    initials,
                    style: GoogleFonts.quicksand(
                      color: AppColors.mintGreen,
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
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isFootball)
                        Text(
                          '$sportName  •  $maxTeams Teams',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                        )
                      else
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: Color(0xFF5AC8FA), size: 13),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF5AC8FA),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (distance != null && distance.isNotEmpty) ...[
                              Text(
                                '  •  ',
                                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
                              ),
                              const Icon(Icons.near_me_rounded, color: Color(0xFF5AC8FA), size: 12),
                              const SizedBox(width: 2),
                              Text(
                                distance,
                                style: GoogleFonts.quicksand(
                                  color: const Color(0xFF5AC8FA),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFFE3A93D), size: 22),
              ],
            ),
            const SizedBox(height: 8),
            if (isFootball)
              Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 15),
                  const SizedBox(width: 4),
                  Text(
                    prize,
                    style: GoogleFonts.quicksand(
                      color: AppColors.amberAccent,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '  •  Start On: $dateLabel',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                  ),
                ],
              )
            else
              Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 15),
                  const SizedBox(width: 4),
                  Text(
                    prize,
                    style: GoogleFonts.quicksand(
                      color: AppColors.amberAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: const Color(0xFF2A3038),
                      color: const Color(0xFFE3A93D),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$regTeams/$maxTeams',
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$maxTeams Teams',
                  style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5),
                ),
                const Spacer(),
                Text(
                  footerLabel,
                  style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
