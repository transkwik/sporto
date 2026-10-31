// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sporto/screens/profile/tournaments/match_result_details_screen.dart';
// import 'package:sporto/screens/profile/tournaments/widgets/squad_player_stat_card.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../../core/widgets/glass_back_button.dart';
// import '../../../models/match_data_parser.dart';
// import '../../../models/my_tournament_info.dart';
// import '../../../core/apiServices/user_api.dart';
// import '../../tournament/widgets/tournament_stat_box.dart';

// /// User's tournament recap: summary, prize, squad stats, and match results.
// class MyTournamentDetailswallateScreen extends StatefulWidget {
//   const MyTournamentDetailswallateScreen({super.key,    required this.tournament});

//   final MyTournamentInfo tournament;

//   @override
//   State<MyTournamentDetailswallateScreen> createState() =>
//       _MyTournamentDetailswallateScreenState();
// }

// class _MyTournamentDetailswallateScreenState
//     extends State<MyTournamentDetailswallateScreen> {
//   int _tab = 0;
//   bool _isLoading = true;
//   Map<String, dynamic>? _apiData;
//   List<MyTournamentPlayerStat> _squad = [];
//   List<MyTournamentMatchResult> _matches = [];
//   String _playedValue = '0';
//   String _wonValue = '0';
//   String _lostValue = '0';
//   String _finalRankValue = '—';

//   MyTournamentInfo get t => widget.tournament;

//   static const List<String> _months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fetchDetails();
//   }

//   Future<void> _fetchDetails() async {
//     final tournamentId = int.tryParse(widget.tournament.id);
//     if (tournamentId == null) {
//       setState(() => _isLoading = false);
//       return;
//     }

//     final response = await UserApis().getTournamentDetail(tournamentId);
//     if (response != null &&
//         response['success'] == true &&
//         response['data'] is Map<String, dynamic>) {
//       final data = response['data'] as Map<String, dynamic>;

//       final myReg =
//           (data['my_registration'] ?? data['registration']?['my_registration'])
//               as Map<String, dynamic>?;
//       final myTeam = myReg?['team'] as Map<String, dynamic>?;
//       final myTeamId = (myReg?['team_id'] ?? myTeam?['id'])?.toString();
//       final myTeamName =
//           (myReg?['team_name'] ?? myTeam?['name'])?.toString() ?? '';

//       // Parse Squad from my_registration.team.members
//       final membersList = myTeam?['members'] as List<dynamic>? ?? [];
//       _squad = membersList.map((m) {
//         final member = m as Map<String, dynamic>;
//         final isCaptain = member['is_captain'] == true;
//         final roleLabel = isCaptain ? 'Captain' : 'Player';
//         return MyTournamentPlayerStat(
//           name: member['player_name']?.toString() ?? 'Unknown',
//           role: myTeamName.isNotEmpty ? '$roleLabel • $myTeamName' : roleLabel,
//           runs: int.tryParse(member['runs']?.toString() ?? '') ?? 0,
//           wickets: int.tryParse(member['wickets']?.toString() ?? '') ?? 0,
//           isYou: isCaptain,
//         );
//       }).toList();

//       // Parse Matches from matches.items
//       final matchesList = data['matches']?['items'] as List<dynamic>? ?? [];
//       int myPlayed = 0;
//       int myWon = 0;
//       int myLost = 0;
//       String? lastMyRound;

//       _matches = matchesList.map((m) {
//         final item = m as Map<String, dynamic>;
//         final teamA = MatchDataParser.team(item, isA: true);
//         final teamB = MatchDataParser.team(item, isA: false);
//         final scoreA = MatchDataParser.score(item, teamA.id);
//         final scoreB = MatchDataParser.score(item, teamB.id);

//         final roundName =
//             item['round']?['name']?.toString() ??
//             item['stage']?['name']?.toString() ??
//             'Match';
//         final matchNum =
//             item['match_number'] ?? item['match']?['match_number'] ?? '';
//         final statusKey =
//             (item['status_key'] ?? item['match']?['status'])
//                 ?.toString()
//                 .toUpperCase() ??
//             '';
//         final statusLabel = item['status_label']?.toString() ?? 'Upcoming';

//         String resultPart = statusLabel;
//         if (statusKey == 'COMPLETED') {
//           final winner = MatchDataParser.winnerName(item);
//           if (winner != 'No result' &&
//               winner != 'Match Tied' &&
//               winner != 'Match Drawn') {
//             resultPart = '$winner won';
//           } else {
//             resultPart = winner;
//           }
//         }

