import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'prize_utils.dart';

/// Helpers for reading wallet transaction JSON (`GET user/wallet/transactions`)
/// straight from the response maps, without a model class. Everything
/// tolerates nulls, missing keys, numbers sent as strings and unknown values.
class WalletUtils {
  WalletUtils._();

  static int? id(Map t) => int.tryParse(t['id']?.toString() ?? '');

  static String reference(Map t) => 'TXN-${id(t) ?? '-'}';

  /// Raw type, e.g. "TOURNAMENT_PRIZE".
  static String type(Map t) => PrizeUtils.text(t['type']) ?? '';

  static String typeLabel(Map t) =>
      type(t).isEmpty ? '' : PrizeUtils.prettify(type(t));

  static String title(Map t) =>
      typeLabel(t).isEmpty ? 'Transaction' : typeLabel(t);

  static String description(Map t) => PrizeUtils.text(t['description']) ?? '';

  static String direction(Map t) =>
      (PrizeUtils.text(t['direction']) ?? '').toUpperCase();

  /// true = credit, false = debit, null = direction missing/unknown.
  static bool? isCredit(Map t) {
    final d = direction(t);
    if (d.contains('CREDIT') || d == 'IN') return true;
    if (d.contains('DEBIT') || d == 'OUT') return false;
    return null;
  }

  static String directionLabel(Map t) {
    final c = isCredit(t);
    if (c == null)
      return direction(t).isEmpty ? '' : PrizeUtils.prettify(direction(t));
    return c ? 'Credit' : 'Debit';
  }

  static double amount(Map t) => PrizeUtils.parseNum(t['amount']) ?? 0;

  static String currency(Map t) =>
      (PrizeUtils.text(t['currency']) ?? 'INR').toUpperCase();

  static String amountLabel(Map t) =>
      PrizeUtils.formatMoney(amount(t), currency(t));

  /// "+ ₹500" / "- ₹200"; no sign when the direction is unknown.
  static String signedAmount(Map t) {
    final c = isCredit(t);
    return c == null ? amountLabel(t) : '${c ? '+' : '-'} ${amountLabel(t)}';
  }

  static Color amountColor(Map t, {Color neutral = Colors.white}) {
    final c = isCredit(t);
    if (c == null) return neutral;
    return c ? const Color(0xFF3ADFA0) : const Color(0xFFE85A6B);
  }

  static Color accent(Map t) =>
      amountColor(t, neutral: const Color(0xFFE3A93D));

  static DateTime? date(Map t) => DateTime.tryParse(
    PrizeUtils.text(t['credited_at'] ?? t['created_at']) ?? '',
  )?.toLocal();

  static String listDate(Map t) {
    final d = date(t);
    return d == null ? '' : DateFormat('MMM d, y').format(d);
  }

  static String detailDate(Map t) {
    final d = date(t);
    return d == null ? '' : DateFormat('d MMMM y, h:mm a').format(d);
  }

  static IconData icon(Map t) {
    final ty = type(t).toUpperCase();
    if (ty.contains('PRIZE') || ty.contains('AWARD'))
      return Icons.emoji_events_rounded;
    if (ty.contains('REFUND')) return Icons.replay_rounded;
    if (ty.contains('TIP')) return Icons.celebration_rounded;
    if (ty.contains('WITHDRAW') || ty.contains('PAYOUT'))
      return Icons.account_balance_rounded;
    if (ty.contains('SPONSOR')) return Icons.handshake_rounded;
    if (ty.contains('PAYMENT') ||
        ty.contains('REGISTRATION') ||
        ty.contains('ENTRY')) {
      return Icons.sports_cricket_rounded;
    }
    return Icons.account_balance_wallet_rounded;
  }
}
