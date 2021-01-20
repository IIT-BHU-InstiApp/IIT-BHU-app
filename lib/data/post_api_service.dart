import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'built_value_converter.dart';
import 'internet_connection_interceptor.dart';
part 'post_api_service.chopper.dart';

// command for initiating chopper inspector/generator - flutter packages pub run build_runner watch --delete-conflicting-outputs --use-polling-watcher

@ChopperApi(baseUrl: '')
abstract class PostApiService extends ChopperService {
//! ------------------------------------------ Workshop end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/workshops/')
  Future<Response<BuiltAllWorkshopsPost>> getAllWorkshops();

  @Get(path: '/workshops/active/')
  Future<Response<BuiltList<BuiltWorkshopSummaryPost>>> getActiveWorkshops();

  @Get(path: '/workshops/interested/')
  Future<Response<BuiltList<BuiltWorkshopSummaryPost>>> getInterestedWorkshops(
      @Header('Authorization') String token);

  @Get(path: '/workshops/past/')
  Future<Response<BuiltList<BuiltWorkshopSummaryPost>>> getPastWorkshops();

  @Get(path: '/workshops/{id}/')
  Future<Response<BuiltWorkshopDetailPost>> getWorkshopDetailsPost(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/workshops/{id}/toggle-interested/')
  Future<Response> toggleInterestedWorkshop(
      @Path('id') int id, @Header('Authorization') String token);

  //? ----------------------------------- Post -------------------------------

  ///searches workshop only according to title
  @Post(path: '/workshops/search/')
  Future<Response<BuiltAllWorkshopsPost>> searchWorkshop(
      @Body() BuiltWorkshopSearchByStringPost body);

  @Post(path: '/workshops/{id}/resources/')
  Future<Response> createResource(
      @Path('id') int id,
      @Header('Authorization') String token,
      @Body() WorkshopResources resources);

  //? ----------------------------------- Put -------------------------------

  @Put(path: '/workshops/{id}/')
  Future<Response> updateWorkshopByPut(
      @Path('id') int id,
      @Header('Authorization') String token,
      @Body() BuiltWorkshopDetailPost body);

  @Put(path: '/workshops/{id}/update-contacts/')
  Future<Response> updateContacts(@Path('id') int id,
      @Header('Authorization') String token, @Body() BuiltContacts body);

  @Put(path: '/workshops/{id}/update-tags/')
  Future<Response> updateTags(@Path('id') int id,
      @Header('Authorization') String token, @Body() BuiltTags body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/workshops/{id}/')
  Future<Response> updateWorkshopByPatch(
      @Path('id') int id,
      @Header('Authorization') String token,
      @Body() BuiltWorkshopDetailPost body);

  //? ----------------------------------- Delete -------------------------------

  @Delete(path: '/workshops/{id}/')
  Future<Response> removeWorkshop(
      @Path('id') int id, @Header('Authorization') String token);

//! ------------------------------------------ Workshop end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Resources end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/resources/{id}/')
  Future<Response<WorkshopResources>> getWorkshopResources(@Path('id') int id);

  //? ----------------------------------- Put -------------------------------
  @Put(path: '/resources/{id}/')
  Future<Response> updateWorkshopResourcesByPut(@Path('id') int id,
      @Header('Authorization') String token, @Body() WorkshopResources body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/resources/{id}/')
  Future<Response> updateWorkshopResourcesByPatch(@Path('id') int id,
      @Header('Authorization') String token, @Body() WorkshopResources body);

  //? ----------------------------------- Delete -------------------------------

  @Delete(path: '/resources/{id}/')
  Future<Response> deleteWorkshopResources(
      @Path('id') int id, @Header('Authorization') String token);
//! ------------------------------------------ Resources end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Council end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/councils/')
  Future<Response<BuiltList<BuiltAllCouncilsPost>>> getAllCouncils();

  @Get(path: '/councils/{id}/')
  Future<Response<BuiltCouncilPost>> getCouncil(
      @Header('Authorization') String token, @Path('id') int id);

  //? ----------------------------------- Put -------------------------------
  @Put(path: '/councils/{id}/')
  Future<Response> updateCouncilByPut(@Path('id') int id,
      @Header('Authorization') String token, @Body() BuiltCouncilPost body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/councils/{id}/')
  Future<Response> updateCouncilByPatch(@Path('id') int id,
      @Header('Authorization') String token, @Body() BuiltCouncilPost body);

//! ------------------------------------------ Council end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Club end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/clubs/{id}/')
  Future<Response<BuiltClubPost>> getClub(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/clubs/{id}/tags/')
  Future<Response<ClubTags>> getClubTags(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/clubs/{id}/toggle-subscribed/')
  Future<Response> toggleClubSubscription(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/clubs/{id}/workshops/')
  Future<Response<BuiltAllWorkshopsPost>> getClubWorkshops(
      @Path('id') int id, @Header('Authorization') String token);

  //? ----------------------------------- Post -------------------------------

  @Post(path: '/clubs/{id}/tags/create/')
  Future<Response<TagDetail>> createClubTag(@Path('id') int id,
      @Header('Authorization') String token, @Body() TagCreate body);

  @Post(path: '/clubs/{id}/tags/delete/')
  Future<Response> deleteClubTag(@Path('id') int id,
      @Header('Authorization') String token, @Body() TagDelete body);

  @Post(path: '/clubs/{id}/tags/search/')
  Future<Response<BuiltList<TagDetail>>> searchClubTag(@Path('id') int id,
      @Header('Authorization') String token, @Body() TagSearch body);

  @Post(path: '/clubs/{id}/workshops/create/')
  Future<Response<dynamic>> createClubWorkshop(
      @Path('id') int id,
      @Header('Authorization') String token,
      @Body() BuiltWorkshopCreatePost body);

  //? ----------------------------------- Put -------------------------------
  @Put(path: '/clubs/{id}/')
  Future<Response> updateClubByPut(@Path('id') int id,
      @Header('Authorization') String token, @Body() BuiltClubPost body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/clubs/{id}/')
  Future<Response> updateClubByPatch(@Path('id') int id,
      @Header('Authorization') String token, @Body() BuiltClubPost body);

//! ------------------------------------------ Club end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Entity end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/entities/')
  Future<Response<BuiltList<EntityListPost>>> getAllEntity();

  @Get(path: '/entities/{id}/')
  Future<Response<BuiltEntityPost>> getEntity(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/entities/{id}/tags/')
  Future<Response<EntityTags>> getEntityTags(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/entities/{id}/toggle-subscribed/')
  Future<Response> toggleEntitySubscription(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/entities/{id}/workshops/')
  Future<Response<BuiltAllWorkshopsPost>> getEntityWorkshops(
      @Path('id') int id, @Header('Authorization') String token);

  //? ----------------------------------- Post -------------------------------

  @Post(path: '/entities/{id}/tags/create/')
  Future<Response<TagDetail>> createEntityTag(@Path('id') int id,
      @Header('Authorization') String token, @Body() TagCreate body);

  @Post(path: '/entities/{id}/tags/delete/')
  Future<Response> deleteEntityTag(@Path('id') int id,
      @Header('Authorization') String token, @Body() TagDelete body);

  @Post(path: '/entities/{id}/tags/search/')
  Future<Response<BuiltList<TagDetail>>> searchEntityTag(@Path('id') int id,
      @Header('Authorization') String token, @Body() TagSearch body);

  @Post(path: '/entities/{id}/workshops/create/')
  Future<Response<dynamic>> createEntityWorkshop(
      @Path('id') int id,
      @Header('Authorization') String token,
      @Body() BuiltWorkshopCreatePost body);

  //? ----------------------------------- Put -------------------------------
  @Put(path: '/entities/{id}/')
  Future<Response> updateEntityByPut(@Path('id') int id,
      @Header('Authorization') String token, @Body() BuiltEntityPost body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/entities/{id}/')
  Future<Response> updateEntityByPatch(@Path('id') int id,
      @Header('Authorization') String token, @Body() BuiltEntityPost body);

//! ------------------------------------------ Entity end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Profile end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/profile/')
  Future<Response<BuiltProfilePost>> getProfile(
      @Header('Authorization') String token);

  //? ----------------------------------- Post -------------------------------

  @Post(path: '/profile/search/')
  Future<Response<BuiltList<BuiltProfilePost>>> searchProfile(
      @Header('Authorization') String token,
      @Body() BuiltProfileSearchPost body);

  //? ----------------------------------- Put -------------------------------
  @Put(path: '/profile/')
  Future<Response<BuiltProfilePost>> updateProfileByPut(
      @Header('Authorization') String token, @Body() BuiltProfilePost body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/profile/')
  Future<Response<BuiltProfilePost>> updateProfileByPatch(
      @Header('Authorization') String token, @Body() BuiltProfilePost body);

//! ------------------------------------------ Profile end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Other (Team,Login,ConfigVar) end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/team/')
  Future<Response<BuiltList<BuiltTeamMemberPost>>> getTeam();

  //? ----------------------------------- Post -------------------------------

  @Post(path: '/login/')
  Future<Response<Token>> logInPost(@Body() LoginPost body);

  @Get(path: '/config/')
  Future<Response<BuiltList<ConfigVar>>> getConfigVars();

//! ------------------------------------------ Other (Team,Login,ConfigVar) end point APIs --------------------------------------------------------------

  static PostApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://workshops-app-backend.herokuapp.com',
      services: [
        _$PostApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [InternetConnectionInterceptor(), HttpLoggingInterceptor()],
    );
    return _$PostApiService(client);
  }
}
