import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/referee_info.dart';

/// Purple "Sport + Venue" header card used across the referee booking flow.
/// Reads the sport and the user-picked location from [draft].
class RefereeVenueCard extends StatelessWidget {
  const RefereeVenueCard({super.key, required this.draft, this.footer});

  final RefereeBookingDraft draft;

  /// Optional line shown under the venue (e.g. "12 Oct 2026 • 5:00 PM").
  final String? footer;

  static const _mint = Color(0xFF3DDC97);

  @override
  Widget build(BuildContext context) {
    final subtitle = draft.venueSubtitle;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1638), Color(0xFF1A1228)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_cricket_rounded, color: _mint, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  draft.sport,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: _mint,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.location_on_outlined, color: _mint, size: 16),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.venueTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white54,
                          fontSize: 12.5,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (footer != null && footer!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Center(
              child: Text(
                footer!,
                style: GoogleFonts.quicksand(
                  color: Colors.white54,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

