import '../core/utils/prize_utils.dart';

/// Response of `GET user/tournaments/{id}/prizes`. Parsed defensively: any
/// field may be null, missing, or a number sent as a string.
class TournamentPrizes {
  const TournamentPrizes({
    required this.tournamentId,
    required this.tournamentName,
    required this.totalPool,
    required this.currency,
    required this.prizes,
  });

  final int tournamentId;
  final String tournamentName;
  final double totalPool;
  final String currency;
  final List<TournamentPrizeItem> prizes;

  String get formattedPool => PrizeUtils.formatMoney(totalPool, currency);

  factory TournamentPrizes.fromJson(Map<String, dynamic> data, {required int fallbackId}) {
    final t = data['tournament'];
    final items = <TournamentPrizeItem>[];
    final raw = data['prizes'];
    if (raw is List) {
      for (final p in raw) {
        if (p is Map) items.add(TournamentPrizeItem.fromJson(Map<String, dynamic>.from(p)));
      }
    }
    items.sort((a, b) {
      final byOrder = a.displayOrder.compareTo(b.displayOrder);
      return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
    });

    final pool = _num(data['total_pool']);
    final currency = items.isNotEmpty ? items.first.currency : 'INR';
    return TournamentPrizes(
      tournamentId: int.tryParse((t is Map ? t['id'] : null)?.toString() ?? '') ?? fallbackId,
      tournamentName: _text(t is Map ? t['name'] : null) ?? 'Tournament',
      // Fall back to the sum of prizes when the pool is not provided.
      totalPool: pool ?? items.fold<double>(0, (s, p) => s + p.amount),
      currency: currency,
      prizes: items,
    );
  }
}

class TournamentPrizeItem {
  const TournamentPrizeItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.currency,
    required this.recipientScope,
    required this.distributionMode,
    required this.amountMode,
    required this.resolver,
    required this.tiePolicy,
    required this.status,
    required this.displayOrder,
  });

  final int id;
  final String title;
  final String category;
  final double amount;
  final String currency;
  final String recipientScope;
  final String distributionMode;
  final String amountMode;
  final String resolver;
  final String tiePolicy;
  final int status;
  final int displayOrder;

  /// Server sends `status: 1` for active prizes; other values are shown as inactive.
  bool get isActive => status == 1;

  String get formattedAmount => PrizeUtils.formatMoney(amount, currency);

  /// Label/value rows describing how the prize is awarded; empty values are skipped.
  List<(String, String)> get details => [
        ('Recipient', recipientScope),
        ('Distribution', distributionMode),
        ('Amount type', amountMode),
        ('Selected by', resolver),
        ('If tied', tiePolicy),
      ].where((e) => e.$2.isNotEmpty).toList();

  factory TournamentPrizeItem.fromJson(Map<String, dynamic> json) {
    // Prefer the server label, fall back to a prettified raw code.
    String label(String key) {
      final l = _text(json['${key}_label']);
      if (l != null) return l;
      final raw = _text(json[key]);
      return raw == null ? '' : PrizeUtils.prettify(raw);
    }

    final category = _text(json['category']) ?? '';
    return TournamentPrizeItem(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: _text(json['title']) ??
          (category.isNotEmpty ? PrizeUtils.prettify(category) : 'Prize'),
      category: category,
      amount: _num(json['amount']) ?? 0,
      currency: (_text(json['currency']) ?? 'INR').toUpperCase(),
      recipientScope: label('recipient_scope'),
      distributionMode: label('distribution_mode'),
      amountMode: label('amount_mode'),
      resolver: label('resolver').isNotEmpty ? label('resolver') : label('resolver_code'),
      tiePolicy: label('tie_policy'),
      status: int.tryParse(json['status']?.toString() ?? '') ?? 1,
      displayOrder: int.tryParse(json['display_order']?.toString() ?? '') ?? 0,
    );
  }
}

String? _text(dynamic v) {
  final s = v?.toString().trim();
  return (s == null || s.isEmpty || s == 'null') ? null : s;
}

double? _num(dynamic v) => double.tryParse(v?.toString().replaceAll(',', '') ?? '');
