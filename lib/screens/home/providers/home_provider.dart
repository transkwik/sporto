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

  bool _isFetchingSports = false;
  bool get isFetchingSports => _isFetchingSports;

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
    if (_sportsList.isNotEmpty) return; // Cache it

    _setLoading(true);
    _isFetchingSports = true;
    notifyListeners();
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
      _isFetchingSports = false;
      notifyListeners();
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

  Future<Map<String, dynamic>?> createTeam(Map<String, dynamic> params) async {
    _isCreatingTeam = true;
    notifyListeners();
    clearMessages();

    try {
      final response = await UserApis().createTeam(params);

      if (response != null && response['success'] == true) {
        // Automatically fetch the latest teams after creation
        await fetchTeams();
        return response;
      } else {
        _errorMessage = response?['message'] ?? 'Failed to create team.';
        return null;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      return null;
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

  // --- Available Teams (Playground) ---
  bool _isFetchingAvailableTeams = false;
  bool get isFetchingAvailableTeams => _isFetchingAvailableTeams;

  List<Map<String, dynamic>> _availableTeamsList = [];
  List<Map<String, dynamic>> get availableTeamsList => _availableTeamsList;

  void _setFetchingAvailableTeams(bool value) {
    _isFetchingAvailableTeams = value;
    notifyListeners();
  }

  int _currentAvailableTeamsPage = 1;
  int _lastAvailableTeamsPage = 1;
  bool _isFetchingMoreAvailableTeams = false;
  bool get isFetchingMoreAvailableTeams => _isFetchingMoreAvailableTeams;

  void _setFetchingMoreAvailableTeams(bool value) {
    _isFetchingMoreAvailableTeams = value;
    notifyListeners();
  }

  Future<void> fetchAvailableTeams({
    bool isRefresh = false,
    int? sportId,
    double? latitude,
    double? longitude,
  }) async {
    if (isRefresh) {
      _currentAvailableTeamsPage = 1;
      _setFetchingAvailableTeams(true);
      _availableTeamsList = [];
    } else {
      if (_currentAvailableTeamsPage > _lastAvailableTeamsPage ||
          _isFetchingMoreAvailableTeams) {
        return;
      }
      _setFetchingMoreAvailableTeams(true);
    }
    clearMessages();

    try {
      final params = <String, dynamic>{
        'page': _currentAvailableTeamsPage,
        'per_page': 20,
      };

      if (sportId != null) params['sport_id'] = sportId;
      if (latitude != null) params['latitude'] = '';
      // latitude;
      if (longitude != null) params['longitude'] = '';
      // longitude;
      params['radius_km'] = '';

      final response = await UserApis().getAvailableTeams(params);

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        final data = response['data'];
        if (data != null) {
          // Check if data is paginated or list
          List<dynamic> newData = [];
          if (data is List) {
            newData = data;
          } else if (data is Map && data.containsKey('data')) {
            newData = data['data'] ?? [];
            _lastAvailableTeamsPage = data['last_page'] ?? 1;
          }

          final mappedData = newData
              .map((e) => e as Map<String, dynamic>)
              .toList();

          if (isRefresh) {
            _availableTeamsList = mappedData;
          } else {
            _availableTeamsList.addAll(mappedData);
          }
          _currentAvailableTeamsPage++;
        }
      } else {
        _errorMessage =
            response?['message'] ?? 'Failed to fetch available teams.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      if (isRefresh) {
        _setFetchingAvailableTeams(false);
      } else {
        _setFetchingMoreAvailableTeams(false);
      }
    }
  }

  // Track which teams the user has requested to join in this session
  final Set<int> _requestedTeamIds = {};

  bool hasRequestedToJoin(int teamId) {
    return _requestedTeamIds.contains(teamId);
  }

  Future<Map<String, dynamic>?> joinTeamRequest(int teamId) async {
    clearMessages();
    try {
      final response = await UserApis().joinTeamRequest(teamId);

      if (response != null && response['success'] == true) {
        _requestedTeamIds.add(teamId);
        notifyListeners();
      }

      return response;
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      return null;
    }
  }

  // --- My Teams ---
  bool _isFetchingMyTeams = false;
  bool get isFetchingMyTeams => _isFetchingMyTeams;

  List<Map<String, dynamic>> _myTeamsList = [];
  List<Map<String, dynamic>> get myTeamsList => _myTeamsList;

  int _currentMyTeamsPage = 1;
  int _lastMyTeamsPage = 1;
  bool _isFetchingMoreMyTeams = false;
  bool get isFetchingMoreMyTeams => _isFetchingMoreMyTeams;

  void _setFetchingMyTeams(bool value) {
    _isFetchingMyTeams = value;
    notifyListeners();
  }

  void _setFetchingMoreMyTeams(bool value) {
    _isFetchingMoreMyTeams = value;
    notifyListeners();
  }

  Future<void> fetchMyTeams({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentMyTeamsPage = 1;
      _setFetchingMyTeams(true);
      _myTeamsList = [];
    } else {
      if (_currentMyTeamsPage > _lastMyTeamsPage || _isFetchingMoreMyTeams) {
        return;
      }
      _setFetchingMoreMyTeams(true);
    }
    clearMessages();

    try {
      final response = await UserApis().getMyTeams(_currentMyTeamsPage, 20);

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        final data = response['data'] as List<dynamic>?;
        if (data != null) {
          final mappedData = data.map((e) => e as Map<String, dynamic>).toList();
          
          if (isRefresh) {
            _myTeamsList = mappedData;
          } else {
            _myTeamsList.addAll(mappedData);
          }
          _currentMyTeamsPage++;
          
          final meta = response['meta'];
          if (meta != null) {
            _lastMyTeamsPage = meta['last_page'] ?? 1;
          }
        }
      } else {
        _errorMessage = response?['message'] ?? 'Failed to fetch my teams.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      if (isRefresh) {
        _setFetchingMyTeams(false);
      } else {
        _setFetchingMoreMyTeams(false);
      }
    }
  }

  // --- Live Matches ---
  bool _isFetchingLiveMatches = false;
  bool get isFetchingLiveMatches => _isFetchingLiveMatches;

  List<Map<String, dynamic>> _liveMatchesList = [];
  List<Map<String, dynamic>> get liveMatchesList => _liveMatchesList;

  int _currentLiveMatchesPage = 1;
  int _lastLiveMatchesPage = 1;
  bool _isFetchingMoreLiveMatches = false;
  bool get isFetchingMoreLiveMatches => _isFetchingMoreLiveMatches;

  void _setFetchingLiveMatches(bool value) {
    _isFetchingLiveMatches = value;
    notifyListeners();
  }

  void _setFetchingMoreLiveMatches(bool value) {
    _isFetchingMoreLiveMatches = value;
    notifyListeners();
  }

  Future<void> fetchLiveMatches(dynamic sportId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _currentLiveMatchesPage = 1;
      _setFetchingLiveMatches(true);
      _liveMatchesList = [];
    } else {
      if (_currentLiveMatchesPage > _lastLiveMatchesPage || _isFetchingMoreLiveMatches) {
        return;
      }
      _setFetchingMoreLiveMatches(true);
    }
    clearMessages();

    try {
      final response = await UserApis().getLiveMatches(sportId, _currentLiveMatchesPage, 20);

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        final data = response['data']?['items'] as List<dynamic>?;
        if (data != null) {
          final mappedData = data.map((e) => e as Map<String, dynamic>).toList();
          
          if (isRefresh) {
            _liveMatchesList = mappedData;
          } else {
            _liveMatchesList.addAll(mappedData);
          }
          _currentLiveMatchesPage++;
          
          _lastLiveMatchesPage = response['data']?['last_page'] ?? 1;
        }
      } else {
        _errorMessage = response?['message'] ?? 'Failed to fetch live matches.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      if (isRefresh) {
        _setFetchingLiveMatches(false);
      } else {
        _setFetchingMoreLiveMatches(false);
      }
    }
  }

  // --- Upcoming Matches ---
  bool _isFetchingUpcomingMatches = false;
  bool get isFetchingUpcomingMatches => _isFetchingUpcomingMatches;

  List<Map<String, dynamic>> _upcomingMatchesList = [];
  List<Map<String, dynamic>> get upcomingMatchesList => _upcomingMatchesList;

  int _currentUpcomingMatchesPage = 1;
  int _lastUpcomingMatchesPage = 1;
  bool _isFetchingMoreUpcomingMatches = false;
  bool get isFetchingMoreUpcomingMatches => _isFetchingMoreUpcomingMatches;

  void _setFetchingUpcomingMatches(bool value) {
    _isFetchingUpcomingMatches = value;
    notifyListeners();
  }

  void _setFetchingMoreUpcomingMatches(bool value) {
    _isFetchingMoreUpcomingMatches = value;
    notifyListeners();
  }

  Future<void> fetchUpcomingMatches(dynamic sportId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _currentUpcomingMatchesPage = 1;
      _setFetchingUpcomingMatches(true);
      _upcomingMatchesList = [];
    } else {
      if (_currentUpcomingMatchesPage > _lastUpcomingMatchesPage || _isFetchingMoreUpcomingMatches) {
        return;
      }
      _setFetchingMoreUpcomingMatches(true);
    }
    clearMessages();

    try {
      final response = await UserApis().getUpcomingMatches(sportId, _currentUpcomingMatchesPage, 20);

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        final data = response['data']?['items'] as List<dynamic>?;
        if (data != null) {
          final mappedData = data.map((e) => e as Map<String, dynamic>).toList();
          
          if (isRefresh) {
            _upcomingMatchesList = mappedData;
          } else {
            _upcomingMatchesList.addAll(mappedData);
          }
          _currentUpcomingMatchesPage++;
          
          _lastUpcomingMatchesPage = response['data']?['last_page'] ?? 1;
        }
      } else {
        _errorMessage = response?['message'] ?? 'Failed to fetch upcoming matches.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      if (isRefresh) {
        _setFetchingUpcomingMatches(false);
      } else {
        _setFetchingMoreUpcomingMatches(false);
      }
    }
  }

  // --- All Matches ---
  bool _isFetchingAllMatches = false;
  bool get isFetchingAllMatches => _isFetchingAllMatches;

  List<Map<String, dynamic>> _allMatchesList = [];
  List<Map<String, dynamic>> get allMatchesList => _allMatchesList;

  int _currentAllMatchesPage = 1;
  int _lastAllMatchesPage = 1;
  bool _isFetchingMoreAllMatches = false;
  bool get isFetchingMoreAllMatches => _isFetchingMoreAllMatches;

  void _setFetchingAllMatches(bool value) {
    _isFetchingAllMatches = value;
    notifyListeners();
  }

  void _setFetchingMoreAllMatches(bool value) {
    _isFetchingMoreAllMatches = value;
    notifyListeners();
  }

  Future<void> fetchAllMatches(dynamic sportId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _currentAllMatchesPage = 1;
      _setFetchingAllMatches(true);
      _allMatchesList = [];
    } else {
      if (_currentAllMatchesPage > _lastAllMatchesPage || _isFetchingMoreAllMatches) {
        return;
      }
      _setFetchingMoreAllMatches(true);
    }
    clearMessages();

    try {
      final response = await UserApis().getAllMatches(sportId, _currentAllMatchesPage, 20);

      if (response != null && response['error'] != null) {
        _errorMessage = response['error'];
      } else if (response != null && response['success'] == true) {
        final data = response['data']?['items'] as List<dynamic>?;
        if (data != null) {
          final mappedData = data.map((e) => e as Map<String, dynamic>).toList();
          
          if (isRefresh) {
            _allMatchesList = mappedData;
          } else {
            _allMatchesList.addAll(mappedData);
          }
          _currentAllMatchesPage++;
          
          _lastAllMatchesPage = response['data']?['last_page'] ?? 1;
        }
      } else {
        _errorMessage = response?['message'] ?? 'Failed to fetch matches.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      if (isRefresh) {
        _setFetchingAllMatches(false);
      } else {
        _setFetchingMoreAllMatches(false);
      }
    }
  }
}
