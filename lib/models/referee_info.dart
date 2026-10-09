enum RefereeBookingStatus { upcoming, ongoing }

class RefereeBookingDraft {
  const RefereeBookingDraft({
    required this.sport,
    required this.location,
    this.autoMatch = false,
    this.hourly = true,
    this.dateLabel = '12 Oct 2026',
    this.timeLabel = '5:00 PM',
    this.durationLabel = '2 Hours',
    this.official,
  });

  final String sport;
  final String location;
  final bool autoMatch;
  final bool hourly;
  final String dateLabel;
  final String timeLabel;
  final String durationLabel;
  final RefereeOfficial? official;

  RefereeBookingDraft copyWith({
    String? sport,
    String? location,
    bool? autoMatch,
    bool? hourly,
    String? dateLabel,
    String? timeLabel,
    String? durationLabel,
    RefereeOfficial? official,
  }) {
    return RefereeBookingDraft(
      sport: sport ?? this.sport,
      location: location ?? this.location,
      autoMatch: autoMatch ?? this.autoMatch,
      hourly: hourly ?? this.hourly,
      dateLabel: dateLabel ?? this.dateLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      durationLabel: durationLabel ?? this.durationLabel,
      official: official ?? this.official,
    );
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
