import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_choose_list_screen.dart';

/// Quick Book → Your Sponsorship schedule (dummy).
class RefereeScheduleScreen extends StatefulWidget {
  const RefereeScheduleScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  @override
  State<RefereeScheduleScreen> createState() => _RefereeScheduleScreenState();
}

class _RefereeScheduleScreenState extends State<RefereeScheduleScreen> {
  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _questionBlue = Color(0xFF4EB4E8);
  static const _selectedYellow = Color(0xFFF0B429);
  static const _typeBlue = Color(0xFF6EC8F5);
  static const _idleFill = Color(0xFF1A1F28);

  static const _dates = ['12 Oct 2026', '13 Oct 2026', '14 Oct 2026', '15 Oct 2026'];
  static const _times = ['3:00 PM', '5:00 PM', '6:30 PM', '8:00 PM'];
  static const _durations = ['1 Hour', '2 Hours', '2 Hours'];

  bool _hourly = false;
  int _date = 0;
  int _time = 0;
  int _duration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: ColoredBox(
        color: _pageBg,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  children: [
                    Row(
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
                    const SizedBox(height: 16),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.location_on_rounded, color: _mint, size: 16),
                              ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Booking Type',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: _questionBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TypePill(
                          label: 'Hourly',
                          selected: _hourly,
                          onTap: () => setState(() => _hourly = true),
                        ),
                        const SizedBox(width: 10),
                        _TypePill(
                          label: 'Daily',
                          selected: !_hourly,
                          onTap: () => setState(() => _hourly = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Date',
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return _YellowChip(
                            label: _dates[index],
                            selected: _date == index,
                            onTap: () => setState(() => _date = index),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Start Time',
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var i = 0; i < _times.length; i++)
                          _YellowChip(
                            label: _times[i],
                            selected: _time == i,
                            onTap: () => setState(() => _time = i),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Duration',
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var i = 0; i < _durations.length; i++)
                          _YellowChip(
                            label: _durations[i],
                            selected: _duration == i,
                            onTap: () => setState(() => _duration = i),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RefereeChooseListScreen(
                          draft: widget.draft.copyWith(
                            hourly: _hourly,
                            dateLabel: _dates[_date],
                            timeLabel: _times[_time],
                            durationLabel: _durations[_duration],
                            location: 'KPHB Indoor Stadium, Kompally, Hyderabad',
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.bannerGradient,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A1E).withValues(alpha: 0.4),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      'Register Individually',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 108,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _RefereeScheduleScreenState._typeBlue : _RefereeScheduleScreenState._idleFill,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            color: selected ? Colors.black : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _YellowChip extends StatelessWidget {
  const _YellowChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? _RefereeScheduleScreenState._selectedYellow : _RefereeScheduleScreenState._idleFill,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            color: selected ? Colors.black : const Color(0xFF8B919C),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
