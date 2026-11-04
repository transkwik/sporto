import 'dart:convert';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';

enum RefereeBookingStatus { upcoming, ongoing }

/// Everything collected across the referee booking flow. Each screen adds its
/// values with [copyWith] and passes the draft to the next screen.
///
/// [toBookingPayload] returns the exact body for the booking API:
/// ```json
/// {
///   "sport_id": 1,
///   "booking_method": "QUICK",
///   "booking_type": "HOURLY",
///   "booking_date": "2026-11-04",
///   "start_time": "10:00",
///   "duration_minutes": 120,
///   "timezone": "Asia/Kolkata",
///   "venue_name": "Community sports ground",
///   "city": "Hyderabad"
/// }
/// ```
class RefereeBookingDraft {
  const RefereeBookingDraft({
    required this.sport,
    required this.location,
    this.sportId,
    this.venueName = '',
    this.city = '',
    this.latitude,
    this.longitude,
    this.autoMatch = false,
    this.hourly = true,
    this.startAt,
    this.endAt,
    this.durationMinutes,
    this.timezone = defaultTimezone,
    this.dateLabel = '',
    this.timeLabel = '',
    this.durationLabel = '',
    this.official,
  });

  // ---------- API enum values ----------
  static const String defaultTimezone = 'Asia/Kolkata';
  static const String methodQuick = 'QUICK';
  static const String methodBrowse = 'BROWSE';
  static const String typeHourly = 'HOURLY';
  static const String typePerDay = 'DAILY';

  /// Hours treated as one full day when pricing a Per Day booking.
  static const int perDayBaseHours = 8;

  // Sport (Select Sport screen)
  final String sport;
  final int? sportId;

  // Location (Game Location screen)
  /// Full display address, e.g. "KPHB Indoor Stadium, Kompally, Hyderabad".
  final String location;

  /// `venue_name`, e.g. "KPHB Indoor Stadium".
  final String venueName;

  /// `city`, e.g. "Hyderabad".
  final String city;
  final double? latitude;
  final double? longitude;

  /// true = Quick Book (random referee), false = Browse / choose referee.
  final bool autoMatch;

  // Schedule (Your Sponsorship screen)
  /// true = Hourly booking, false = Per Day booking.
  final bool hourly;

  /// Exact start date-time picked by the user (device local time).
  final DateTime? startAt;

  /// Exact end date-time (start + duration).
  final DateTime? endAt;

  /// `duration_minutes` — Hourly: 60 × hours, Per Day: 480 (8 hrs) / 600 (10 hrs).
  final int? durationMinutes;

  /// `timezone` (IANA name).
  final String timezone;

  /// Display labels, e.g. "04 Nov 2026", "9:00 PM", "2 Hours" / "8 Hrs".
  final String dateLabel;
  final String timeLabel;
  final String durationLabel;

  // Referee (Browse flow, or assigned after payment in Quick Book)
  final RefereeOfficial? official;

  RefereeBookingDraft copyWith({
    String? sport,
    int? sportId,
    String? location,
    String? venueName,
    String? city,
    double? latitude,
    double? longitude,
    bool? autoMatch,
    bool? hourly,
    DateTime? startAt,
    DateTime? endAt,
    int? durationMinutes,
    String? timezone,
    String? dateLabel,
    String? timeLabel,
    String? durationLabel,
    RefereeOfficial? official,
  }) {
    return RefereeBookingDraft(
      sport: sport ?? this.sport,
      sportId: sportId ?? this.sportId,
      location: location ?? this.location,
      venueName: venueName ?? this.venueName,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      autoMatch: autoMatch ?? this.autoMatch,
      hourly: hourly ?? this.hourly,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      timezone: timezone ?? this.timezone,
      dateLabel: dateLabel ?? this.dateLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      durationLabel: durationLabel ?? this.durationLabel,
      official: official ?? this.official,
    );
  }

  // ---------- API keys ----------

  /// `booking_method`: "QUICK" (Quick Book) or "BROWSE" (chosen referee).
  String get bookingMethod => autoMatch ? methodQuick : methodBrowse;

  /// `booking_type`: "HOURLY" or "DAILY" (shown as "Per Day" in the UI).
  String get bookingType => hourly ? typeHourly : typePerDay;

  /// `booking_date`: "yyyy-MM-dd".
  String? get bookingDate =>
      startAt == null ? null : DateFormat('yyyy-MM-dd').format(startAt!);

