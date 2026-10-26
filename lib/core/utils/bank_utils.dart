import 'prize_utils.dart';

/// Helpers for reading bank destination JSON (`user/bank/...`) straight from
/// the response maps, without a model class. Every getter tolerates nulls and
/// missing keys.
class BankUtils {
  BankUtils._();

  static bool _bool(dynamic v) {
    if (v is bool) return v;
    final s = v?.toString().trim().toLowerCase();
    return s == '1' || s == 'true';
  }

  static int? id(Map a) => int.tryParse(a['id']?.toString() ?? '');

  /// Raw type, e.g. "BANK".
  static String type(Map a) => PrizeUtils.text(a['type']) ?? 'BANK';

  static String typeLabel(Map a) => type(a).toUpperCase() == 'BANK'
      ? 'Bank Account'
      : PrizeUtils.prettify(type(a));

  /// Bank name when the API provides one (`bank_name`, `bank`, or the same
  /// keys inside `details`), otherwise null.
  static String? bankName(Map a) {
    final details = a['details'];
    for (final key in const ['bank_name', 'bank']) {
      final v =
          PrizeUtils.text(a[key]) ??
          (details is Map ? PrizeUtils.text(details[key]) : null);
      if (v != null) return v;
    }
    return null;
  }

  /// Account holder when the API provides one (`account_holder`, also inside
  /// `details`), otherwise null.
  static String? holderName(Map a) {
    final details = a['details'];
    return PrizeUtils.text(a['account_holder']) ??
        (details is Map ? PrizeUtils.text(details['account_holder']) : null);
  }

  /// Short label for buttons: "SBI Bank" -> "SBI"; falls back to "A/c 9012",
  /// or null when nothing is known.
  static String? shortBankLabel(Map a) {
    final name = bankName(a);
    if (name != null) {
      final short = name.replaceFirst(
        RegExp(r'\s+bank$', caseSensitive: false),
        '',
      );
      return short.trim().isEmpty ? name : short.trim();
    }
    final l = last4(a);
    return l == null ? null : 'A/c $l';
  }

  /// e.g. "Bank account ending 9012".
  static String summary(Map a) => PrizeUtils.text(a['summary']) ?? typeLabel(a);

  /// A missing `is_active` counts as active.
  static bool isActive(Map a) =>
      !a.containsKey('is_active') || a['is_active'] == null
      ? true
      : _bool(a['is_active']);

  static bool isDefault(Map a) => _bool(a['is_default']);

  /// Trailing digits of the summary (up to 4), or null if there are none.
  static String? last4(Map a) {
    final m = RegExp(r'(\d{2,})\s*$').firstMatch(summary(a));
    if (m == null) return null;
    final digits = m.group(1)!;
    return digits.length > 4 ? digits.substring(digits.length - 4) : digits;
  }

  /// "XXXX XXXX 9012", or the plain summary when no digits are available.
  static String maskedNumber(Map a) {
    final l = last4(a);
    return l == null ? summary(a) : 'XXXX XXXX $l';
  }

  /// First readable message from a Laravel-style `errors` map.
  static String? firstValidationMessage(dynamic errors) {
    if (errors is! Map) return null;
    final messages = <String>[];
    for (final v in errors.values) {
      if (v is List) {
        for (final m in v) {
          final t = PrizeUtils.text(m);
          if (t != null) messages.add(t);
        }
      } else {
        final t = PrizeUtils.text(v);
        if (t != null) messages.add(t);
      }
    }
    return messages.isEmpty ? null : messages.join('\n');
  }
}
