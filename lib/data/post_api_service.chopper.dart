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

  Future<Response<BuiltList<BuiltWorkshopSummaryPost>>> getInterestedWorkshops(
      String token) {
    final $url = '/workshops/interested/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltList<BuiltWorkshopSummaryPost>,
        BuiltWorkshopSummaryPost>($request);
  }

  Future<Response<BuiltList<BuiltWorkshopSummaryPost>>> getPastWorkshops() {
    final $url = '/workshops/past/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltWorkshopSummaryPost>,
        BuiltWorkshopSummaryPost>($request);
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

  Future<Response<BuiltWorkshopCreatePost>> postNewWorkshop(
      String token, BuiltWorkshopCreatePost body) {
    final $url = '/workshops/create/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client
        .send<BuiltWorkshopCreatePost, BuiltWorkshopCreatePost>($request);
  }

  Future<Response> postNewResource(
      int id, String token, WorkshopResources resources) {
    final $url = '/workshops/${id}/resources/';
    final $headers = {'Authorization': token};
    final $body = resources;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<BuiltAllWorkshopsPost>> searchWorkshop(
      BuiltWorkshopSearchByStringPost body) {
    final $url = '/workshops/search/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BuiltAllWorkshopsPost, BuiltAllWorkshopsPost>($request);
  }

  Future<Response<BuiltContacts>> updateContacts(
      int id, String token, BuiltContacts body) {
    final $url = '/workshops/${id}/update-contacts/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BuiltContacts, BuiltContacts>($request);
  }

  Future<Response<BuiltTags>> updateTags(int id, String token, BuiltTags body) {
    final $url = '/workshops/${id}/update-tags/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BuiltTags, BuiltTags>($request);
  }

  Future<Response> updateWorkshopByPut(
      int id, String token, BuiltWorkshopDetailPost body) {
    final $url = '/workshops/${id}/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
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

  Future<Response> removeWorkshop(int id, String token) {
    final $url = '/workshops/${id}/';
    final $headers = {'Authorization': token};
    final $request = Request('DELETE', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<WorkshopResources>> getWorkshopResources(int id) {
    final $url = '/resources/${id}/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<WorkshopResources, WorkshopResources>($request);
  }

  Future<Response> updateWorkshopResourcesByPut(
      int id, String token, WorkshopResources body) {
    final $url = '/resources/${id}/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> updateWorkshopResourcesByPatch(
      int id, String token, WorkshopResources body) {
    final $url = '/resources/${id}/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PATCH', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> deleteWorkshopResources(int id, String token) {
    final $url = '/resources/${id}/';
    final $headers = {'Authorization': token};
    final $request = Request('DELETE', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<BuiltList<BuiltAllCouncilsPost>>> getAllCouncils() {
    final $url = '/councils/';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BuiltList<BuiltAllCouncilsPost>, BuiltAllCouncilsPost>($request);
  }

  Future<Response<BuiltCouncilPost>> getCouncil(String token, int id) {
    final $url = '/councils/${id}/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltCouncilPost, BuiltCouncilPost>($request);
  }

  Future<Response> updateCouncilByPut(
      int id, String token, BuiltCouncilPost body) {
    final $url = '/councils/${id}/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> updateCouncilByPatch(
      int id, String token, BuiltCouncilPost body) {
    final $url = '/councils/${id}/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PATCH', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
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

  Future<Response<BuiltAllWorkshopsPost>> getClubWorkshops(
      int id, String token) {
    final $url = '/clubs/${id}/workshops/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltAllWorkshopsPost, BuiltAllWorkshopsPost>($request);
  }

  Future<Response<ClubTags>> getClubTags(int id, String token) {
    final $url = '/clubs/${id}/tags/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<ClubTags, ClubTags>($request);
  }

  Future<Response> updateClubByPut(int id, String token, BuiltClubPost body) {
    final $url = '/clubs/${id}/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> updateClubByPatch(int id, String token, BuiltClubPost body) {
    final $url = '/clubs/${id}/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PATCH', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<BuiltProfilePost>> getProfile(String token) {
    final $url = '/profile/';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
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

  Future<Response<BuiltProfilePost>> updateProfileByPut(
      String token, BuiltProfilePost body) {
    final $url = '/profile/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
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

  Future<Response<BuiltList<BuiltTeamMemberPost>>> getTeam() {
    final $url = '/team/';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BuiltList<BuiltTeamMemberPost>, BuiltTeamMemberPost>($request);
  }

  Future<Response<TagDetail>> createTag(String token, TagCreate body) {
    final $url = '/tags/create/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<TagDetail, TagDetail>($request);
  }

  Future<Response<BuiltList<TagDetail>>> searchTag(
      String token, TagSearch body) {
    final $url = '/tags/search/';
    final $headers = {'Authorization': token};
    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BuiltList<TagDetail>, TagDetail>($request);
  }

  Future<Response<Token>> logInPost(LoginPost body) {
    final $url = '/login/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Token, Token>($request);
  }
}
