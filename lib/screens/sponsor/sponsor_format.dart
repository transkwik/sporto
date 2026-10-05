import 'package:intl/intl.dart';

final _inr = NumberFormat.decimalPattern('en_IN');

String sponsorRupees(int value) => '₹${_inr.format(value)}';

String sponsorCompact(int value) {
  if (value >= 100000) {
    final grouped = _inr.format(value);
    if (grouped.endsWith(',000')) {
      return '₹${grouped.substring(0, grouped.length - 4)} K';
    }
    return '₹${_inr.format(value ~/ 1000)} K';
  }
  if (value >= 1000) {
    final k = value / 1000;
    final body = k == k.roundToDouble() ? k.toStringAsFixed(0) : k.toStringAsFixed(1);
    return '₹${body}K';
  }
  return sponsorRupees(value);
}
