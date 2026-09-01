import 'package:flutter/material.dart';
import 'package:sporto/core/apiServices/user_api.dart';
import 'package:sporto/core/apiServices/api_constants.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _sportsList = [];
  List<dynamic> get sportsList => _sportsList;

  List<dynamic> _tournamentsList = [];
  List<dynamic> get tournamentsList => _tournamentsList;

  int _currentTournamentPage = 1;
  int _lastTournamentPage = 1;
  bool _isFetchingMoreTournaments = false;
  bool get isFetchingMoreTournaments => _isFetchingMoreTournaments;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setFetchingMoreTournaments(bool value) {
    _isFetchingMoreTournaments = value;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchSports() async {
    _setLoading(true);
    clearMessages();

    try {
      final response = await UserApis().getSports();

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        _sportsList = response['data'] ?? [];
      } else {
        _errorMessage = response?['message'] ?? 'Failed to fetch sports.';
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
    } finally {
      _setLoading(false);
    }
  }

  String? _selectedSportId;
  String? get selectedSportId => _selectedSportId;

  void setSelectedSportId(String? id) {
    _selectedSportId = id;
    notifyListeners();
  }

  Future<void> fetchTournaments({
    bool isRefresh = false,
    double? lat,
    double? lng,
    String? sportId,
  }) async {
    if (sportId != null) {
      _selectedSportId = sportId;
    }

    if (isRefresh) {
      _currentTournamentPage = 1;
      _tournamentsList.clear();
      _setLoading(true);
    } else {
      if (_currentTournamentPage > _lastTournamentPage ||
          _isFetchingMoreTournaments) {
        return;
      }
      _setFetchingMoreTournaments(true);
    }

    clearMessages();

    try {
      final params = {
        'page': _currentTournamentPage,
        'per_page': 15,
        'search': '',
        'sport_id': _selectedSportId ?? '',
        'latitude': ENABLE_LOCATION_API_PARAMS ? (lat ?? '') : '',
        'longitude': ENABLE_LOCATION_API_PARAMS ? (lng ?? '') : '',
      };

      final response = await UserApis().getTournaments(params);

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        final data = response['data'];
        if (data != null) {
          final List<dynamic> newData = data['data'] ?? [];
          if (isRefresh) {
            _tournamentsList = newData;
          } else {
            _tournamentsList.addAll(newData);
          }
          _currentTournamentPage++;
          _lastTournamentPage = data['last_page'] ?? 1;
        }
      } else {
        _errorMessage = response?['message'] ?? 'Failed to fetch tournaments.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      if (isRefresh) {
        _setLoading(false);
      } else {
        _setFetchingMoreTournaments(false);
      }
    }
  }

  // --- Tournament Details ---
  bool _isFetchingDetail = false;
  bool get isFetchingDetail => _isFetchingDetail;

  Map<String, dynamic>? _tournamentDetail;
  Map<String, dynamic>? get tournamentDetail => _tournamentDetail;

  void _setFetchingDetail(bool value) {
    _isFetchingDetail = value;
    notifyListeners();
  }

  Future<void> fetchTournamentDetail(int id) async {
    _setFetchingDetail(true);
    clearMessages();
    _tournamentDetail = null;

    try {
      final response = await UserApis().getTournamentDetail(id);

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        final data = response['data'];
        if (data != null) {
          _tournamentDetail = data;
        }
      } else {
        _errorMessage =
            response?['message'] ?? 'Failed to fetch tournament details.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _setFetchingDetail(false);
    }
  }

  // --- Teams ---
  bool _isFetchingTeams = false;
  bool get isFetchingTeams => _isFetchingTeams;

  List<Map<String, dynamic>> _teamsList = [];
  List<Map<String, dynamic>> get teamsList => _teamsList;

  void _setFetchingTeams(bool value) {
    _isFetchingTeams = value;
    notifyListeners();
  }

  Future<void> fetchTeams() async {
    _setFetchingTeams(true);
    clearMessages();
    _teamsList = [];

    try {
      final response = await UserApis().getTeams();

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        final data = response['data'] as List<dynamic>?;
        if (data != null) {
          _teamsList = data.map((e) => e as Map<String, dynamic>).toList();
        }
      } else {
        _errorMessage = response?['message'] ?? 'Failed to fetch teams.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _setFetchingTeams(false);
    }
  }

  bool _isCreatingTeam = false;
  bool get isCreatingTeam => _isCreatingTeam;

  Future<bool> createTeam(Map<String, dynamic> params) async {
    _isCreatingTeam = true;
    notifyListeners();
    clearMessages();

    try {
      final response = await UserApis().createTeam(params);

      if (response != null && response['success'] == true) {
        // Automatically fetch the latest teams after creation
        await fetchTeams();
        return true;
      } else {
        _errorMessage = response?['message'] ?? 'Failed to create team.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      return false;
    } finally {
      _isCreatingTeam = false;
      notifyListeners();
    }
  }

  bool _isUpdatingTeam = false;
  bool get isUpdatingTeam => _isUpdatingTeam;

  Future<bool> updateTeam(int id, Map<String, dynamic> params) async {
    _isUpdatingTeam = true;
    notifyListeners();
    clearMessages();

    try {
      final response = await UserApis().updateTeam(id, params);
      if (response != null && response['success'] == true) {
        await fetchTeams();
        return true;
      } else {
        _errorMessage = response?['message'] ?? 'Failed to update team.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      return false;
    } finally {
      _isUpdatingTeam = false;
      notifyListeners();
    }
  }

  bool _isDeletingTeam = false;
  bool get isDeletingTeam => _isDeletingTeam;

  Future<bool> deleteTeam(int id) async {
    _isDeletingTeam = true;
    notifyListeners();
    clearMessages();

    try {
      final response = await UserApis().deleteTeam(id);
      if (response != null && response['success'] == true) {
        await fetchTeams();
        return true;
      } else {
        _errorMessage = response?['message'] ?? 'Failed to delete team.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      return false;
    } finally {
      _isDeletingTeam = false;
      notifyListeners();
    }
  }
}
