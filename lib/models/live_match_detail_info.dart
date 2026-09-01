import 'package:flutter/material.dart';

/// Static design-time model for a single batsman's row on the live
/// scorecard.
class BatsmanStat {
  const BatsmanStat({
    required this.name,
    this.isCaptain = false,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
  });

  final String name;
  final bool isCaptain;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final String strikeRate;
}

/// Static design-time model for a single bowler's row on the live
/// scorecard.
class BowlerStat {
  const BowlerStat({
    required this.name,
    required this.wicketsRuns,
    required this.overs,
    required this.strikeRate,
  });

  final String name;
  final String wicketsRuns;
  final String overs;
  final String strikeRate;
}

/// Static design-time model for the full live match scorecard screen. No
/// persistence/network layer — purely for UI presentation.
class LiveMatchDetailInfo {
  const LiveMatchDetailInfo({
    required this.tournamentName,
    required this.location,
    required this.roundLabel,
    required this.teamAName,
    required this.teamAInitials,
    required this.teamAColor,
    required this.teamARole,
    required this.teamBName,
    required this.teamBRole,
    required this.battingScore,
    required this.overs,
    required this.currentRunRate,
    required this.currentBowler,
    required this.thisOverBalls,
    required this.batsmen,
    required this.bowlers,
    required this.likeCount,
    required this.fireCount,
  });

  final String tournamentName;
  final String location;
  final String roundLabel;
  final String teamAName;
  final String teamAInitials;
  final Color teamAColor;
  final String teamARole;
  final String teamBName;
  final String teamBRole;
  final String battingScore;
  final String overs;
  final String currentRunRate;
  final String currentBowler;
  final List<String> thisOverBalls;
  final List<BatsmanStat> batsmen;
  final List<BowlerStat> bowlers;
  final String likeCount;
  final String fireCount;
}

const LiveMatchDetailInfo dummyLiveMatchDetail = LiveMatchDetailInfo(
  tournamentName: 'Asia Cup 2026',
  location: 'Hyderabad',
  roundLabel: 'Quarter Final',
  teamAName: 'Hyd Highlanders',
  teamAInitials: 'HH',
  teamAColor: Color(0xFF2E9EE0),
  teamARole: 'Batting',
  teamBName: 'Delhi Warriors',
  teamBRole: 'Bowling',
  battingScore: '90/2',
  overs: '6.2/10',
  currentRunRate: '6.67',
  currentBowler: 'Amit Kumar',
  thisOverBalls: ['4', '1', '•', '•', '•', '•'],
  batsmen: [
    BatsmanStat(name: 'Shrvn Prajapati', isCaptain: true, runs: 12, balls: 6, fours: 1, sixes: 1, strikeRate: '200.0'),
    BatsmanStat(name: 'Amit Kumar', runs: 8, balls: 3, fours: 0, sixes: 1, strikeRate: '266.7'),
  ],
  bowlers: [
    BowlerStat(name: 'Dev Kumar', wicketsRuns: '0-1', overs: '0.2', strikeRate: '7.50'),
  ],
  likeCount: '1.2k',
  fireCount: '543',
);
