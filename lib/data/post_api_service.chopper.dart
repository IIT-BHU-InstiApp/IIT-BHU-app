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

  Future<Response<BuiltList<BuiltAllWorkshopsPost>>> getUpcomingWorkshops() {
    final $url = '/workshops/active';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltAllWorkshopsPost>, BuiltAllWorkshopsPost>(
        $request);
  }

  Future<Response<BuiltList<BuiltAllWorkshopsPost>>> getPastWorkshops() {
    final $url = '/workshops/past';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltAllWorkshopsPost>, BuiltAllWorkshopsPost>(
        $request);
  }

  Future<Response<BuiltWorkshopDetailPost>> getWorkshopDetailsPost(
      int id, String token) {
    final $url = '/workshops/${id}';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<BuiltWorkshopDetailPost, BuiltWorkshopDetailPost>($request);
  }

  Future<Response<BuiltList<BuiltAllCouncilsPost>>> getAllCouncils() {
    final $url = '/councils';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BuiltList<BuiltAllCouncilsPost>, BuiltAllCouncilsPost>($request);
  }

  Future<Response<BuiltCouncilPost>> getCouncil(int id) {
    final $url = '/councils/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltCouncilPost, BuiltCouncilPost>($request);
  }

  Future<Response<BuiltClubPost>> getClub(int id, String token) {
    final $url = '/clubs/${id}';
    final $headers = {'Authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BuiltClubPost, BuiltClubPost>($request);
  }

  Future<Response<BuiltClubPost>> getProfile() {
    final $url = '/profile';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltClubPost, BuiltClubPost>($request);
  }

  Future<Response<BuiltList<BuiltTeamMemberPost>>> getTeam() {
    final $url = '/team';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<BuiltList<BuiltTeamMemberPost>, BuiltTeamMemberPost>($request);
  }

  Future<Response<BuiltAllWorkshopsPost>> postPost(BuiltAllWorkshopsPost body) {
    final $url = '';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BuiltAllWorkshopsPost, BuiltAllWorkshopsPost>($request);
  }
}
