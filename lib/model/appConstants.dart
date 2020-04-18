import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/post_api_service.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/database_helpers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:iit_app/services/connectivityCheck.dart';

class AppConstants {
  // ------------------------------------------ connectivity variables

  static ConnectionStatusSingleton connectionStatus;
  static bool isLoggedIn = false;
  // static bool isOnline = false;
  // static Stream connectivityStream;

  // ------------------------------------------ connectivity variables

  static bool logInButtonEnabled = true;
  static bool firstTimeFetching = true;
  static bool refreshingHomePage = false;

  static String djangoToken;

  static FirebaseUser currentUser;
  static PostApiService service;

  static BuiltList<BuiltWorkshopSummaryPost> workshopFromDatabase;

  // !-------------------------
  static BuiltList<BuiltAllCouncilsPost> councilsSummaryfromDatabase;
  // !-------------------------

  static int currentCouncilId;

  static Future populateWorkshopsAndCouncilButtons() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var database = await helper.database;

    workshopFromDatabase = await helper.getAllWorkshopsSummary(db: database);
    councilsSummaryfromDatabase =
        await helper.getAllCouncilsSummary(db: database);

    // print(' workshops is empty: ${(workshops.isEmpty == true).toString()}');

    if (workshopFromDatabase == null) {
      // insert all workshop information for the first time
      await helper.deleteWorkshopsSummary(db: database);
      await helper.deleteAllCouncilsSummary(db: database);

      print('fetching workshops and all councils summary from json');

// API calls to fetch the data
      Response<BuiltList<BuiltWorkshopSummaryPost>> workshopSnapshots =
          await service.getActiveWorkshops();
      final workshopPosts = workshopSnapshots.body;

      Response<BuiltList<BuiltAllCouncilsPost>> councilSummarySnapshots =
          await service.getAllCouncils();
      final councilSummaryPosts = councilSummarySnapshots.body;

// storing the data fetched from json objects into local database
      for (var post in workshopPosts) {
        await helper.insertWorkshopSummaryIntoDatabase(post: post);
      }

      for (var post in councilSummaryPosts) {
        await helper.insertCouncilSummaryIntoDatabase(councilSummary: post);
      }

// fetching the data from local database and storing it into variables
// whose scope is throughout the app

      workshopFromDatabase = workshopPosts;
      // await helper.getAllWorkshopsSummary(db: database);
      councilsSummaryfromDatabase = councilSummaryPosts;
      // await helper.getAllCouncilsSummary(db: database);
    }

    // helper.closeDatabase(db: database);
    print('workshops and all councils summary fetched ');
  }

  static Future updateAndPopulateWorkshops() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var database = await helper.database;

    await helper.deleteWorkshopsSummary(db: database);

    print('fetching workshops infos from json for updation');

    Response<BuiltList<BuiltWorkshopSummaryPost>> workshopSnapshots =
        await service.getActiveWorkshops();

    final workshopPosts = workshopSnapshots.body;

    for (var post in workshopPosts) {
      await helper.insertWorkshopSummaryIntoDatabase(post: post);
    }
    workshopFromDatabase = workshopPosts;

    print('workshops fetched and updated ');

    // helper.closeDatabase(db: database);
  }

  static Future getCouncilDetailsFromDatabase({@required int councilId}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var database = await helper.database;

    BuiltCouncilPost councilPost =
        await helper.getCouncilDetail(db: database, councilId: councilId);

    if (councilPost == null) {
      Response<BuiltCouncilPost> councilSnapshots =
          await AppConstants.service.getCouncil(AppConstants.currentCouncilId);

      councilPost = councilSnapshots.body;

      await helper.insertCouncilDetailsIntoDatabase(councilPost: councilPost);
    }

    return councilPost;
  }

  static Future getAndUpdateCouncilDetailsInDatabase(
      {@required int councilId}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var database = await helper.database;

    print('deleting council entries ---------------------------');
    await helper.deleteEntryOfCouncilDetail(db: database, councilId: councilId);
    print('deleted ---------------------------');

    Response<BuiltCouncilPost> councilSnapshots =
        await AppConstants.service.getCouncil(AppConstants.currentCouncilId);

    var councilPost = councilSnapshots.body;

    await helper.insertCouncilDetailsIntoDatabase(councilPost: councilPost);

    return councilPost;
  }
}
