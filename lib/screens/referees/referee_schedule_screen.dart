import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_booking_summary_screen.dart';
import 'referee_choose_list_screen.dart';
import 'widgets/referee_venue_card.dart';

/// Booking type / date / start time / duration — all built from the device's
/// current date & time.
///
/// * Quick Book → [RefereeBookingSummaryScreen] (referee "To Be Assigned").
/// * Browse     → [RefereeChooseListScreen] (pick a referee).
class RefereeScheduleScreen extends StatefulWidget {
  const RefereeScheduleScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  @override
  State<RefereeScheduleScreen> createState() => _RefereeScheduleScreenState();
}

class _RefereeScheduleScreenState extends State<RefereeScheduleScreen> {
  static const _pageBg = Color(0xFF0B0D12);
  static const _questionBlue = Color(0xFF4EB4E8);
  static const _selectedYellow = Color(0xFFF0B429);
  static const _typeBlue = Color(0xFF6EC8F5);
  static const _idleFill = Color(0xFF1A1F28);
  static const _mint = Color(0xFF3DDC97);

  // ---------- Booking window rules ----------
  /// Start times cover the full 24 hours: 12:00 AM … 11:00 PM.
  static const int _firstStartHour = 0;
  static const int _lastStartHour = 23;

  /// Gap between start-time slots (1 hour).
  static const int _slotMinutes = 60;

  /// Minimum notice so a referee can reach the venue.
  static const Duration _leadTime = Duration(minutes: 60);

  /// Hourly: 1 … this many hours.
  static const int _maxHours = 6;

  /// Per Day: fixed slot lengths in hours.
  static const List<int> _perDaySlots = [8, 10];

  static const int _daysAhead = 14;

  static final _dateFmt = DateFormat('dd MMM yyyy');
  static final _timeFmt = DateFormat('h:mm a');

  late bool _hourly = widget.draft.hourly;
  DateTime? _selectedDate; // date only (00:00)
  DateTime? _selectedStart; // exact start date-time

  /// Booked hours — Hourly: 1…6, Per Day: 8 or 10.
  int _hours = 1;
  Timer? _clockTicker;