//         // Track stats for user's registered team
//         if (myTeamId != null &&
//             (teamA.id == myTeamId || teamB.id == myTeamId)) {
//           lastMyRound = roundName;
//           if (statusKey == 'COMPLETED') {
//             myPlayed++;
//             final winnerId =
//                 (item['result']?['winner_team_id'] ??
//                         item['match']?['winner_team_id'])
//                     ?.toString();
//             if (winnerId != null) {
//               if (winnerId == myTeamId) {
//                 myWon++;
//               } else {
//                 myLost++;
//               }
//             }
//           }
//         }

//         final formattedScoreA = scoreA.hasData ? scoreA.score : 'Yet to bat';
//         final formattedScoreB = scoreB.hasData ? scoreB.score : 'Yet to bat';

//         final matchNumStr = matchNum.toString().isNotEmpty
//             ? 'Match $matchNum'
//             : '';
//         final labelParts = [
//           if (roundName.isNotEmpty) roundName,
//           if (matchNumStr.isNotEmpty) matchNumStr,
//         ];

//         return MyTournamentMatchResult(
//           matchLabel: labelParts.isNotEmpty
//               ? labelParts.join(' — ')
//               : resultPart,
//           teamA: teamA.name,
//           teamB: teamB.name,
//           scoreA: formattedScoreA,
//           scoreB: formattedScoreB,
//           rawMatch: item,
//         );
//       }).toList();

//       // Compute Played / Won / Lost / Final Rank
//       if (myTeamId != null && myPlayed > 0) {
//         _playedValue = '$myPlayed';
//         _wonValue = '$myWon';
//         _lostValue = '$myLost';
//       } else {
//         final totalMatches =
//             data['match_summary']?['total'] ?? matchesList.length;
//         final completedMatches = data['match_summary']?['completed'] ?? 0;
//         _playedValue = '$totalMatches';
//         _wonValue = '$completedMatches';
//         _lostValue = '0';
//       }

//       final resultMap = data['result'] as Map<String, dynamic>?;
//       final winnerTeamId =
//           (resultMap?['winner'] is Map ? resultMap!['winner']['team_id'] : null)
//               ?.toString();
//       final runnerUpTeamId =
//           (resultMap?['runner_up'] is Map
//                   ? resultMap!['runner_up']['team_id']
//                   : null)
//               ?.toString();

//       if (myTeamId != null && winnerTeamId == myTeamId) {
//         _finalRankValue = '#1';
//       } else if (myTeamId != null && runnerUpTeamId == myTeamId) {
//         _finalRankValue = '#2';
//       } else if (lastMyRound != null &&
//           lastMyRound!.toLowerCase().contains('semi')) {
//         _finalRankValue = 'SF';
//       } else if (lastMyRound != null && lastMyRound!.isNotEmpty) {
//         _finalRankValue = lastMyRound!;
//       } else {
//         _finalRankValue = '—';
//       }

