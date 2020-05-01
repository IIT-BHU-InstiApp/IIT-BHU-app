import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/data/post_api_service.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/database_helpers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:iit_app/services/connectivityCheck.dart';
import 'package:http/http.dart' as http;

class AppConstants {
  //  connectivity variables ------------------------------------------

  static ConnectionStatusSingleton connectionStatus;
  static bool isLoggedIn = false;
  // static bool isOnline = false;
  // static Stream connectivityStream;

  // ------------------------------------------ connectivity variables

  static bool logInButtonEnabled = true;
  static bool firstTimeFetching = true;
  static bool refreshingHomePage = false;

  static String deviceDirectoryPath;

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

    councilsSummaryfromDatabase =
        await helper.getAllCouncilsSummary(db: database);
    workshopFromDatabase = await helper.getAllWorkshopsSummary(db: database);

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
      // ? remember, we use council summary in database while fetching other data (most of time)
      for (var post in councilSummaryPosts) {
        await helper.insertCouncilSummaryIntoDatabase(councilSummary: post);
      }

      await writeCouncilLogosIntoDisk(councilSummaryPosts);

      for (var post in workshopPosts) {
        await helper.insertWorkshopSummaryIntoDatabase(post: post);
        writeImageFileIntoDisk(
            isClub: true,
            isSmall: true,
            id: post.club.id,
            url: post.club.small_image_url);
      }

// fetching the data from local database and storing it into variables
// whose scope is throughout the app

      councilsSummaryfromDatabase = councilSummaryPosts;
      // await helper.getAllCouncilsSummary(db: database);
      workshopFromDatabase = workshopPosts;
      // await helper.getAllWorkshopsSummary(db: database);

    }

    // helper.closeDatabase(db: database);
    print('workshops and all councils summary fetched ');
  }

  static writeCouncilLogosIntoDisk(
      BuiltList<BuiltAllCouncilsPost> councils) async {
    for (var council in councils) {
      if (File('${AppConstants.deviceDirectoryPath}/council(small)_${council.id}')
              .existsSync() ==
          false) {
        final url = council.small_image_url;
        http.get(url).catchError((error) {
          print('Error in downloading image : $error');
        }).then((response) {
          if (response.statusCode == 200) {
            final imageData = response.bodyBytes.toList();
            final File file = File(
                '${AppConstants.deviceDirectoryPath}/council(small)_${council.id}');
            file.writeAsBytesSync(imageData);
          }
        });
      }
    }
  }

  /// if [isSmall] is false, then image will be considered as large
  ///
  /// [id] will be served for any option , [isCouncil] or [isClub] , whichever is true
  ///
  /// if [isCouncil] and [isClub] both are true/false , function produces zero work.
  static writeImageFileIntoDisk(
      {bool isCouncil = false,
      bool isClub = false,
      @required bool isSmall,
      @required int id,
      @required String url}) async {
    if ((isCouncil == true && isClub == true) ||
        (isCouncil == false && isClub == false) ||
        isSmall == null ||
        id == null ||
        url == null) {
      return;
    }

    String size = isSmall ? 'small' : 'large';
    String host = isCouncil ? 'council' : 'club';

    File file = File('${AppConstants.deviceDirectoryPath}/$host($size)_$id');

    if (file.existsSync() == false) {
      http.get(url).catchError((error) {
        print('Error in downloading image : $error');
        print('for $host , id = $id');
      }).then((response) {
        if (response.statusCode == 200) {
          final imageData = response.bodyBytes.toList();
          final File writingFile =
              File('${AppConstants.deviceDirectoryPath}/$host($size)_$id');
          writingFile.writeAsBytesSync(imageData);
          print('image saved into disk = $host , id = $id');
        }
      });
    }
  }

  /// if file doesn't exist, null is returned
  ///
  /// if [isSmall] is false, then image will be considered as large
  ///
  /// [id] will be served for any option , [isCouncil] or [isClub] , whichever is true
  ///
  /// if [isCouncil] and [isClub] both are true/false, null will be returned

  static File getImageFile({
    bool isCouncil = false,
    bool isClub = false,
    @required bool isSmall,
    @required int id,
  }) {
    if ((isCouncil == true && isClub == true) ||
        (isCouncil == false && isClub == false) ||
        isSmall == null ||
        id == null) {
      return null;
    }

    String size = isSmall ? 'small' : 'large';
    File file;
    String host = isCouncil ? 'council' : 'club';
    file = File('${AppConstants.deviceDirectoryPath}/$host($size)_$id');

    if (file.existsSync()) {
      return file;
    } else
      return null;
  }

// TODO: we fetch council summaries only once in while initializing empty database, make it refreshable.

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
        await AppConstants.service.getCouncil(councilId);

    var councilPost = councilSnapshots.body;

    await helper.insertCouncilDetailsIntoDatabase(councilPost: councilPost);

    return councilPost;
  }

  static Future getClubDetailsFromDatabase({@required int clubId}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var database = await helper.database;

    BuiltClubPost clubPost =
        await helper.getClubDetails(db: database, clubId: clubId);

    if (clubPost == null) {
      Response<BuiltClubPost> clubSnapshots = await AppConstants.service
          .getClub(clubId, "token ${AppConstants.djangoToken}")
          .catchError((onError) {
        print("Error in fetching clubs: ${onError.toString()}");
      });
      clubPost = clubSnapshots.body;

      await helper.insertClubDetailsIntoDatabase(clubPost: clubPost);
    }

    return clubPost;
  }

  static Future updateClubDetailsInDatabase(
      {@required BuiltClubPost clubPost}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var database = await helper.database;

// here, we are not doing exactly like we did for council. because everytime we have to fetch workshops
// so  API request will be sent anyway. Therefore to ensure minimum requests, we will fetch all data altogether.
// Keep in mind: Use of local database is done to achieve quick fetching of club data except workshops

    await helper.deleteEntryOfClubDetail(db: database, clubId: clubPost.id);

    await helper.insertClubDetailsIntoDatabase(clubPost: clubPost);
  }

  static Future updateClubSubscriptionInDatabase(
      {@required int clubId,
      @required bool isSubscribed,
      @required int currentSubscribedUsers}) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var database = await helper.database;

    final subscribedUsers = currentSubscribedUsers + (isSubscribed ? 1 : -1);

    await helper.updateClubSubcription(
        db: database,
        clubId: clubId,
        isSubscribed: isSubscribed,
        subscribedUsers: subscribedUsers);
  }
}