  @override
  void initState() {
    super.initState();
    // Restore earlier picks (e.g. user came back and re-entered this screen).
    _selectedStart = widget.draft.startAt;
    if (_selectedStart != null) _selectedDate = _dateOnly(_selectedStart!);
    final savedMinutes = widget.draft.durationMinutes;
    _hours = savedMinutes != null && savedMinutes > 0
        ? (savedMinutes / 60).ceil()
        : (_hourly ? 1 : _perDaySlots.first);
    _ensureValidSelection();

    // Keep slots in sync with the clock while the screen is open.
    _clockTicker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(_ensureValidSelection);
    });
  }

  @override
  void dispose() {
    _clockTicker?.cancel();
    super.dispose();
  }

  // ---------- Generators (from device time) ----------

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Earliest bookable start: now + lead time, rounded up to the next slot.
  DateTime get _earliestStart {
    final t = DateTime.now().add(_leadTime);
    var candidate = DateTime(t.year, t.month, t.day, t.hour);
    while (candidate.isBefore(t)) {
      candidate = candidate.add(const Duration(minutes: _slotMinutes));
    }
    return candidate;
  }

  /// Hourly start slots for [date] (12:00 AM … 11:00 PM) that are still in
  /// the future. Same list for Hourly and Per Day; bookings may run past
  /// midnight into the next day.
  List<DateTime> _slotsFor(DateTime date) {
    final earliest = _earliestStart;
    final slots = <DateTime>[];
    for (var h = _firstStartHour; h <= _lastStartHour; h++) {
      final s = DateTime(date.year, date.month, date.day, h);
      if (!s.isBefore(earliest)) slots.add(s);
    }
    return slots;
  }

  /// Next [_daysAhead] days that still have at least one slot (today is
  /// skipped automatically once its last slot has passed).
  List<DateTime> get _dates {
    final today = _dateOnly(DateTime.now());
    final list = <DateTime>[];
    for (var i = 0; i <= _daysAhead && list.length < _daysAhead; i++) {
      final d = DateTime(today.year, today.month, today.day + i);
      if (_slotsFor(d).isNotEmpty) list.add(d);
    }
    return list;
  }

  /// Hourly: 1 … [_maxHours]. Per Day: [_perDaySlots].
  List<int> get _hourOptions =>
      _hourly ? List.generate(_maxHours, (i) => i + 1) : _perDaySlots;

  /// End date-time for the current selection (may be the next day).
  DateTime? get _endAt => _selectedStart?.add(Duration(hours: _hours));

  /// Keeps date / start / hours valid after any change (type switch,
  /// date switch, or the clock moving past the selected slot).
  void _ensureValidSelection() {
    final dates = _dates;
    if (dates.isEmpty) {
      _selectedDate = null;
      _selectedStart = null;
      return;
    }
    if (_selectedDate == null || !dates.contains(_selectedDate)) {
      _selectedDate = dates.first;
    }
    final slots = _slotsFor(_selectedDate!);
    if (_selectedStart == null || !slots.contains(_selectedStart)) {
      _selectedStart = slots.isNotEmpty ? slots.first : null;
    }
    final options = _hourOptions;
    if (!options.contains(_hours)) _hours = options.first;
  }

  // ---------- Labels ----------

  String _dateChipLabel(DateTime d) {
    final today = _dateOnly(DateTime.now());
    final diff = d.difference(today).inDays;
    if (diff == 0) return 'Today, ${DateFormat('dd MMM').format(d)}';
    if (diff == 1) return 'Tomorrow, ${DateFormat('dd MMM').format(d)}';
    return _dateFmt.format(d);
  }

  String _hoursLabel(int n) =>
      _hourly ? '$n ${n == 1 ? 'Hour' : 'Hours'}' : '$n Hrs';

  // ---------- Actions ----------

  void _setHourly(bool value) {
    if (_hourly == value) return;
    setState(() {
      _hourly = value;
      _hours = value ? 1 : _perDaySlots.first;
      _ensureValidSelection();
    });
  }

  void _selectDate(DateTime d) {
    setState(() {
      _selectedDate = d;
      _selectedStart = null;
      _ensureValidSelection();
    });
  }

  void _selectStart(DateTime s) {
    setState(() {
      _selectedStart = s;
      _ensureValidSelection();
    });
  }

  void _selectHours(int h) => setState(() => _hours = h);

  void _continue() {
    // Re-check against the clock right before moving on.
    setState(_ensureValidSelection);
    final start = _selectedStart;
    final end = _endAt;
    if (start == null || end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an available slot.')),
      );
      return;
    }

    final draft = widget.draft.copyWith(
      hourly: _hourly,
      startAt: start,
      endAt: end,
      durationMinutes: _hours * 60,
      timezone: RefereeBookingDraft.defaultTimezone,
      dateLabel: _dateFmt.format(start),
      timeLabel: _timeFmt.format(start),
      durationLabel: _hoursLabel(_hours),
    );

    // Quick Book, or a referee already chosen → summary. Otherwise browse list.
    final goToSummary = draft.autoMatch || draft.official != null;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => goToSummary
            ? RefereeBookingSummaryScreen(draft: draft)
            : RefereeChooseListScreen(draft: draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dates = _dates;
    final slots = _selectedDate != null
        ? _slotsFor(_selectedDate!)
        : const <DateTime>[];
    final hourOptions = _hourOptions;
    final end = _endAt;

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
                        GlassBackButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
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
                    RefereeVenueCard(draft: widget.draft),
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
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _idleFill,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _TypePill(
                              label: 'Hourly',
                              selected: _hourly,
                              onTap: () => _setHourly(true),
                            ),
                            _TypePill(
                              label: 'Per Day',
                              selected: !_hourly,
                              onTap: () => _setHourly(false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Date
                    const _SectionLabel('Date'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final d = dates[index];
                          return _YellowChip(
                            label: _dateChipLabel(d),
                            selected: d == _selectedDate,
                            onTap: () => _selectDate(d),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Start time
                    const _SectionLabel('Start Time'),
                    const SizedBox(height: 10),
                    if (slots.isEmpty)
                      Text(
                        'No slots left for this date.',
                        style: GoogleFonts.quicksand(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      )
                    else
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: slots.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final s = slots[index];
                            return _YellowChip(
                              label: _timeFmt.format(s),
                              selected: s == _selectedStart,
                              onTap: () => _selectStart(s),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Hourly → "Duration" (1…6 hours). Per Day → "Slot" (8 / 10 Hrs).
                    _SectionLabel(_hourly ? 'Duration' : 'Slot'),
                    if (!_hourly) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Referee stays with you for the selected hours',
                        style: GoogleFonts.quicksand(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final n in hourOptions)
                          _YellowChip(
                            label: _hoursLabel(n),
                            selected: _hours == n,
                            wide: !_hourly,
                            onTap: () => _selectHours(n),
                          ),
                      ],
                    ),

                    // Selected slot summary
                    if (_selectedStart != null && end != null) ...[
                      const SizedBox(height: 22),
                      _SlotSummary(
                        start: _selectedStart!,
                        end: end,
                        typeLabel: _hourly ? 'Hourly' : 'Per Day',
                        durationLabel: _hoursLabel(_hours),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                child: GestureDetector(
                  onTap: _continue,
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
                      widget.draft.autoMatch || widget.draft.official != null
                          ? 'Continue to Booking'
                          : 'Find Referees',
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

/// "Your Slot" card: start → end of the current selection.
class _SlotSummary extends StatelessWidget {
  const _SlotSummary({
    required this.start,
    required this.end,
    required this.typeLabel,
    required this.durationLabel,
  });

  final DateTime start;
  final DateTime end;
  final String typeLabel;
  final String durationLabel;

  @override
  Widget build(BuildContext context) {
    final dayFmt = DateFormat('EEE, dd MMM');
    final timeFmt = DateFormat('h:mm a');
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF10241C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F4A38)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_rounded,
            color: _RefereeScheduleScreenState._mint,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Slot  •  $typeLabel  •  $durationLabel',
                  style: GoogleFonts.quicksand(
                    color: _RefereeScheduleScreenState._mint,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  // Same day: "Wed, 04 Nov • 9:00 PM – 11:00 PM"
                  // Past midnight: "Wed, 04 Nov 11:00 PM → Thu, 05 Nov 7:00 AM"
                  DateUtils.isSameDay(start, end)
                      ? '${dayFmt.format(start)}  •  ${timeFmt.format(start)} – ${timeFmt.format(end)}'
                      : '${dayFmt.format(start)} ${timeFmt.format(start)} → ${dayFmt.format(end)} ${timeFmt.format(end)}',
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 104,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? _RefereeScheduleScreenState._typeBlue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
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
  const _YellowChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
    this.wide = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Greyed out (e.g. a 10 Hrs slot that would run past the day end).
  final bool enabled;

  /// Wider chip (used for the Per Day 8 / 10 Hrs slots).
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          constraints: BoxConstraints(minWidth: wide ? 110 : 0),
          alignment: wide ? Alignment.center : null,
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 20 : 14,
            vertical: wide ? 11 : 9,
          ),
          decoration: BoxDecoration(
            color: selected && enabled
                ? _RefereeScheduleScreenState._selectedYellow
                : _RefereeScheduleScreenState._idleFill,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              color: selected && enabled
                  ? Colors.black
                  : const Color(0xFF8B919C),
              fontSize: wide ? 14 : 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
