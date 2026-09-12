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
