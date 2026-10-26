import 'package:flutter/material.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:sporto/core/utils/bank_utils.dart';
import 'package:sporto/core/utils/prize_utils.dart';

/// Saved payout bank accounts (`user/bank/...`). Works on the raw API maps,
/// no model. Mutating calls return `null` on success or a message to show.
class BankProvider extends ChangeNotifier {
  static const String _type = 'BANK';

  List<Map<String, dynamic>> _accounts = [];
  bool _isLoading = false;
  bool _loaded = false;
  String? _error;
  bool _isSaving = false;
  final Set<int> _busyIds = {};
  int? _selectedId;

  List<Map<String, dynamic>> get accounts => _accounts;
  bool get isLoading => _isLoading;
  bool get hasLoaded => _loaded;
  String? get error => _error;

  /// True while an add/update request is in flight.
  bool get isSaving => _isSaving;

  /// True while set-default/delete is running for this account.
  bool isBusy(int? id) => id != null && _busyIds.contains(id);

  /// The account to show/use: the one picked in the app, else the default,
  /// else the first one.
  Map<String, dynamic>? get selected {
    if (_accounts.isEmpty) return null;
    for (final a in _accounts) {
      if (BankUtils.id(a) == _selectedId) return a;
    }
    for (final a in _accounts) {
      if (BankUtils.isDefault(a)) return a;
    }
    return _accounts.first;
  }

  Map<String, dynamic>? byId(int? id) {
    if (id == null) return null;
    for (final a in _accounts) {
      if (BankUtils.id(a) == id) return a;
    }
    return null;
  }

  void select(int? id) {
    if (_selectedId == id) return;
    _selectedId = id;
    notifyListeners();
  }

  /// Clears data left from a previous login and shows the loader.
  void reset() {
    _accounts = [];
    _error = null;
    _selectedId = null;
    _loaded = false;
    _isSaving = false;
    _busyIds.clear();
    _isLoading = true;
  }

  // ── List ───────────────────────────────────────────────────────────────

  /// With [refresh] the current list stays visible (pull-to-refresh).
  Future<void> fetchBanks({bool refresh = false}) async {
    if (!refresh) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    List<Map<String, dynamic>>? list;
    String? error;
    try {
      final res = await UserApis().getBankList(type: _type);
      error = _responseError(res, 'Could not load bank accounts.');
      if (error == null) {
        final data = res['data'];
        list = [
          if (data is List)
            for (final e in data)
              if (e is Map) Map<String, dynamic>.from(e),
        ];
      }
    } catch (_) {
      error = 'Something went wrong. Please try again.';
    }

    _isLoading = false;
    if (list != null) {
      _accounts = list.where(BankUtils.isActive).toList();
      _loaded = true;
      _error = null;
    } else if (!refresh || _accounts.isEmpty) {
      _error = error;
    }
    notifyListeners();
  }

  // ── Mutations ──────────────────────────────────────────────────────────

  Map<String, dynamic> _body(
    String bankName,
    String accountNumber,
    String holder,
    String ifsc,
  ) => {
    'type': _type,
    'details': {
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_holder': holder,
      'ifsc': ifsc,
    },
  };

