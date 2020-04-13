import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:iit_app/data/workshop.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

String workshopString = 'workshop';

String idString = 'id';
String clubIdString = 'clubId';
String clubString = 'club';
String councilIdString = 'councilId';
String smallImageUrlString = 'smallImageUrl';
String largeImageUrlString = 'largeImageUrl';
String titleString = 'title';
String dateString = 'date';
String timeString = 'time';

Map<String, dynamic> workshopInfoToMap(dynamic workshop) {
  Map<String, dynamic> map = {
    idString: workshop.id,
    clubIdString: workshop.clubId,
    clubString: workshop.club,
    councilIdString: workshop.councilId,
    smallImageUrlString: workshop.smallImageUrl,
    largeImageUrlString: workshop.largeImageUrl,
    titleString: workshop.title,
    dateString: workshop.date,
    timeString: workshop.time,
  };
  return map;
}

Workshop workshopInfoFromMap(dynamic map) {
  Workshop workshop = Workshop();
  workshop.id = map[idString];
  workshop.clubId = map[clubIdString];
  workshop.club = map[clubString];
  workshop.councilId = map[councilIdString];
  workshop.smallImageUrl = map[smallImageUrlString];
  workshop.largeImageUrl = map[largeImageUrlString];
  workshop.title = map[titleString];
  workshop.date = map[dateString];
  workshop.time = map[timeString];

  return workshop;
}

// singleton class to manage the database
class DatabaseHelper {
// This is the actual database filename that is saved in the docs directory.

  static final _workshopInfoDatabaseName = 'WorkshopInfoDatabase.db';
  // static final _workshopInfoDatabaseNameTwo = 'WorkshopInfoDatabaseTwo.db';

// Increment this version when you need to change the schema.
  static final _workshopInfoDatabaseVersion = 1;

// Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

// Only allow a single open connection to the database.
  static Database _workshopInfoDatabase;
  // static Database _workshopInfoDatabaseTwo;

  Future<bool> checkDatabaseIfEmpty() async {
    if (_workshopInfoDatabase == null) {
      return true;
    }
    return false;
  }

  Future<Database> get workshopInfoDatabase async {
    if (_workshopInfoDatabase != null) {
      // print('workshopInfoDatabase has values');
      return _workshopInfoDatabase;
    }
    // print('workshopInfoDatabase is empty');
    _workshopInfoDatabase = await _initWorkshopInfoDatabase();
    return _workshopInfoDatabase;
  }

// open the database
  _initWorkshopInfoDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + _workshopInfoDatabaseName;
    // print('path of Database Info: $path');
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _workshopInfoDatabaseVersion,
        onCreate: _onWorkshopInfoDatabaseCreate);
  }
  // SQL string to create the database

  Future _onWorkshopInfoDatabaseCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $workshopString ('
        '$idString INTEGER NOT NULL, '
        '$clubIdString INTEGER NOT NULL, '
        '$clubString DEFAULT "", '
        '$councilIdString INTEGER NOT NULL, '
        '$smallImageUrlString DEFAULT "", '
        '$largeImageUrlString DEFAULT "", '
        '$titleString DEFAULT "", '
        '$dateString DEFAULT "", '
        '$timeString DEFAULT "")');
  }

  // Database helper methods:

  Future insertWorkshopInfoIntoDatabase(
      {@required BuiltWorkshopSummaryPost post}) async {
    Database db = await workshopInfoDatabase;

    final workshop = Workshop.createWorkshopFromMap(post);

    await db.insert(workshopString, workshopInfoToMap(workshop));
  }

  Future<List<Workshop>> getAllWorkshopsInfo({@required Database db}) async {
    List<Map> maps = await db.query(
      workshopString,
      columns: [
        idString,
        clubIdString,
        clubString,
        councilIdString,
        smallImageUrlString,
        largeImageUrlString,
        titleString,
        dateString,
        timeString,
      ],
    );

    List<Workshop> workshops = [];
    for (var map in maps) {
      Workshop workshop = workshopInfoFromMap(map);
      workshops.add(workshop);
    }
    return workshops;
  }

  Future deleteWorkshopInfo({@required Database db}) async {
    await db.delete(workshopString);
  }

  Future closeDatabase({@required Database db}) async => db.close();
}
