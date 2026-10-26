import 'package:flutter/material.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:sporto/core/utils/prize_utils.dart';

/// State for the prize distribution section of the payout details screen
/// (`GET user/tournaments/{id}/prize-distribution`). Works on raw maps.
class PrizeDistributionProvider extends ChangeNotifier {
  Map<String, dynamic>? _data;
  bool _isLoading = false;
  String? _error;
  int? _tournamentId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _data != null;

  /// Raw status from the API, e.g. "NOT_STARTED".
  String get statusRaw => PrizeUtils.text(_data?['status']) ?? '';

  String get statusLabel => statusRaw.isEmpty ? '' : PrizeUtils.prettify(statusRaw);

  List<Map<String, dynamic>> get teamPrizes => _list('team_prizes');

  List<Map<String, dynamic>> get individualAwards => _list('individual_awards');

  List<Map<String, dynamic>> _list(String key) {
    final v = _data?[key];
    if (v is! List) return const [];
    return [
      for (final e in v)
        if (e is Map) Map<String, dynamic>.from(e),
    ];
  }

  /// Clears data left from another tournament and shows the loader.
  void reset() {
    _data = null;
    _error = null;
    _tournamentId = null;
    _isLoading = true;
  }

  /// With [refresh] the current data stays visible (pull-to-refresh).
  Future<void> fetchDistribution(int tournamentId, {bool refresh = false}) async {
    _tournamentId = tournamentId;
    if (!refresh) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    }

    Map<String, dynamic>? data;
    String? error;
    try {
      final res = await UserApis().getPrizeDistribution(tournamentId);
      if (res is! Map) {
        error = 'Unexpected response from server.';
      } else if (res['session_expired'] == true) {
        error = 'Your session has expired. Please log in again.';
      } else if (res['error'] != null) {
        error = res['error'].toString();
      } else if (res['success'] != true) {
        error = res['message']?.toString() ?? 'Could not load prize distribution.';
      } else if (res['data'] is! Map) {
        error = 'Prize distribution is not available.';
      } else {
        data = Map<String, dynamic>.from(res['data'] as Map);
      }
    } catch (_) {
      error = 'Something went wrong. Please try again.';
    }

    // The user may have opened another tournament meanwhile.
    if (_tournamentId != tournamentId) return;

    _isLoading = false;
    if (data != null) {
      _data = data;
      _error = null;
    } else if (_data == null || !refresh) {
      _error = error;
    }
    notifyListeners();
  }
}