  Future<String?> addBank({
    required String bankName,
    required String accountNumber,
    required String accountHolder,
    required String ifsc,
  }) async {
    if (_isSaving) return 'Please wait, another request is in progress.';
    _isSaving = true;
    notifyListeners();
    try {
      final res = await UserApis().addBankDetails(
        _body(bankName, accountNumber, accountHolder, ifsc),
      );
      final error = _responseError(res, 'Could not add bank account.');
      if (error != null) return error;
      await _applyChange(res['data']);
      return null;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> updateBank(
    int id, {
    required String bankName,
    required String accountNumber,
    required String accountHolder,
    required String ifsc,
  }) async {
    if (_isSaving) return 'Please wait, another request is in progress.';
    _isSaving = true;
    notifyListeners();
    try {
      final res = await UserApis().updateBankDetails(
        id,
        _body(bankName, accountNumber, accountHolder, ifsc),
      );
      final error = _responseError(res, 'Could not update bank account.');
      if (error != null) return error;
      await _applyChange(res['data'], fallbackId: id);
      return null;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> setDefault(int id) async {
    if (isBusy(id)) return null;
    _busyIds.add(id);
    notifyListeners();
    try {
      final res = await UserApis().setDefaultBank(id);
      final error = _responseError(res, 'Could not set default bank account.');
      if (error != null) return error;
      _selectedId = id;

      final data = res['data'];
      if (data is Map) {
        await _applyChange(data, forceDefaultId: id);
      } else {
        // No record returned: update the flags locally, then re-sync below.
        _accounts = [
          for (final a in _accounts)
            {...a, 'is_default': BankUtils.id(a) == id},
        ];
        await _resync();
      }
      return null;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    } finally {
      _busyIds.remove(id);
      notifyListeners();
    }
  }

  Future<String?> deleteBank(int id) async {
    if (isBusy(id)) return null;
    _busyIds.add(id);
    notifyListeners();
    try {
      final res = await UserApis().deleteBankDetails(id);
      final error = _responseError(res, 'Could not delete bank account.');
      if (error != null) return error;

      // The API only deactivates the record, so drop it from the list either way.
      _accounts = _accounts.where((a) => BankUtils.id(a) != id).toList();
      if (_selectedId == id) _selectedId = null;
      await _resync();
      return null;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    } finally {
      _busyIds.remove(id);
      notifyListeners();
    }
  }

  // ── Internals ──────────────────────────────────────────────────────────

  /// Merges a record returned by the API into the list (replace or add),
  /// removes inactive ones, and re-syncs the list when no record came back.
  Future<void> _applyChange(
    dynamic data, {
    int? fallbackId,
    int? forceDefaultId,
  }) async {
    if (data is! Map) {
      await _resync();
      return;
    }
    final item = Map<String, dynamic>.from(data);
    if (forceDefaultId != null && BankUtils.id(item) == forceDefaultId) {
      item['is_default'] = true;
    }
    final id = BankUtils.id(item) ?? fallbackId;
    final index = _accounts.indexWhere((a) => BankUtils.id(a) == id);

    final next = [..._accounts];
    if (index >= 0) {
      next[index] = item;
    } else {
      next.insert(0, item);
    }

    // Only one default at a time.
    final becameDefault = BankUtils.isDefault(item);
    _accounts = [
      for (final a in next)
        if (BankUtils.isActive(a))
          becameDefault && BankUtils.id(a) != id && BankUtils.isDefault(a)
              ? {...a, 'is_default': false}
              : a,
    ];
    _loaded = true;
    if (id != null && BankUtils.isActive(item) && index < 0) _selectedId = id;
    notifyListeners();
    await _resync();
  }

  /// Quietly reloads the list so it matches the server.
  Future<void> _resync() async {
    try {
      final res = await UserApis().getBankList(type: _type);
      if (_responseError(res, '') != null) return;
      final data = res['data'];
      if (data is! List) return;
      _accounts = [
        for (final e in data)
          if (e is Map && BankUtils.isActive(e)) Map<String, dynamic>.from(e),
      ];
      _loaded = true;
      notifyListeners();
    } catch (_) {
      // Keep the locally updated list.
    }
  }

  /// Returns a message when the response is not a success, otherwise null.
  /// Prefers specific validation messages over the generic one.
  static String? _responseError(dynamic res, String fallback) {
    if (res is! Map) return 'Unexpected response from server.';
    if (res['session_expired'] == true)
      return 'Your session has expired. Please log in again.';
    if (res['error'] != null) return res['error'].toString();
    if (res['success'] != true) {
      return BankUtils.firstValidationMessage(res['errors']) ??
          PrizeUtils.text(res['message']) ??
          fallback;
    }
    return null;
  }
}
