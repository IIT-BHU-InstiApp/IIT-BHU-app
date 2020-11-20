import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'built_value_converter.dart';
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

  @Post(path: '/workshops/create/')
  Future<Response<BuiltWorkshopCreatePost>> postNewWorkshop(
      @Header('Authorization') String token, @Body() BuiltWorkshopCreatePost body);

  @Post(path: '/workshops/{id}/resources/')
  Future<Response> postNewResource(@Path('id') int id, @Header('Authorization') String token,
      @Body() WorkshopResources resources);

  @Post(path: '/workshops/search/')
  Future<Response<BuiltAllWorkshopsPost>> searchWorkshop(
      @Body() BuiltWorkshopSearchByStringPost body);

  //? ----------------------------------- Put -------------------------------

  @Put(path: '/workshops/{id}/update-contacts/')
  Future<Response<BuiltContacts>> updateContacts(
      @Path('id') int id, @Header('Authorization') String token, @Body() BuiltContacts body);

  @Put(path: '/workshops/{id}/update-tags/')
  Future<Response<BuiltTags>> updateTags(
      @Path('id') int id, @Header('Authorization') String token, @Body() BuiltTags body);

  @Put(path: '/workshops/{id}/')
  Future<Response> updateWorkshopByPut(@Path('id') int id, @Header('Authorization') String token,
      @Body() BuiltWorkshopDetailPost body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/workshops/{id}/')
  Future<Response> updateWorkshopByPatch(@Path('id') int id, @Header('Authorization') String token,
      @Body() BuiltWorkshopDetailPost body);

  //? ----------------------------------- Delete -------------------------------

  @Delete(path: '/workshops/{id}/')
  Future<Response> removeWorkshop(@Path('id') int id, @Header('Authorization') String token);

//! ------------------------------------------ Workshop end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Resources end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/resources/{id}/')
  Future<Response<WorkshopResources>> getWorkshopResources(@Path('id') int id);

  //? ----------------------------------- Put -------------------------------
  @Put(path: '/resources/{id}/')
  Future<Response> updateWorkshopResourcesByPut(
      @Path('id') int id, @Header('Authorization') String token, @Body() WorkshopResources body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/resources/{id}/')
  Future<Response> updateWorkshopResourcesByPatch(
      @Path('id') int id, @Header('Authorization') String token, @Body() WorkshopResources body);

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
  Future<Response> updateCouncilByPut(
      @Path('id') int id, @Header('Authorization') String token, @Body() BuiltCouncilPost body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/councils/{id}/')
  Future<Response> updateCouncilByPatch(
      @Path('id') int id, @Header('Authorization') String token, @Body() BuiltCouncilPost body);

//! ------------------------------------------ Council end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Club end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/clubs/{id}/')
  Future<Response<BuiltClubPost>> getClub(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/clubs/{id}/toggle-subscribed/')
  Future<Response> toggleClubSubscription(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/clubs/{id}/workshops/')
  Future<Response<BuiltAllWorkshopsPost>> getClubWorkshops(
      @Path('id') int id, @Header('Authorization') String token);

  @Get(path: '/clubs/{id}/tags/')
  Future<Response<ClubTags>> getClubTags(@Path('id') int id, @Header('Authorization') String token);

  //? ----------------------------------- Put -------------------------------
  @Put(path: '/clubs/{id}/')
  Future<Response> updateClubByPut(
      @Path('id') int id, @Header('Authorization') String token, @Body() BuiltClubPost body);

  //? ----------------------------------- Patch -------------------------------

  @Patch(path: '/clubs/{id}/')
  Future<Response> updateClubByPatch(
      @Path('id') int id, @Header('Authorization') String token, @Body() BuiltClubPost body);

//! ------------------------------------------ Club end point APIs --------------------------------------------------------------

//? --------------------------------------------------------------------------------------------------------------------
//? --------------------------------------------------------------------------------------------------------------------

//! ------------------------------------------ Profile end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/profile/')
  Future<Response<BuiltProfilePost>> getProfile(@Header('Authorization') String token);

  //? ----------------------------------- Post -------------------------------

  @Post(path: '/profile/search/')
  Future<Response<BuiltList<BuiltProfilePost>>> searchProfile(
      @Header('Authorization') String token, @Body() BuiltProfileSearchPost body);

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

//! ------------------------------------------ Other (Team,Tags,Login) end point APIs --------------------------------------------------------------

  //? ----------------------------------- Get -------------------------------

  @Get(path: '/team/')
  Future<Response<BuiltList<BuiltTeamMemberPost>>> getTeam();

  //? ----------------------------------- Post -------------------------------

  @Post(path: '/tags/create/')
  Future<Response<TagDetail>> createTag(
      @Header('Authorization') String token, @Body() TagCreate body);

// TODO: what is the return response body of searchTag ?
  @Post(path: '/tags/search/')
  Future<Response<BuiltList<TagDetail>>> searchTag(
      @Header('Authorization') String token, @Body() TagSearch body);

  @Post(path: '/login/')
  Future<Response<Token>> logInPost(@Body() LoginPost body);

//! ------------------------------------------ Other (Team,Tags,Login) end point APIs --------------------------------------------------------------

  static PostApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://workshops-app-backend.herokuapp.com',
      services: [
        _$PostApiService(),
      ],
      converter: BuiltValueConverter(),
      interceptors: [HttpLoggingInterceptor()],
    );
    return _$PostApiService(client);
  }
}