  /// `start_time`: "HH:mm" (24h).
  String? get startTime =>
      startAt == null ? null : DateFormat('HH:mm').format(startAt!);

  /// Exact request body for the referee booking API (same key order as the
  /// backend contract).
  Map<String, dynamic> toBookingPayload() {
    return {
      'sport_id': sportId,
      'booking_method': bookingMethod,
      'booking_type': bookingType,
      'booking_date': bookingDate,
      'start_time': startTime,
      'duration_minutes': durationMinutes,
      'timezone': timezone,
      'venue_name': venueTitle,
      'city': city,
    };
  }

  /// Pretty JSON of [toBookingPayload], e.g.
  /// ```json
  /// {
  ///   "sport_id": 1,
  ///   "booking_method": "QUICK",
  ///   ...
  /// }
  /// ```
  String get bookingPayloadJson =>
      const JsonEncoder.withIndent('  ').convert(toBookingPayload());

  /// Prints the payload to the Debug Console.
  void printBookingPayload() {
    final json = bookingPayloadJson;
    // `print` always shows in the IDE Debug Console / `flutter run` output.
    // ignore: avoid_print
    print('========== REFEREE BOOKING PAYLOAD ==========\n$json\n=============================================');
    // Also visible in DevTools → Logging (same logger the API helper uses).
    developer.log(json, name: 'REFEREE_BOOKING_PAYLOAD');
  }

  // ---------- Schedule helpers ----------

  String get bookingTypeLabel => hourly ? 'Hourly' : 'Per Day';

  /// Booked hours ([durationMinutes] / 60, or parsed from [durationLabel]).
  int get durationHours {
    final m = durationMinutes;
    if (m != null && m > 0) return (m / 60).ceil();
    final match = RegExp(r'\d+').firstMatch(durationLabel);
    final value = int.tryParse(match?.group(0) ?? '') ?? 1;
    return value <= 0 ? 1 : value;
  }

  /// "04 Nov 2026, 6:00 PM" (empty when no end time is set).
  String get endLabel =>
      endAt == null ? '' : DateFormat('dd MMM yyyy, h:mm a').format(endAt!);

  /// "9:00 AM – 5:00 PM", or "11:00 PM – 7:00 AM (next day)" past midnight.
  String get timeRangeLabel {
    final s = startAt;
    final e = endAt;
    if (s == null || e == null) return timeLabel;
    final nextDay =
        DateTime(e.year, e.month, e.day) != DateTime(s.year, s.month, s.day);
    return '${DateFormat('h:mm a').format(s)} – ${DateFormat('h:mm a').format(e)}'
        '${nextDay ? ' (next day)' : ''}';
  }

  // ---------- Venue helpers ----------

  /// Venue name, e.g. "KPHB Indoor Stadium".
  String get venueTitle {
    if (venueName.trim().isNotEmpty) return venueName.trim();
    final parts = location
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return parts.isNotEmpty ? parts.first : 'Selected Location';
  }

  /// Rest of the address, e.g. "Kompally, Hyderabad".
  String get venueSubtitle {
    final parts = location
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.length > 1) return parts.sublist(1).join(', ');
    return city;
  }

  // ---------- Pricing helpers ----------

  /// Default rates used for Quick Book (referee not chosen yet).
  static const int quickHourlyRate = 350;
  static const int quickDailyRate = 2500;

  /// Hourly rate, or the Per Day rate (for [perDayBaseHours] hours).
  int get rate {
    final o = official;
    if (o != null) {
      return parseRupees(hourly ? o.hourlyFeeLabel : o.dailyFeeLabel);
    }
    return hourly ? quickHourlyRate : quickDailyRate;
  }

  /// Hourly: rate × hours. Per Day: day rate scaled to the slot (8 / 10 hrs).
  int get refereeFee => hourly
      ? rate * durationHours
      : (rate * durationHours / perDayBaseHours).round();

  int get platformFee => (refereeFee * 0.10).round();
  int get totalAmount => refereeFee + platformFee;

  /// "₹400 × 2 hrs" or "Per Day • 10 hrs".
  String get feeBreakdownLabel => hourly
      ? '${rupees(rate)} × $durationHours ${durationHours == 1 ? 'hr' : 'hrs'}'
      : 'Per Day • $durationHours hrs';

  static int parseRupees(String label) =>
      int.tryParse(label.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  /// "₹1,250" style formatting (Indian grouping).
  static String rupees(int amount) {
    final s = amount.toString();
    if (s.length <= 3) return '₹$s';
    final last3 = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    return '₹${parts.join(',')},$last3';
  }
}

