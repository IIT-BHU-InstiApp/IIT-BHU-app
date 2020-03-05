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

  Future<Response<BuiltPost>> getPost(int id) {
    final $url = '/workshops/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BuiltPost, BuiltPost>($request);
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

  Future<Response<BuiltPost>> postPost(BuiltPost body) {
    final $url = '';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BuiltPost, BuiltPost>($request);
  }
}
