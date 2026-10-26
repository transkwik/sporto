import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PayoutStatus { pending, processing, credited, failed }

/// Helpers for reading prize payout JSON (`GET user/prizes/my-prizes`) straight
/// from the response maps, without a model class. Every getter tolerates
/// nulls, missing keys, numbers sent as strings and unknown values.
class PrizeUtils {
  PrizeUtils._();

  /// Trimmed string, or null when the value is null/empty/"null".
  static String? text(dynamic v) {
    final s = v?.toString().trim();
    return (s == null || s.isEmpty || s == 'null') ? null : s;
  }

  static Map<String, dynamic> _map(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : const <String, dynamic>{};

  static double? parseNum(dynamic v) =>
      double.tryParse(v?.toString().replaceAll(',', '') ?? '');

  /// "INDIVIDUAL_AWARD" -> "Individual Award".
  static String prettify(String raw) {
    final words = raw
        .replaceAll(RegExp(r'[_\-]+'), ' ')
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty);
    return words
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  static final NumberFormat _inr = NumberFormat.decimalPattern('en_IN')
    ..maximumFractionDigits = 2;

  /// "₹1,500" / "₹100.50" / "USD 20".
  static String formatMoney(double value, String currency) {
    final number = _inr.format(value);
    return currency == 'INR' ? '₹$number' : '$currency $number';
  }

  // ── Payout fields ──────────────────────────────────────────────────────

  static int id(Map p) => int.tryParse(p['payout_id']?.toString() ?? '') ?? 0;

  static int? tournamentId(Map p) {
    final t = p['tournament'];
    return int.tryParse(
      (t is Map ? t['id'] : p['tournament_id'])?.toString() ?? '',
    );
  }

  static String tournamentName(Map p) {
    final t = p['tournament'];
    return text(t is Map ? t['name'] : null) ?? 'Tournament';
  }

  static String category(Map p) => text(_map(p['prize'])['category']) ?? '';

  static int? prizeId(Map p) =>
      int.tryParse(_map(p['prize'])['id']?.toString() ?? '');

  static String title(Map p) {
    final t = text(_map(p['prize'])['title']);
    if (t != null) return t;
    final c = category(p);
    return c.isNotEmpty ? prettify(c) : 'Prize';
  }

  static String categoryLabel(Map p) =>
      category(p).isEmpty ? '' : prettify(category(p));

  static String type(Map p) => text(p['type']) ?? '';

  static String typeLabel(Map p) => type(p).isEmpty ? '' : prettify(type(p));

  static bool isIndividual(Map p) =>
      type(p).toUpperCase().contains('INDIVIDUAL');

  static String? teamName(Map p) {
    final t = p['team'];
    return t is Map ? text(t['name'] ?? t['team_name']) : text(t);
  }

  static double amount(Map p) => parseNum(p['amount']) ?? 0;

  static String currency(Map p) => (text(p['currency']) ?? 'INR').toUpperCase();

  static String formatAmount(Map p) => formatMoney(amount(p), currency(p));

  static String reference(Map p) => 'PAYOUT-${id(p)}';

  // ── Status ─────────────────────────────────────────────────────────────

  static String statusRaw(Map p) => text(p['status']) ?? '';

  static PayoutStatus status(Map p) {
    switch (statusRaw(p).toUpperCase()) {
      case 'CREDITED':
      case 'PAID':
      case 'SUCCESS':
      case 'COMPLETED':
        return PayoutStatus.credited;
      case 'FAILED':
      case 'REJECTED':
      case 'CANCELLED':
        return PayoutStatus.failed;
      case 'PROCESSING':
        return PayoutStatus.processing;
      default:
        // PENDING and anything unrecognised: not paid yet.
        return PayoutStatus.pending;
    }
  }

  static String statusLabel(Map p) {
    final raw = statusRaw(p);
    return switch (status(p)) {
      PayoutStatus.pending =>
        raw.isEmpty || raw.toUpperCase() == 'PENDING'
            ? 'Pending'
            : prettify(raw),
      PayoutStatus.processing => 'Processing',
      PayoutStatus.credited => 'Credited',
      PayoutStatus.failed => 'Failed',
    };
  }

  // ── Dates ──────────────────────────────────────────────────────────────

  static DateTime? creditedAt(Map p) =>
      DateTime.tryParse(text(p['credited_at']) ?? '')?.toLocal();

  static String listDate(Map p) {
    final d = creditedAt(p);
    return d == null ? '' : DateFormat('MMM d, y').format(d);
  }

  static String detailDate(Map p) {
    final d = creditedAt(p);
    return d == null ? '' : DateFormat('d MMMM y, h:mm a').format(d);
  }

  // ── Icon ───────────────────────────────────────────────────────────────

  static IconData icon(Map p) {
    final t = title(p).toLowerCase();
    if (t.contains('runner')) return Icons.workspace_premium_rounded;
    if (t.contains('winner') ||
        t.contains('champion') ||
        t.contains('winning')) {
      return Icons.emoji_events_rounded;
    }
    if (t.contains('best') ||
        t.contains('player') ||
        t.contains('mvp') ||
        t.contains('man of')) {
      return Icons.star_rounded;
    }
    return isIndividual(p)
        ? Icons.military_tech_rounded
        : Icons.emoji_events_rounded;
  }
}
