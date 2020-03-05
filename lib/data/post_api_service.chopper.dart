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

  Future<Response<BuiltList<BuiltPost>>> getUpcomingWorkshops() {
    final $url = '/workshops';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltList<BuiltPost>, BuiltPost>($request);
  }

  Future<Response<BuiltWorkshopDetailPost>> getPost(int id) {
    final $url = '/workshops/${id}';
    final $request = Request('GET', $url, client.baseUrl);
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

  Future<Response<BuiltClubPost>> getClub(int id) {
    final $url = '/clubs/${id}';
    final $request = Request('GET', $url, client.baseUrl);
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

  Future<Response<BuiltPost>> postPost(BuiltPost body) {
    final $url = '';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BuiltPost, BuiltPost>($request);
  }
}
