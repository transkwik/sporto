import 'package:flutter/material.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:sporto/core/utils/prize_utils.dart';

/// State for the My Prizes screen. Works on the raw API maps (no model).
class MyPrizesProvider extends ChangeNotifier {
  static const int _perPage = 50;
  static const int _maxPages = 20;

  List<Map<String, dynamic>> _prizes = [];
  List<Map<String, dynamic>> get prizes => _prizes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// 0 = all, 1 = pending, 2 = processing, 3 = credited, 4 = failed.
  int _filter = 0;
  int get filter => _filter;

  void setFilter(int value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }

  /// Clears previous data (e.g. from another login) and loads from page 1.
  void reset() {
    _prizes = [];
    _error = null;
    _filter = 0;
    _isLoading = true;
  }

  /// Loads every page so the totals above the list are complete.
  /// With [refresh] the current list stays visible (pull-to-refresh).
  Future<void> fetchMyPrizes({bool refresh = false}) async {
    if (!refresh) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    final all = <Map<String, dynamic>>[];
    String? error;
    int page = 1;
    int lastPage = 1;

    try {
      do {
        final res = await UserApis().getMyPrizes(page, _perPage);
        if (res is! Map) {
          error = 'Unexpected response from server.';
          break;
        }
        if (res['session_expired'] == true) {
          error = 'Your session has expired. Please log in again.';
          break;
        }
        if (res['error'] != null) {
          error = res['error'].toString();
          break;
        }
        if (res['success'] != true) {
          error = res['message']?.toString() ?? 'Could not load your prizes.';
          break;
        }

        final data = res['data'];
        if (data is List) {
          for (final item in data) {
            if (item is Map) all.add(Map<String, dynamic>.from(item));
          }
        }

        final meta = res['meta'];
        lastPage = meta is Map ? (int.tryParse(meta['last_page']?.toString() ?? '') ?? 1) : 1;
        page++;
      } while (page <= lastPage && page <= _maxPages);
    } catch (_) {
      error = 'Something went wrong. Please try again.';
    }

    _isLoading = false;
    if (error != null && all.isEmpty) {
      // On a failed refresh keep the old list, otherwise show the error.
      if (!refresh || _prizes.isEmpty) _error = error;
    } else {
      // Keep whatever loaded if a later page failed.
      _error = null;
      _prizes = all;
    }
    notifyListeners();
  }

  // ── Derived values ─────────────────────────────────────────────────────

  int count(PayoutStatus s) => _prizes.where((p) => PrizeUtils.status(p) == s).length;

  int get teamPrizeCount => _prizes.where((p) => !PrizeUtils.isIndividual(p)).length;

  int get individualCount => _prizes.where(PrizeUtils.isIndividual).length;

  String get currency => _prizes.isNotEmpty ? PrizeUtils.currency(_prizes.first) : 'INR';

  /// Sums only payouts in the main currency so mixed currencies never add up.
  double _sum(bool Function(PayoutStatus) test) => _prizes
      .where((p) => PrizeUtils.currency(p) == currency && test(PrizeUtils.status(p)))
      .fold<double>(0, (a, p) => a + PrizeUtils.amount(p));

  double get creditedAmount => _sum((s) => s == PayoutStatus.credited);

  double get pendingAmount =>
      _sum((s) => s == PayoutStatus.pending || s == PayoutStatus.processing);

  List<Map<String, dynamic>> get visible {
    PayoutStatus? only = switch (_filter) {
      1 => PayoutStatus.pending,
      2 => PayoutStatus.processing,
      3 => PayoutStatus.credited,
      4 => PayoutStatus.failed,
      _ => null,
    };
    if (only == null) return _prizes;
    return _prizes.where((p) => PrizeUtils.status(p) == only).toList();
  }
}
