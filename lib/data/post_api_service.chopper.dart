// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$PostApiService extends PostApiService {
  _$PostApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = PostApiService;

  Future<Response<BuiltAllWorkshopsPost>> getAllWorkshops() {
    final $url = '/workshops/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltAllWorkshopsPost, BuiltAllWorkshopsPost>($request);
  }

  Future<Response<BuiltList<BuiltWorkshopSummaryPost>>> getActiveWorkshops() {
    final $url = '/workshops/active/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltWorkshopSummaryPost>,
        BuiltWorkshopSummaryPost>($request);
  }

  Future<Response<BuiltList<BuiltWorkshopSummaryPost>>> getPastWorkshops() {
    final $url = '/workshops/past/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltWorkshopSummaryPost>,
        BuiltWorkshopSummaryPost>($request);
  }

  Future<Response<BuiltList<BuiltWorkshopSummaryPost>>> getInterestedWorkshops(
      String token) {
    final $url = '/workshops/interested/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltList<BuiltWorkshopSummaryPost>,
        BuiltWorkshopSummaryPost>($request);
  }

  Future<Response> removeWorkshop(int id, String token) {
    final $url = '/workshops/${id}/';
    final $headers = {'Authorization': token};
    final $request = Request('DELETE', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<BuiltWorkshopDetailPost>> getWorkshopDetailsPost(
      int id, String token) {
    final $url = '/workshops/${id}/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<BuiltWorkshopDetailPost, BuiltWorkshopDetailPost>($request);
  }

  Future<Response> toggleInterestedWorkshop(int id, String token) {
    final $url = '/workshops/${id}/toggle-interested/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<BuiltList<BuiltAllCouncilsPost>>> getAllCouncils() {
    final $url = '/councils/';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BuiltList<BuiltAllCouncilsPost>, BuiltAllCouncilsPost>($request);
  }

  Future<Response<BuiltCouncilPost>> getCouncil(int id) {
    final $url = '/councils/${id}/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltCouncilPost, BuiltCouncilPost>($request);
  }

  Future<Response<BuiltClubPost>> getClub(int id, String token) {
    final $url = '/clubs/${id}/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltClubPost, BuiltClubPost>($request);
  }

  Future<Response> toggleClubSubscription(int id, String token) {
    final $url = '/clubs/${id}/toggle-subscribed/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<BuiltProfilePost>> getProfile(String token) {
    final $url = '/profile/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltProfilePost, BuiltProfilePost>($request);
  }

  Future<Response<BuiltProfilePost>> updateProfileByPatch(
      String token, BuiltProfilePost body) {
    final $url = '/profile/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PATCH', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BuiltProfilePost, BuiltProfilePost>($request);
  }

  Future<Response<BuiltList<BuiltProfilePost>>> searchProfile(
      String token, BuiltProfileSearchPost body) {
    final $url = '/profile/search/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BuiltList<BuiltProfilePost>, BuiltProfilePost>($request);
  }

  Future<Response<BuiltList<BuiltTeamMemberPost>>> getTeam() {
    final $url = '/team/';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BuiltList<BuiltTeamMemberPost>, BuiltTeamMemberPost>($request);
  }

  Future<Response> postNewWorkshop(String token, BuiltWorkshopCreatePost body) {
    final $url = '/workshops/create/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> updateWorkshopByPatch(
      int id, String token, BuiltWorkshopDetailPost body) {
    final $url = '/workshops/${id}/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PATCH', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<BuiltAllWorkshopsPost>> searchWorkshop(
      BuiltWorkshopSearchByStringPost body) {
    final $url = '/workshops/search/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BuiltAllWorkshopsPost, BuiltAllWorkshopsPost>($request);
  }

  Future<Response<BuiltList<ContactPost>>> updateContacts(
      int id, String token, BuiltContacts body) {
    final $url = '/workshops/${id}/update-contacts/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BuiltList<ContactPost>, ContactPost>($request);
  }
}
