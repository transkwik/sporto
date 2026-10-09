import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/referee_info.dart';

class RefereeAssignmentCard extends StatelessWidget {
  const RefereeAssignmentCard({super.key, required this.assignment, this.onTap});

  final RefereeAssignment assignment;
  final VoidCallback? onTap;

  bool get _upcoming => assignment.status == RefereeBookingStatus.upcoming;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(name: assignment.name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          assignment.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: _upcoming ? const Color(0xFFFF8A4C) : AppColors.infoBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _upcoming ? 'Upcoming' : 'Ongoing',
                        style: GoogleFonts.quicksand(
                          color: _upcoming ? const Color(0xFFFF8A4C) : AppColors.infoBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${assignment.sport}  •  ${assignment.venue}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${assignment.durationLabel}  •  ${assignment.dateTimeLabel}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        assignment.feeLabel,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
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
    );
  }
}

class RefereeOfficialCard extends StatelessWidget {
  const RefereeOfficialCard({super.key, required this.official, this.onTap});

  final RefereeOfficial official;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF141820),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            _Avatar(name: official.name, photoUrl: official.photoUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    official.name,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${official.sport}  •  ${official.experienceYears} yrs  •  ${official.level}',
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFE3A93D), size: 14),
                      const SizedBox(width: 3),
                      Text(
                        '${official.rating}  •  ${official.matches} matches',
                        style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Color(0xFFE35A4A), size: 13),
                      const SizedBox(width: 3),
                      Text(
                        '${official.distanceKm} km away',
                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: official.available ? AppColors.mintGreen : Colors.white38,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      official.available ? 'Available' : 'Busy',
                      style: GoogleFonts.quicksand(
                        color: official.available ? AppColors.mintGreen : Colors.white38,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  official.feePerMatchLabel,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'per match',
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.photoUrl});

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: photoUrl != null
          ? Image.network(
              photoUrl!,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _initials(initials),
            )
          : _initials(initials),
    );
  }

  Widget _initials(String initials) {
    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      color: const Color(0xFF2A241C),
      child: Text(
        initials,
        style: GoogleFonts.quicksand(
          color: AppColors.amberAccent,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
