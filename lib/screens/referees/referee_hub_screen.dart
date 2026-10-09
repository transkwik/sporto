import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_browse_screen.dart';
import 'referee_detail_screen.dart';
import 'referees_screen.dart';
import 'widgets/referee_assignment_card.dart';

/// Bookings hub: upcoming / ongoing assignments and last assigned officials.
class RefereeHubScreen extends StatefulWidget {
  const RefereeHubScreen({super.key});

  @override
  State<RefereeHubScreen> createState() => _RefereeHubScreenState();
}

class _RefereeHubScreenState extends State<RefereeHubScreen> {
  int _tab = 0;

  void _openBrowse({required String title, required List<RefereeOfficial> officials}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RefereeBrowseScreen(title: title, officials: officials),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = dummyRefereeAssignments
        .where((a) => a.status == RefereeBookingStatus.upcoming)
        .toList();
    final ongoing = dummyRefereeAssignments
        .where((a) => a.status == RefereeBookingStatus.ongoing)
        .toList();
    final visible = _tab == 0 ? upcoming : ongoing;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: GlassBackButton(onTap: () => Navigator.of(context).pop()),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book A Referee',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Certified officials for your next match.',
                          style: GoogleFonts.quicksand(
                            color: Colors.white54,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0C43D),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tournament',
                            style: GoogleFonts.quicksand(
                              color: Colors.black54,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Book A Referee',
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RefereesScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          'Book Now',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF141820),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF3A4A28).withValues(alpha: 0.7)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _StatusChip(
                          label: 'Upcoming (${upcoming.length})',
                          selected: _tab == 0,
                          selectedColor: AppColors.mintGreen,
                          onTap: () => setState(() => _tab = 0),
                        ),
                        const SizedBox(width: 10),
                        _StatusChip(
                          label: 'Ongoing (${ongoing.length})',
                          selected: _tab == 1,
                          selectedColor: const Color(0xFF2A3038),
                          onTap: () => setState(() => _tab = 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (visible.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          _tab == 0 ? 'No upcoming bookings.' : 'No ongoing bookings.',
                          style: GoogleFonts.quicksand(color: Colors.white54),
                        ),
                      )
                    else
                      ...visible.map(
                        (assignment) => RefereeAssignmentCard(assignment: assignment),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Text(
                    'Last Assigned',
                    style: GoogleFonts.quicksand(
                      color: Colors.white54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _openBrowse(
                      title: 'Last Assigned',
                      officials: dummyLastAssignedReferees,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'View all',
                          style: GoogleFonts.quicksand(
                            color: AppColors.infoBlue,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.infoBlue, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...dummyLastAssignedReferees.map(
                (official) => RefereeOfficialCard(
                  official: official,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RefereeDetailScreen(official: official),
                      ),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isGreen = selected && selectedColor == AppColors.mintGreen;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? (isGreen ? AppColors.mintGreen : const Color(0xFF2A3038))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: selected ? null : Border.all(color: AppColors.glassBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            color: isGreen ? Colors.black : Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
