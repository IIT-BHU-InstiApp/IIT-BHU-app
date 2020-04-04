import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:iit_app/data/workshop.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

String workshopString = 'workshop';

String titleString = 'title';
String dateString = 'date';
String timeString = 'time';
String councilString = 'council';
String clubString = 'club';
String descriptionString = 'description';
String goingGlobalString = 'goingGlobal';
String showGoingString = 'showGoing';
String idString = 'id';

Map<String, dynamic> workshopInfoToMap(dynamic workshop) {
  Map<String, dynamic> map = {
    titleString: workshop.title,
    dateString: workshop.date,
    timeString: workshop.time,
    councilString: workshop.council,
    clubString: workshop.club,
    descriptionString: workshop.description,
    goingGlobalString: workshop.goingGlobal,
    showGoingString: (workshop.showGoing == true) ? 1 : 0,
    idString: workshop.id,
  };
  return map;
}

Workshop workshopInfoFromMap(dynamic map) {
  Workshop workshop = Workshop();
  workshop.title = map[titleString];
  workshop.date = map[dateString];
  workshop.time = map[timeString];
  workshop.council = map[councilString];
  workshop.club = map[clubString];
  workshop.description = map[descriptionString];
  workshop.goingGlobal = map[goingGlobalString];
  workshop.showGoing = (map[showGoingString] == 1) ? true : false;
  workshop.id = map[idString];

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
        '$titleString DEFAULT "", '
        '$dateString DEFAULT "", '
        '$timeString DEFAULT "", '
        '$councilString DEFAULT "", '
        '$clubString DEFAULT "", '
        '$descriptionString DEFAULT "", '
        '$goingGlobalString INTEGER NOT NULL, '
        '$showGoingString INTEGER NOT NULL, '
        '$idString INTEGER NOT NULL)');
  }

  // Database helper methods:

  Future insertWorkshopInfoIntoDatabase({@required BuiltPost post}) async {
    Database db = await workshopInfoDatabase;

    final workshop = Workshop.createWorkshopFromMap(post);

    await db.insert(workshopString, workshopInfoToMap(workshop));
  }

  Future<List<Workshop>> getAllWorkshopsInfo({@required Database db}) async {
    List<Map> maps = await db.query(
      workshopString,
      columns: [
        titleString,
        dateString,
        timeString,
        councilString,
        clubString,
        descriptionString,
        goingGlobalString,
        showGoingString,
        idString,
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
