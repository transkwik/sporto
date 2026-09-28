import 'package:flutter/material.dart';

enum WalletTxnKind { payment, sponsorship, award, tip, refund }

class WalletTransaction {
  const WalletTransaction({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.credit,
    required this.dateLabel,
    required this.status,
    required this.paymentMethod,
    required this.direction,
    required this.descriptionTitle,
    required this.descriptionLine,
    required this.tournamentLabel,
    this.accent = const Color(0xFF3ADFA0),
  });

  final String id;
  final WalletTxnKind kind;
  final String title;
  final String subtitle;
  final String amountLabel;
  final bool credit;
  final String dateLabel;
  final String status;
  final String paymentMethod;
  final String direction;
  final String descriptionTitle;
  final String descriptionLine;
  final String tournamentLabel;
  final Color accent;

  IconData get icon {
    switch (kind) {
      case WalletTxnKind.payment:
        return Icons.sports_cricket_rounded;
      case WalletTxnKind.sponsorship:
        return Icons.sports_cricket_rounded;
      case WalletTxnKind.award:
        return Icons.emoji_events_rounded;
      case WalletTxnKind.tip:
        return Icons.celebration_rounded;
      case WalletTxnKind.refund:
        return Icons.replay_rounded;
    }
  }
}

const dummyWalletBalance = '₹ 1,20,400';

const List<WalletTransaction> dummyWalletTransactions = [
  WalletTransaction(
    id: 'TXN-88213',
    kind: WalletTxnKind.payment,
    title: 'Tournament Payment',
    subtitle: 'Entry fee • Kondapur Super Over Cup',
    amountLabel: '₹800',
    credit: false,
    dateLabel: 'Aug 2, 2026',
    status: 'Completed',
    paymentMethod: 'UPI - PhonePe',
    direction: 'Paid',
    descriptionTitle: 'Kondapur Super Over Cup',
    descriptionLine: 'Entry Fee',
    tournamentLabel: 'Spoto Kondapur Super Over Cup',
    accent: Color(0xFFE85A6B),
  ),
  WalletTransaction(
    id: 'TXN-88220',
    kind: WalletTxnKind.payment,
    title: 'Tournament Payment',
    subtitle: 'Entry fee • Kondapur Super Over Cup',
    amountLabel: '₹ 3,000',
    credit: false,
    dateLabel: 'Aug 2, 2026',
    status: 'Completed',
    paymentMethod: 'UPI - PhonePe',
    direction: 'Paid',
    descriptionTitle: 'Kondapur Super Over Cup',
    descriptionLine: 'Entry Fee',
    tournamentLabel: 'Spoto Kondapur Super Over Cup',
    accent: Color(0xFFE85A6B),
  ),
  WalletTransaction(
    id: 'TXN-88214',
    kind: WalletTxnKind.sponsorship,
    title: 'Sponsorship',
    subtitle: 'Winner Prize (your split) • Kondapur Super Over Cup',
    amountLabel: '₹ 3,000',
    credit: true,
    dateLabel: 'Aug 2, 2026',
    status: 'Completed',
    paymentMethod: 'Wallet',
    direction: 'Received',
    descriptionTitle: 'Kondapur Super Over Cup',
    descriptionLine: 'Winner Prize (your split)',
    tournamentLabel: 'Spoto Kondapur Super Over Cup',
  ),
  WalletTransaction(
    id: 'TXN-88215',
    kind: WalletTxnKind.sponsorship,
    title: 'Sponsorship',
    subtitle: 'Runner-Up Bonus (your split) • Bengaluru Peninsula',
    amountLabel: '₹ 3,000',
    credit: true,
    dateLabel: 'Aug 2, 2026',
    status: 'Completed',
    paymentMethod: 'Wallet',
    direction: 'Received',
    descriptionTitle: 'Bengaluru Peninsula',
    descriptionLine: 'Runner-Up Bonus (your split)',
    tournamentLabel: 'Spoto Bengaluru Peninsula',
  ),
  WalletTransaction(
    id: 'TXN-88216',
    kind: WalletTxnKind.award,
    title: 'Match Award',
    subtitle: 'Man of the Match • Kondapur Super Over Cup',
    amountLabel: '₹ 3,000',
    credit: true,
    dateLabel: 'Aug 2, 2026',
    status: 'Completed',
    paymentMethod: 'Wallet',
    direction: 'Received',
    descriptionTitle: 'Kondapur Super Over Cup',
    descriptionLine: 'Man of the Match',
    tournamentLabel: 'Spoto Kondapur Super Over Cup',
    accent: Color(0xFFE3A93D),
  ),
  WalletTransaction(
    id: 'TXN-88217',
    kind: WalletTxnKind.tip,
    title: 'Fan Tip',
    subtitle: 'Sent to Rohit Naik • Team Thunder',
    amountLabel: '₹ 200',
    credit: false,
    dateLabel: 'Aug 2, 2026',
    status: 'Completed',
    paymentMethod: 'Wallet',
    direction: 'Paid',
    descriptionTitle: 'Rohit Naik',
    descriptionLine: 'Fan tip • Team Thunder',
    tournamentLabel: 'Team Thunder',
    accent: Color(0xFFE85A6B),
  ),
  WalletTransaction(
    id: 'TXN-88218',
    kind: WalletTxnKind.refund,
    title: 'Refund',
    subtitle: 'Cancelled registration • Ameerpet League',
    amountLabel: '₹ 200',
    credit: true,
    dateLabel: 'Aug 2, 2026',
    status: 'Completed',
    paymentMethod: 'UPI - PhonePe',
    direction: 'Received',
    descriptionTitle: 'Ameerpet League',
    descriptionLine: 'Cancelled registration',
    tournamentLabel: 'Spoto Ameerpet League',
  ),
];
