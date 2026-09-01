import 'package:flutter/material.dart';

/// Static design-time model for a row in the "Browse Tournaments" list on
/// the home dashboard. No persistence/network layer — purely for UI
/// presentation.
import 'package:intl/intl.dart';

class TournamentInfo {
  const TournamentInfo({
    this.id,
    required this.sport,
    required this.dateLabel,
    required this.title,
    required this.location,
    this.distanceKm,
    required this.prize,
    required this.statLabel,
    required this.footerLabel,
    this.avatarLetter,
    this.avatarColor,
  });

  final int? id;
  final String sport;
  final String dateLabel;
  final String title;
  final String location;
  final String? distanceKm;
  final String prize;
  final String statLabel;
  final String footerLabel;
  final String? avatarLetter;
  final Color? avatarColor;

  factory TournamentInfo.fromJson(Map<String, dynamic> json) {
    String formattedDate = 'TBD';
    if (json['tournament_start_at'] != null) {
      try {
        final date = DateTime.parse(json['tournament_start_at']);
        formattedDate = DateFormat('dd MMM yyyy').format(date);
      } catch (_) {}
    }

    String sportName = json['sport']?['name'] ?? 'Unknown';
    
    return TournamentInfo(
      id: json['id'],
      sport: sportName,
      dateLabel: formattedDate,
      title: json['name'] ?? 'Unnamed Tournament',
      location: json['location'] ?? 'Unknown Location',
      distanceKm: json['distance'] != null ? '${json['distance']} km' : null,
      prize: json['prize_amount'] != null ? '₹${json['prize_amount']}' : '₹0',
      statLabel: json['slots_left'] != null ? '${json['slots_left']} Slots Left' : 'Registration Open',
      footerLabel: 'Starting soon',
      avatarLetter: sportName.isNotEmpty ? sportName[0].toUpperCase() : 'T',
    );
  }
}

const List<TournamentInfo> dummyTournaments = [
  TournamentInfo(
    sport: 'Cricket',
    dateLabel: '06 July 2026',
    title: 'Jaipur Super Over',
    location: 'Hyderabad',
    distanceKm: '4.5 km',
    prize: '₹50,000',
    statLabel: '12 Slots Left',
    footerLabel: 'Reg Ends: 30 June 2026',
  ),
  TournamentInfo(
    sport: 'Cricket',
    dateLabel: '06 July 2026',
    title: 'Jaipur Super Over',
    location: 'Hyderabad',
    distanceKm: '4.5 km',
    prize: '₹50,000',
    statLabel: '32 Teams · 12 Slots Left',
    footerLabel: 'Registration Ends: 30 June 2026',
    avatarLetter: 'D',
    avatarColor: Color(0xFF3ADFA0),
  ),
  TournamentInfo(
    sport: 'Football',
    dateLabel: 'Start On 06 July 2026',
    title: 'Fifa World Cup 2026',
    location: 'Hyderabad',
    prize: '₹100k',
    statLabel: '32 Teams',
    footerLabel: 'Registration Ends: 30 June 2026',
    avatarLetter: 'D',
    avatarColor: Color(0xFFFF7A1E),
  ),
  TournamentInfo(
    sport: 'Cricket',
    dateLabel: 'Start On 06 July 2026',
    title: 'Asia Cup 2026',
    location: 'Hyderabad',
    distanceKm: '4.5 km',
    prize: '₹50k',
    statLabel: '32 Teams',
    footerLabel: 'Registration Ends: 30 June 2026',
    avatarLetter: 'D',
    avatarColor: Color(0xFF3ADFA0),
  ),
];
