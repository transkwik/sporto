import 'package:flutter/material.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:sporto/core/utils/prize_utils.dart';

/// Wallet balance (`GET user/wallet`) and transactions
/// (`GET user/wallet/transactions`). Works on raw maps, no model.
class WalletProvider extends ChangeNotifier {
  static const int _perPage = 50;
  static const int _maxPages = 20;

  double? _balance;
  String _currency = 'INR';
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get transactions => _transactions;

  /// "₹2,000", or "—" while the balance is unknown.
  String get balanceLabel =>
      _balance == null ? '—' : PrizeUtils.formatMoney(_balance!, _currency);

  /// Clears data left from a previous login and shows the loader.
  void reset() {
    _balance = null;
    _currency = 'INR';
    _transactions = [];
    _error = null;
    _isLoading = true;
  }

  /// Loads balance and every page of transactions. With [refresh] the current
  /// content stays visible (pull-to-refresh).
  Future<void> fetchWallet({bool refresh = false}) async {
    if (!refresh) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    final results = await Future.wait([_loadBalance(), _loadTransactions()]);
    final balanceError = results[0];
    final txnError = results[1];

    _isLoading = false;
    if (balanceError != null && txnError != null) {
      // Everything failed: keep old content on a refresh, otherwise show the error.
      if (!refresh || (_balance == null && _transactions.isEmpty)) _error = txnError;
    } else {
      _error = null;
    }
    notifyListeners();
  }

  /// Returns an error message, or null on success.
  Future<String?> _loadBalance() async {
    try {
      final res = await UserApis().getWallet();
      final error = _responseError(res, 'Could not load wallet balance.');
      if (error != null) return error;
      final data = res['data'];
      final value = data is Map ? PrizeUtils.parseNum(data['balance']) : null;
      if (value == null) return 'Wallet balance is not available.';
      _balance = value;
      _currency = (PrizeUtils.text(data['currency']) ?? 'INR').toUpperCase();
      return null;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  Future<String?> _loadTransactions() async {
    final all = <Map<String, dynamic>>[];
    String? error;
    int page = 1;
    int lastPage = 1;

    try {
      do {
        final res = await UserApis().getWalletTransactions(page, _perPage);
        error = _responseError(res, 'Could not load transactions.');
        if (error != null) break;

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

    // Keep whatever loaded if a later page failed.
    if (error == null || all.isNotEmpty) {
      _transactions = all;
      return null;
    }
    return error;
  }

  static String? _responseError(dynamic res, String fallback) {
    if (res is! Map) return 'Unexpected response from server.';
    if (res['session_expired'] == true) return 'Your session has expired. Please log in again.';
    if (res['error'] != null) return res['error'].toString();
    if (res['success'] != true) return res['message']?.toString() ?? fallback;
    return null;
  }
}
