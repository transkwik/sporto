import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_detail_screen.dart';
import 'widgets/referee_assignment_card.dart';
import 'widgets/referee_venue_card.dart';

/// Browse flow: Schedule → Choose Referee → Referee Profile.
class RefereeChooseListScreen extends StatefulWidget {
  const RefereeChooseListScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  @override
  State<RefereeChooseListScreen> createState() =>
      _RefereeChooseListScreenState();
}

class _RefereeChooseListScreenState extends State<RefereeChooseListScreen> {
  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _sorts = ['Best Match', 'Top Rated', 'Closest', 'Lowest Price'];

  int _sort = 0;

  List<RefereeOfficial> get _officials {
    // Show referees for the chosen sport; fall back to everyone if none match.
    final sport = widget.draft.sport.toLowerCase();
    var list = dummyAvailableReferees
        .where((o) => o.sport.toLowerCase() == sport)
        .toList();
    if (list.isEmpty) list = List<RefereeOfficial>.from(dummyAvailableReferees);

    int price(RefereeOfficial o) => RefereeBookingDraft.parseRupees(
      widget.draft.hourly ? o.hourlyFeeLabel : o.dailyFeeLabel,
    );

    switch (_sort) {
      case 1:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case 2:
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      case 3:
        list.sort((a, b) => price(a).compareTo(price(b)));
      default:
        // Best match: available first, then rating, then distance.
        list.sort((a, b) {
          if (a.available != b.available) return a.available ? -1 : 1;
          final r = b.rating.compareTo(a.rating);
          return r != 0 ? r : a.distanceKm.compareTo(b.distanceKm);
        });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final officials = _officials;
    return Scaffold(
      backgroundColor: _pageBg,
      body: ColoredBox(
        color: _pageBg,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Text(
                      'Your Sponsorship',
                      style: GoogleFonts.quicksand(
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    RefereeVenueCard(
                      draft: widget.draft,
                      footer:
                          '${widget.draft.dateLabel}  •  ${widget.draft.timeRangeLabel}  •  ${widget.draft.durationLabel}',
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Choose Referee',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: const Color(0xFF4EB4E8),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sorts.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Center(
                              child: Text(
                                'Sort By',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white38,
                                  fontSize: 12.5,
                                ),
                              ),
                            );
                          }
                          final i = index - 1;
                          final selected = _sort == i;
                          return GestureDetector(
                            onTap: () => setState(() => _sort = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected
                                    ? _mint
                                    : const Color(0xFF1A1F28),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                _sorts[i],
                                style: GoogleFonts.quicksand(
                                  color: selected
                                      ? Colors.black
                                      : Colors.white70,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    for (final official in officials)
                      RefereeOfficialCard(
                        official: official,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RefereeDetailScreen(
                                official: official,
                                draft: widget.draft,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
