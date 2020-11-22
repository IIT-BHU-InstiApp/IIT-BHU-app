import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'stringConstants.dart';

// singleton class to manage the database
class DatabaseHelper {
// This is the actual database filename that is saved in the docs directory.

  static final _databaseName = 'WorkshopInfoDatabase.db';
  // static final _databaseNameTwo = 'WorkshopInfoDatabaseTwo.db';

// Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

// Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

// Only allow a single open connection to the database.
  static Database _database;
  // static Database _databaseTwo;

  Future<bool> checkDatabaseIfEmpty() async {
    if (_database == null) {
      return true;
    }
    return false;
  }

  Future<Database> get database async {
    if (_database != null) {
      // print('database has values');
      return _database;
    }
    // print('database is empty');
    _database = await _initDatabase();
    return _database;
  }

// open the database
  static _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + _databaseName;
    // print('path of Database Info: $path');
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onDatabaseCreate,
    );
  }
  // SQL string to create the database

  static Future _onDatabaseCreate(Database db, int version) async {
// for workshops summary on homepage

    await db.execute('CREATE TABLE ${StringConst.workshopSummaryString} ('
        '       ${StringConst.idString} INTEGER NOT NULL, '
        '       ${StringConst.clubIdString} INTEGER, '
        '       ${StringConst.clubString} DEFAULT "", '
        '       ${StringConst.councilIdString} INTEGER, '
        '       ${StringConst.entityIdString} INTEGER, '
        '       ${StringConst.entityString} DEFAULT "", '
        '       ${StringConst.smallImageUrlString} DEFAULT "", '
        '       ${StringConst.largeImageUrlString} DEFAULT "", '
        '       ${StringConst.titleString} DEFAULT "", '
        '       ${StringConst.dateString} DEFAULT "", '
        '       ${StringConst.timeString} DEFAULT "")');

// for council buttons

    await db.execute('CREATE TABLE ${StringConst.allCouncislSummaryString} ('
        '       ${StringConst.idString} INTEGER NOT NULL,'
        '       ${StringConst.nameString} DEFAULT "",'
        '       ${StringConst.smallImageUrlString} DEFAULT "",'
        '       ${StringConst.largeImageUrlString} DEFAULT "")');

// for council page

    await db.execute('      CREATE TABLE ${StringConst.councilDetailString} ('
        '        ${StringConst.idString} INTEGER NOT NULL,'
        '        ${StringConst.nameString} DEFAULT "",'
        '        ${StringConst.descriptionString} DEFAULT "",'
        '        ${StringConst.gensecIdString} INTEGER,'
        '        ${StringConst.jointGensecId1String} INTEGER,'
        '        ${StringConst.jointGensecId2String} INTEGER,'
        '        ${StringConst.smallImageUrlString} DEFAULT "",'
        '        ${StringConst.largeImageUrlString} DEFAULT "",'
        '        ${StringConst.isPORHolderString} INTEGER,'
        '        ${StringConst.websiteUrlString} DEFAULT "",'
        '        ${StringConst.facebookUrlString} DEFAULT "",'
        '        ${StringConst.twitterUrlString} DEFAULT "",'
        '        ${StringConst.instagramUrlString} DEFAULT "",'
        '        ${StringConst.linkedinUrlString} DEFAULT "",'
        '        ${StringConst.youtubeUrlString} DEFAULT "")');

    await db.execute('      CREATE TABLE ${StringConst.porHoldersString} ('
        '        ${StringConst.idString} INTEGER NOT NULL,'

        // councilId is only to ease the deletion while deleting coucil information
        '        ${StringConst.councilIdString} INTEGER ,'

        // clubId is only to ease the deletion while deleting club information
        '        ${StringConst.clubIdString} INTEGER,'

        // entityId is only to ease the deletion while deleting entity information
        '        ${StringConst.entityIdString} INTEGER,'
        //
        '        ${StringConst.nameString} DEFAULT "",'
        '        ${StringConst.emailString} DEFAULT "",'
        '        ${StringConst.phoneNumberString} DEFAULT "",'
        '        ${StringConst.photoUrlString} DEFAULT "")');

    await db.execute('      CREATE TABLE ${StringConst.clubSummaryString} ('
        '        ${StringConst.idString} INTEGER NOT NULL,'
        '        ${StringConst.nameString} DEFAULT "",'
        '        ${StringConst.councilIdString} INTEGER,'
        '        ${StringConst.smallImageUrlString} DEFAULT "",'
        '        ${StringConst.largeImageUrlString} DEFAULT "")');

// for club page

    await db.execute('      CREATE TABLE ${StringConst.clubDetailsString} ('
        '        ${StringConst.idString} INTEGER NOT NULL,'
        '        ${StringConst.nameString} DEFAULT "",'
        '        ${StringConst.descriptionString} DEFAULT "",'
        '        ${StringConst.councilIdString} INTEGER,'
        '        ${StringConst.councilNameString} DEFAULT "",'
        '        ${StringConst.councilSmallImageUrlString} DEFAULT "",'
        '        ${StringConst.councilLargeImageUrlString} DEFAULT "",'
        '        ${StringConst.secyIdString} INTEGER,'
        '        ${StringConst.jointSecyId1String} INTEGER,'
        '        ${StringConst.jointSecyId2String} INTEGER,'
        '        ${StringConst.smallImageUrlString} DEFAULT "",'
        '        ${StringConst.largeImageUrlString} DEFAULT "",'
        '        ${StringConst.isSubscribedString} INTEGER,'
        '        ${StringConst.subscribedUsersString} INTEGER,'
        '        ${StringConst.isPORHolderString} INTEGER,'
        '        ${StringConst.websiteUrlString} DEFAULT "",'
        '        ${StringConst.facebookUrlString} DEFAULT "",'
        '        ${StringConst.twitterUrlString} DEFAULT "",'
        '        ${StringConst.instagramUrlString} DEFAULT "",'
        '        ${StringConst.linkedinUrlString} DEFAULT "",'
        '        ${StringConst.youtubeUrlString} DEFAULT "")');

    // for entity buttons

    await db.execute('CREATE TABLE ${StringConst.entitySummaryString} ('
        '       ${StringConst.idString} INTEGER NOT NULL,'
        '       ${StringConst.nameString} DEFAULT "",'
        '       ${StringConst.smallImageUrlString} DEFAULT "",'
        '       ${StringConst.largeImageUrlString} DEFAULT "")');

    // for entity page

    await db.execute('      CREATE TABLE ${StringConst.entityDetailsString} ('
        '        ${StringConst.idString} INTEGER NOT NULL,'
        '        ${StringConst.nameString} DEFAULT "",'
        '        ${StringConst.descriptionString} DEFAULT "",'
        '        ${StringConst.pointOfContactAsStringArrayString} DEFAULT "",'
        '        ${StringConst.smallImageUrlString} DEFAULT "",'
        '        ${StringConst.largeImageUrlString} DEFAULT "",'
        '        ${StringConst.isSubscribedString} INTEGER,'
        '        ${StringConst.subscribedUsersString} INTEGER,'
        '        ${StringConst.isPORHolderString} INTEGER,'
        '        ${StringConst.websiteUrlString} DEFAULT "",'
        '        ${StringConst.facebookUrlString} DEFAULT "",'
        '        ${StringConst.twitterUrlString} DEFAULT "",'
        '        ${StringConst.instagramUrlString} DEFAULT "",'
        '        ${StringConst.linkedinUrlString} DEFAULT "",'
        '        ${StringConst.youtubeUrlString} DEFAULT "")');
  }

  Future closeDatabase({@required Database db}) async => db.close();
}
