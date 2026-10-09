import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_detail_screen.dart';
import 'widgets/referee_assignment_card.dart';

/// Register Individually → Choose Referee (dummy).
class RefereeChooseListScreen extends StatefulWidget {
  const RefereeChooseListScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  @override
  State<RefereeChooseListScreen> createState() => _RefereeChooseListScreenState();
}

class _RefereeChooseListScreenState extends State<RefereeChooseListScreen> {
  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _sorts = ['Best Match', 'Top Rated', 'Closest', 'Lowest Price', 'More'];

  int _sort = 0;

  List<RefereeOfficial> get _officials {
    final list = List<RefereeOfficial>.from(dummyLastAssignedReferees);
    if (_sort == 1) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sort == 2) {
      list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else if (_sort == 3) {
      list.sort((a, b) => a.hourlyFeeLabel.compareTo(b.hourlyFeeLabel));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A1228), Color(0xFF12161D)],
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
                              const Text('🏏', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                widget.draft.sport,
                                style: GoogleFonts.quicksand(
                                  color: _mint,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: _mint, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'KPHB Indoor Stadium',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Kompally, Hyderabad',
                                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              '${widget.draft.dateLabel}  •  ${widget.draft.timeLabel}',
                              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                            ),
                          ),
                        ],
                      ),
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
                                style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                              ),
                            );
                          }
                          final i = index - 1;
                          final selected = _sort == i;
                          return GestureDetector(
                            onTap: () => setState(() => _sort = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected ? _mint : const Color(0xFF1A1F28),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                _sorts[i],
                                style: GoogleFonts.quicksand(
                                  color: selected ? Colors.black : Colors.white70,
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
                    for (final official in _officials)
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