class RefereeAssignment {
  const RefereeAssignment({
    required this.id,
    required this.name,
    required this.sport,
    required this.venue,
    required this.durationLabel,
    required this.dateTimeLabel,
    required this.feeLabel,
    required this.status,
    this.photoUrl,
  });

  final int id;
  final String name;
  final String sport;
  final String venue;
  final String durationLabel;
  final String dateTimeLabel;
  final String feeLabel;
  final RefereeBookingStatus status;
  final String? photoUrl;
}

class RefereeReview {
  const RefereeReview({required this.author, required this.text});
  final String author;
  final String text;
}

class RefereeOfficial {
  const RefereeOfficial({
    required this.id,
    required this.name,
    required this.sport,
    required this.experienceYears,
    required this.level,
    required this.rating,
    required this.matches,
    required this.feePerMatchLabel,
    this.available = true,
    this.photoUrl,
    this.distanceKm = 3.6,
    this.about =
        'Former state-level cricketer turned certified umpire. Specialises in T10/T20 league matches and keeps a calm, decisive presence on tight calls.',
    this.hourlyFeeLabel = '₹400',
    this.dailyFeeLabel = '₹2800',
    this.reviewCount = 184,
    this.reviews = const [
      RefereeReview(author: 'Warriors FC Captain', text: 'Fair and fast decisions, kept the match moving.'),
      RefereeReview(author: 'Falcons CC', text: 'Arrived early, very professional.'),
    ],
  });

  final int id;
  final String name;
  final String sport;
  final int experienceYears;
  final String level;
  final double rating;
  final int matches;
  final String feePerMatchLabel;
  final bool available;
  final String? photoUrl;
  final double distanceKm;
  final String about;
  final String hourlyFeeLabel;
  final String dailyFeeLabel;
  final int reviewCount;
  final List<RefereeReview> reviews;
}

const dummyRefereeAssignments = [
  RefereeAssignment(
    id: 1,
    name: 'Suresh Reddy',
    sport: 'Cricket',
    venue: 'Kompally Turf Arena',
    durationLabel: 'Full Day',
    dateTimeLabel: '13 Oct 2026  •  5:00 PM',
    feeLabel: '₹2750',
    status: RefereeBookingStatus.upcoming,
  ),
  RefereeAssignment(
    id: 2,
    name: 'Vijay Mohan',
    sport: 'Cricket',
    venue: 'Kompally Turf Arena',
    durationLabel: 'Full Day',
    dateTimeLabel: '13 Oct 2026  •  5:00 PM',
    feeLabel: '₹2750',
    status: RefereeBookingStatus.ongoing,
  ),
];

const _dummyPhoto =
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200';

const dummyLastAssignedReferees = [
  RefereeOfficial(
    id: 11,
    name: 'Suresh Reddy',
    sport: 'Cricket',
    experienceYears: 8,
    level: '3 Level',
    rating: 4.8,
    matches: 34,
    feePerMatchLabel: '₹800',
    photoUrl: _dummyPhoto,
    distanceKm: 3.6,
  ),
  RefereeOfficial(
    id: 12,
    name: 'Vijay Mohan',
    sport: 'Cricket',
    experienceYears: 8,
    level: '3 Level',
    rating: 4.8,
    matches: 34,
    feePerMatchLabel: '₹800',
    photoUrl: _dummyPhoto,
    distanceKm: 4.2,
  ),
];

const dummyAvailableReferees = [
  ...dummyLastAssignedReferees,
  RefereeOfficial(
    id: 13,
    name: 'Vijay Mohan',
    sport: 'Cricket',
    experienceYears: 8,
    level: '3 Level',
    rating: 4.8,
    matches: 34,
    feePerMatchLabel: '₹800',
    photoUrl: _dummyPhoto,
    distanceKm: 4.2,
  ),
  RefereeOfficial(
    id: 14,
    name: 'Arjun Rao',
    sport: 'Football',
    experienceYears: 10,
    level: '3 Level',
    rating: 4.9,
    matches: 52,
    feePerMatchLabel: '₹900',
  ),
];