//       setState(() {
//         _apiData = data;
//         _isLoading = false;
//       });
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   String _resolveTitle() {
//     return _apiData?['tournament']?['name']?.toString() ??
//         _apiData?['name']?.toString() ??
//         t.title;
//   }

//   String _resolveDateRange() {
//     final dates = _apiData?['tournament']?['dates'] as Map<String, dynamic>?;
//     final startRaw =
//         (dates?['tournament_start_at'] ?? _apiData?['tournament_start_at'])
//             ?.toString();
//     final endRaw =
//         (dates?['tournament_end_at'] ?? _apiData?['tournament_end_at'])
//             ?.toString();

//     final startDt = startRaw != null
//         ? DateTime.tryParse(startRaw)?.toLocal()
//         : null;
//     final endDt = endRaw != null ? DateTime.tryParse(endRaw)?.toLocal() : null;

//     if (startDt != null && endDt != null) {
//       if (startDt.year == endDt.year &&
//           startDt.month == endDt.month &&
//           startDt.day == endDt.day) {
//         return '${_months[startDt.month - 1]} ${startDt.day}, ${startDt.year}';
//       }
//       return '${_months[startDt.month - 1]} ${startDt.day} – ${_months[endDt.month - 1]} ${endDt.day}, ${endDt.year}';
//     } else if (startDt != null) {
//       return '${_months[startDt.month - 1]} ${startDt.day}, ${startDt.year}';
//     }
//     return t.dateRange;
//   }

//   String _resolveLocation() {
//     final venues = _apiData?['venues'];
//     if (venues is List && venues.isNotEmpty) {
//       Map<String, dynamic>? primary;
//       for (final v in venues) {
//         if (v is Map<String, dynamic> && v['is_primary'] == true) {
//           primary = v;
//           break;
//         }
//       }
//       primary ??= venues.first is Map<String, dynamic>
//           ? venues.first as Map<String, dynamic>
//           : null;
//       if (primary != null) {
//         final vName = primary['venue_name']?.toString() ?? '';
//         final vLoc = primary['location']?.toString() ?? '';
//         if (vName.isNotEmpty && vLoc.isNotEmpty) return '$vName, $vLoc';
//         if (vName.isNotEmpty) return vName;
//         if (vLoc.isNotEmpty) return vLoc;
//       }
//     }
//     final topLoc =
//         _apiData?['location']?.toString() ??
//         _apiData?['tournament']?['location']?.toString() ??
//         '';
//     if (topLoc.isNotEmpty) return topLoc;
//     return t.location;
//   }

//   String _resolveChampionTeam() {
//     final winner = _apiData?['result']?['winner'];
//     if (winner is Map) {
//       return winner['team_name']?.toString() ??
//           winner['name']?.toString() ??
//           '';
//     }
//     if (winner is String) {
//       return winner;
//     }
//     return t.championTeam;
//   }

//   String _formatIndianCurrency(dynamic rawAmount) {
//     final numVal = num.tryParse(rawAmount?.toString() ?? '') ?? 0;
//     final intVal = numVal.round();
//     final s = intVal.toString();
//     if (s.length <= 3) return '₹$s';
//     final last3 = s.substring(s.length - 3);
//     var rest = s.substring(0, s.length - 3);
//     final parts = <String>[];
//     while (rest.length > 2) {
//       parts.insert(0, rest.substring(rest.length - 2));
//       rest = rest.substring(0, rest.length - 2);
//     }
//     if (rest.isNotEmpty) parts.insert(0, rest);
//     return '₹${parts.join(',')},$last3';
//   }

//   String _resolvePrizeAmount() {
//     final raw =
//         _apiData?['prize_amount'] ??
//         _apiData?['tournament']?['prize_amount'] ??
//         0;
//     return _formatIndianCurrency(raw);
//   }

//   String _resolvePrizeCaption() {
//     final prizes = _apiData?['prizes'];
//     if (prizes is List && prizes.isNotEmpty) {
//       final firstPrize = prizes.first;
//       if (firstPrize is Map &&
//           firstPrize['title'] != null &&
//           firstPrize['amount'] != null) {
//         return 'Total Prize Pool • ${firstPrize['title']}: ${_formatIndianCurrency(firstPrize['amount'])}';
//       }
//     }
//     final distStatus = _apiData?['prize_distribution']?['status']?.toString();
//     if (distStatus != null && distStatus.isNotEmpty) {
//       return 'Total Prize Pool • $distStatus';
//     }
//     return 'Total Prize Pool';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.authBackgroundBottom,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: AppColors.authBackgroundGradient,
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//                 child: Row(
//                   children: [
//                     GlassBackButton(onTap: () => Navigator.of(context).pop()),
//                     const SizedBox(width: 10),
//                     Text(
//                       'Tournaments Details',
//                       style: GoogleFonts.quicksand(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_isLoading)
//                 const Expanded(
//                   child: Center(child: CircularProgressIndicator()),
//                 )
//               else if (_apiData == null)
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "Failed to load details",
//                       style: GoogleFonts.quicksand(color: Colors.white),
//                     ),
//                   ),
//                 )
//               else
//                 Expanded(
//                   child: ListView(
//                     padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
//                     children: [
//                       _SummaryCard(
//                         title: _resolveTitle(),
//                         dateRange: _resolveDateRange(),
//                         location: _resolveLocation(),
//                         championTeam: _resolveChampionTeam(),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TournamentStatBox(
//                               value: _playedValue,
//                               label: 'Played',
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TournamentStatBox(
//                               value: _wonValue,
//                               label: 'Won',
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TournamentStatBox(
//                               value: _lostValue,
//                               label: 'Lost',
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TournamentStatBox(
//                               value: _finalRankValue,
//                               label: 'Final Rank',
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       _PrizeBar(
//                         amount: _resolvePrizeAmount(),
//                         caption: _resolvePrizeCaption(),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           _TabLabel(
//                             label: 'Squad Performance',
//                             selected: _tab == 0,
//                             onTap: () => setState(() => _tab = 0),
//                           ),
//                           const SizedBox(width: 22),
//                           _TabLabel(
//                             label: 'Match Results',
//                             selected: _tab == 1,
//                             onTap: () => setState(() => _tab = 1),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 14),
//                       if (_tab == 0)
//                         for (final player in _squad) ...[
//                           SquadPlayerStatCard(player: player),
//                           const SizedBox(height: 10),
//                         ]
//                       else
//                         for (final match in _matches) ...[
//                           _MatchResultCard(
//                             match: match,
//                             onView: () {
//                               MatchResultDetailsScreen.show(
//                                 context,
//                                 match: match,
//                                 tournamentTitle: _resolveTitle(),
//                                 dateRange: _resolveDateRange(),
//                               );
//                             },
//                           ),
//                           const SizedBox(height: 10),
//                         ],
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TabLabel extends StatelessWidget {
//   const _TabLabel({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.quicksand(
//               color: selected ? Colors.white : Colors.white54,
//               fontSize: 14.5,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Container(
//             height: 2.5,
//             width: selected ? 28 : 0,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFF8A1E),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SummaryCard extends StatelessWidget {
//   const _SummaryCard({
//     required this.title,
//     required this.dateRange,
//     required this.location,
//     required this.championTeam,
//   });

//   final String title;
//   final String dateRange;
//   final String location;
//   final String championTeam;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A2233),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: AppColors.glassBorder),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: GoogleFonts.quicksand(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ),
//               Text(
//                 dateRange,
//                 style: GoogleFonts.quicksand(
//                   color: Colors.white54,
//                   fontSize: 12.5,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Row(
//             children: [
//               const Icon(
//                 Icons.location_on_outlined,
//                 color: Colors.white54,
//                 size: 14,
//               ),
//               const SizedBox(width: 3),
//               Expanded(
//                 child: Text(
//                   location,
//                   style: GoogleFonts.quicksand(
//                     color: Colors.white54,
//                     fontSize: 13,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           if (championTeam.isNotEmpty) ...[
//             const SizedBox(height: 14),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.06),
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.emoji_events_rounded,
//                     color: AppColors.amberAccent,
//                     size: 22,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Champions',
//                           style: GoogleFonts.quicksand(
//                             color: const Color(0xFFFF8A1E),
//                             fontSize: 11.5,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           championTeam,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.quicksand(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _PrizeBar extends StatelessWidget {
//   const _PrizeBar({required this.amount, required this.caption});

//   final String amount;
//   final String caption;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF1B3A2A), Color(0xFF15241C)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.22)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Prize Money Earned',
//                   style: GoogleFonts.quicksand(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   caption,
//                   style: GoogleFonts.quicksand(
//                     color: Colors.white54,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(
//             Icons.emoji_events_rounded,
//             color: AppColors.amberAccent,
//             size: 20,
//           ),
//           const SizedBox(width: 6),
//           Text(
//             amount,
//             style: GoogleFonts.quicksand(
//               color: AppColors.amberAccent,
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _MatchResultCard extends StatelessWidget {
//   const _MatchResultCard({required this.match, this.onView});

//   final MyTournamentMatchResult match;
//   final VoidCallback? onView;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onView,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E2128),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         match.teamA,
//                         style: GoogleFonts.quicksand(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         match.scoreA,
//                         style: GoogleFonts.quicksand(
//                           color: Colors.white54,
//                           fontSize: 13.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   'Vs',
//                   style: GoogleFonts.quicksand(
//                     color: Colors.white38,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         match.teamB,
//                         textAlign: TextAlign.right,
//                         style: GoogleFonts.quicksand(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         match.scoreB,
//                         style: GoogleFonts.quicksand(
//                           color: Colors.white54,
//                           fontSize: 13.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     match.matchLabel,
//                     style: GoogleFonts.quicksand(
//                       color: Colors.white54,
//                       fontSize: 12.5,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'View Results',
//                       style: GoogleFonts.quicksand(
//                         color: Colors.white54,
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Icon(
//                       Icons.chevron_right_rounded,
//                       color: Colors.white54,
//                       size: 18,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
