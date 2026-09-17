import 'package:flutter/material.dart';

enum InboxCategory { matches, teams, tournaments, payments }

enum InboxKind {
  teamInvite,
  matchStarting,
  youWon,
  tournamentUpdate,
  teamAccepted,
  payment,
  matchReminder,
  tournamentEnded,
}

class InboxNotification {
  const InboxNotification({
    required this.id,
    required this.kind,
    required this.category,
    required this.title,
    required this.body,
    required this.timeLabel,
    this.meta,
    this.ctaLabel,
    this.teamA,
    this.teamB,
    this.scoreA,
    this.scoreB,
    this.amountLine,
  });

  final String id;
  final InboxKind kind;
  final InboxCategory category;
  final String title;
  final String body;
  final String timeLabel;
  final String? meta;
  final String? ctaLabel;
  final String? teamA;
  final String? teamB;
  final String? scoreA;
  final String? scoreB;
  final String? amountLine;
}

const List<InboxNotification> dummyInboxNotifications = [
  InboxNotification(
    id: 'invite-1',
    kind: InboxKind.teamInvite,
    category: InboxCategory.teams,
    title: 'Team Invitation',
    body: 'Thunder Titans invited you to join their team.',
    timeLabel: '2m ago',
    meta: 'Cricket  •  Hyderabad Super Cup',
  ),
  InboxNotification(
    id: 'start-1',
    kind: InboxKind.matchStarting,
    category: InboxCategory.matches,
    title: 'Match starts in 30 minutes',
    body: 'Thunder Titans invited you to join their team.',
    timeLabel: '30 min ago',
    teamA: 'Thunder Titans',
    teamB: 'Royal Smashers',
    meta: 'Cricket  •  Hyderabad Super Cup  •  Round of 64',
    ctaLabel: 'View Match',
  ),
  InboxNotification(
    id: 'won-1',
    kind: InboxKind.youWon,
    category: InboxCategory.matches,
    title: 'You won!',
    body: 'Thunder Titans defeated Delhi Warriors.',
    timeLabel: '30 min ago',
    scoreA: '162/6',
    scoreB: '148/9',
    meta: 'Cricket  •  Hyderabad Super Cup  •  Quarter Final',
    ctaLabel: 'View Result',
  ),
  InboxNotification(
    id: 'tour-1',
    kind: InboxKind.tournamentUpdate,
    category: InboxCategory.tournaments,
    title: 'Tournament Update',
    body: 'The Hyderabad Super Cup schedule has been updated.\nYour next match is now scheduled for:',
    timeLabel: '4 hours ago',
    meta: 'Cricket  •  Tomorrow 10:00 AM  •  Ground B',
    ctaLabel: 'View Schedule',
  ),
  InboxNotification(
    id: 'accepted-1',
    kind: InboxKind.teamAccepted,
    category: InboxCategory.teams,
    title: 'Team Request Accepted',
    body: 'Your request to join Thunder Titans has been accepted.\nYou are now part of the team.',
    timeLabel: 'Yesterday',
    ctaLabel: 'View Team',
  ),
  InboxNotification(
    id: 'pay-1',
    kind: InboxKind.payment,
    category: InboxCategory.payments,
    title: 'Payment Confirmation',
    body: 'Your registration for Hyderabad Super Cup is confirmed.',
    timeLabel: 'Yesterday',
    amountLine: '₹1,500 paid  •  Transaction successful',
    ctaLabel: 'View Team',
  ),
  InboxNotification(
    id: 'remind-1',
    kind: InboxKind.matchReminder,
    category: InboxCategory.matches,
    title: 'Match Reminder',
    body: 'Your match is tomorrow.',
    timeLabel: 'Yesterday',
    teamA: 'Thunder Titans',
    teamB: 'Royal Smashers',
    meta: 'Cricket  •  Tomorrow 10:00 AM  •  Ground B',
    ctaLabel: 'View Match',
  ),
  InboxNotification(
    id: 'ended-1',
    kind: InboxKind.tournamentEnded,
    category: InboxCategory.tournaments,
    title: 'Hyderabad Super Cup has ended',
    body: 'Congratulations!\nThunder Titans finished as Champions.',
    timeLabel: '2 days ago',
    meta: 'Cricket',
    ctaLabel: 'View Tournament Results',
  ),
];
