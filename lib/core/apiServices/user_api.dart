import 'dart:developer';

import 'package:sporto/core/apiServices/api_constants.dart';
import 'package:sporto/core/apiServices/api_helpers.dart';

class UserApis {
  //Login Apis

  getSendOtp(Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson(SEND_OTP, params);
    log(response.toString());
    return response;
  }

  getVerifyOtp(Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson(VERIFY_OTP, params);
    log(response.toString());
    return response;
  }

  getCheck() async {
    var response = await ApiHelper().getTypeGet(CHECK);
    log(response.toString());
    return response;
  }

  uploadProfileImage(String filePath) async {
    String url = 'https://app.spotoapp.in/api/v1/common/upload';
    Map<String, String> fields = {'folder': 'users/profile'};
    var response = await ApiHelper().uploadFile(url, fields, filePath);
    log(response.toString());
    return response;
  }

  completeProfile(Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson(
      'complete-profile',
      params,
    );
    log(response.toString());
    return response;
  }

  updateLatLong(Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePutJson('location', params);
    log(response.toString());
    return response;
  }

  // Home Apis
  getSports() async {
    var response = await ApiHelper().getTypeGet('sports');
    log(response.toString());
    return response;
  }

  getTournaments(Map<String, dynamic> params) async {
    // Convert params to query string
    final queryParams = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    var response = await ApiHelper().getTypeGet('tournaments?$queryParams');
    log(response.toString());
    return response;
  }

  getTournamentDetail(int id) async {
    var response = await ApiHelper().getTypeGet('tournaments/$id');
    log(response.toString());
    return response;
  }

  getTeams() async {
    var response = await ApiHelper().getTypeGet('teams');
    log(response.toString());
    return response;
  }

  createTeam(Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson('teams', params);
    log(response.toString());
    return response;
  }

  updateTeam(int id, Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePutJson('teams/$id', params);
    log(response.toString());
    return response;
  }

  deleteTeam(int id) async {
    var response = await ApiHelper().getTypeDelete('teams/$id');
    log(response.toString());
    return response;
  }

  // --- Payment & Registration APIs ---
  registerTournament(int tournamentId, Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson(
      'tournaments/$tournamentId/register',
      params,
    );
    log(response.toString());
    return response;
  }

  initiatePayment(int registrationId, Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson(
      'registrations/$registrationId/payment',
      params,
    );
    log(response.toString());
    return response;
  }

  verifyPayment(int registrationId, Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson(
      'registrations/$registrationId/payment/verify',
      params,
    );
    log(response.toString());
    return response;
  }

  addTeamPlayer(int teamId, Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson(
      'teams/$teamId/players',
      params,
    );
    log(response.toString());
    return response;
  }

  getTeamPlayers(int teamId) async {
    var response = await ApiHelper().getTypeGet('teams/$teamId/players');
    log(response.toString());
    return response;
  }

  removeTeamPlayer(int teamId, int playerId) async {
    var response = await ApiHelper().getTypeDelete(
      'teams/$teamId/players/$playerId',
    );
    log(response.toString());
    return response;
  }

  getAvailableTeams(Map<String, dynamic> params) async {
    var response = await ApiHelper().getTypePostJson('teams/available', params);
    log(response.toString());
    return response;
  }

  joinTeamRequest(int teamId) async {
    var response = await ApiHelper().getTypePostJson(
      'teams/$teamId/join-request',
      {},
    );
    log(response.toString());
    return response;
  }

  getMyTeams(int page, int perPage) async {
    var response = await ApiHelper().getTypeGet(
      'my-teams?page=$page&per_page=$perPage',
    );
    log(response.toString());
    return response;
  }

  getMyTeamDetails(int id) async {
    var response = await ApiHelper().getTypeGet('my-teams/$id');
    log(response.toString());
    return response;
  }

  getLiveMatches(dynamic sportId, int page, int perPage) async {
    var response = await ApiHelper().getTypeGet(
      'matches/live?sport_id=$sportId&page=$page&per_page=$perPage',
    );
    log(response.toString());
    return response;
  }

  getUpcomingMatches(dynamic sportId, int page, int perPage) async {
    var response = await ApiHelper().getTypeGet(
      'matches/upcoming?sport_id=$sportId&page=$page&per_page=$perPage',
    );
    log(response.toString());
    return response;
  }

  getAllMatches(dynamic sportId, int page, int perPage) async {
    var response = await ApiHelper().getTypeGet(
      'matches?sport_id=$sportId&page=$page&per_page=$perPage',
    );
    log(response.toString());
    return response;
  }
}
