import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:built_collection/built_collection.dart';

String workshopSummaryString = 'workshopSummary'; //*table name

String idString = 'id';
String clubIdString = 'clubId';
String clubString = 'club';
String councilIdString = 'councilId';
String smallImageUrlString = 'smallImageUrl';
String largeImageUrlString = 'largeImageUrl';
String titleString = 'title';
String dateString = 'date';
String timeString = 'time';
String interestedString = 'interested';

String allCouncislSummaryString = 'allCouncilsSummary'; //*table name

String councilDetailString = 'councilDetail'; //*table name

String nameString = 'name';
String descriptionString = 'description';
String gensecIdString = 'gensecId';
String jointGensecId1String = 'jointGensecId1';
String jointGensecId2String = 'jointGensecId2';

// String parentIdString = 'parentId';

String porHoldersString = 'porHolders'; //*table name

String emailString = 'email';
String phoneNumberString = 'phoneNumber';
String photoUrlString = 'photoUrl';

String clubSummaryString = 'clubSummary'; //*table name

Map<String, dynamic> workshopInfoToMap(BuiltWorkshopSummaryPost workshop) {
  Map<String, dynamic> map = {
    idString: workshop.id,
    clubIdString: workshop.club.id,
    clubString: workshop.club.name == null ? '' : workshop.club.name,
    councilIdString: workshop.club.council,
    smallImageUrlString: workshop.club.small_image_url == null
        ? ''
        : workshop.club.small_image_url,
    largeImageUrlString: workshop.club.large_image_url == null
        ? ''
        : workshop.club.large_image_url,
    titleString: workshop.title == null ? '' : workshop.title,
    dateString: workshop.date == null ? '' : workshop.date,
    timeString: workshop.time == null ? '' : workshop.time,
  };
  return map;
}

Map<String, dynamic> councilSummaryInfoToMap(
    BuiltAllCouncilsPost councilSummary) {
  Map<String, dynamic> map = {
    idString: councilSummary.id,
    nameString: councilSummary.name == null ? '' : councilSummary.name,
    smallImageUrlString: councilSummary.small_image_url == null
        ? ''
        : councilSummary.small_image_url,
    largeImageUrlString: councilSummary.large_image_url == null
        ? ''
        : councilSummary.large_image_url,
  };
  return map;
}

Map<String, dynamic> councilDetailToMap(BuiltCouncilPost councilPost) {
  Map<String, dynamic> map = {
    idString: councilPost.id,
    nameString: councilPost.name == null ? '' : councilPost.name,
    descriptionString:
        councilPost.description == null ? '' : councilPost.description,
    gensecIdString: councilPost.gensec == null ? -1 : councilPost.gensec.id,
    jointGensecId1String: (councilPost.joint_gensec.isEmpty)
        ? -1
        : councilPost.joint_gensec[0].id,
    jointGensecId2String: (councilPost.joint_gensec.length < 2)
        ? -1
        : councilPost.joint_gensec[1].id,
    smallImageUrlString:
        councilPost.small_image_url == null ? '' : councilPost.small_image_url,
    largeImageUrlString:
        councilPost.large_image_url == null ? '' : councilPost.large_image_url,
  };
  return map;
}

Map<String, dynamic> porInfoToMap(SecyPost por, int councilId) {
  Map<String, dynamic> map = {
    idString: por.id,
    councilIdString: councilId,
    nameString: por.name == null ? '' : por.name,
    emailString: por.email == null ? '' : por.email,
    phoneNumberString: por.phone_number == null ? '' : por.phone_number,
    photoUrlString: por.photo_url == null ? '' : por.photo_url,
  };
  return map;
}

Map<String, dynamic> clubSummaryInfoToMap(ClubListPost clubSummary) {
  Map<String, dynamic> map = {
    idString: clubSummary.id,
    nameString: clubSummary.name == null ? '' : clubSummary.name,
    councilIdString: clubSummary.council == null ? '' : clubSummary.council,
    smallImageUrlString:
        clubSummary.small_image_url == null ? '' : clubSummary.small_image_url,
    largeImageUrlString:
        clubSummary.large_image_url == null ? '' : clubSummary.large_image_url,
  };
  return map;
}

BuiltWorkshopSummaryPost workshopSummaryFromMap(dynamic map) {
  final workshop = BuiltWorkshopSummaryPost((b) => b
    ..id = map[idString]
    ..club.id = map[clubIdString]
    ..club.name = map[clubString]
    ..club.council = map[councilIdString]
    ..club.small_image_url = map[smallImageUrlString]
    ..club.large_image_url = map[largeImageUrlString]
    ..title = map[titleString]
    ..date = map[dateString]
    ..time = map[timeString]);
  return workshop;
}

BuiltAllCouncilsPost councilSummaryFromMap(dynamic map) {
  final council = BuiltAllCouncilsPost((b) => b
    ..id = map[idString]
    ..name = map[nameString]
    ..small_image_url = map[smallImageUrlString]
    ..large_image_url = map[largeImageUrlString]);
  return council;
}

// var councilDetailFromMap(dynamic map) { }

SecyPost porHolderInfoFromMap(dynamic map) {
  final porHolder = SecyPost((b) => b
    ..id = map[idString]
    ..name = map[nameString]
    ..email = map[emailString]
    ..phone_number = map[phoneNumberString]
    ..photo_url = map[photoUrlString]);
  return porHolder;
}

ClubListPost clubSummaryFromMap(dynamic map) {
  final clubSummary = ClubListPost((b) => b
    ..id = map[idString]
    ..name = map[nameString]
    ..council = map[councilIdString]
    ..small_image_url = map[smallImageUrlString]
    ..large_image_url = map[largeImageUrlString]);
  return clubSummary;
}

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
  _initDatabase() async {
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

  Future _onDatabaseCreate(Database db, int version) async {
// for workshops summary on homepage

    await db.execute('CREATE TABLE $workshopSummaryString ('
        '$idString INTEGER NOT NULL, '
        '$clubIdString INTEGER NOT NULL, '
        '$clubString DEFAULT "", '
        '$councilIdString INTEGER NOT NULL, '
        '$smallImageUrlString DEFAULT "", '
        '$largeImageUrlString DEFAULT "", '
        '$titleString DEFAULT "", '
        '$dateString DEFAULT "", '
        '$timeString DEFAULT "")');

// for council buttons

    await db.execute('CREATE TABLE $allCouncislSummaryString ('
        '    $idString INTEGER NOT NULL,'
        '        $nameString DEFAULT "",'
        '  $smallImageUrlString DEFAULT "",'
        '$largeImageUrlString DEFAULT "")');

// for council page

    await db.execute('      CREATE TABLE $councilDetailString ('
        '        $idString INTEGER NOT NULL,'
        '        $nameString DEFAULT "",'
        '        $descriptionString DEFAULT "",'
        '        $gensecIdString INTEGER,'
        '        $jointGensecId1String INTEGER,'
        '        $jointGensecId2String INTEGER,'
        '        $smallImageUrlString DEFAULT "",'
        '        $largeImageUrlString DEFAULT "")');

// TODO: fetch clubs for a particular council by using its id named as councilId in clubs.

    await db.execute('      CREATE TABLE $porHoldersString ('
        '        $idString INTEGER NOT NULL,'
        // councilId is only to ease the deletion
        '        $councilIdString INTEGER NOT NULL,'
        '        $nameString DEFAULT "",'
        '        $emailString DEFAULT "",'
        '        $phoneNumberString DEFAULT "",'
        '        $photoUrlString DEFAULT "")');

    await db.execute('      CREATE TABLE $clubSummaryString ('
        '        $idString INTEGER NOT NULL,'
        '        $nameString DEFAULT "",'
        '        $councilIdString INTEGER,'
        '        $smallImageUrlString DEFAULT "",'
        '        $largeImageUrlString DEFAULT "")');
  }

  // Database helper methods:

  Future insertWorkshopSummaryIntoDatabase(
      {@required BuiltWorkshopSummaryPost post}) async {
    Database db = await database;
    await db.insert(workshopSummaryString, workshopInfoToMap(post));
  }

  Future insertCouncilSummaryIntoDatabase(
      {@required BuiltAllCouncilsPost councilSummary}) async {
    Database db = await database;
    await db.insert(
        allCouncislSummaryString, councilSummaryInfoToMap(councilSummary));
  }

  Future insertCouncilDetailsIntoDatabase(
      {@required BuiltCouncilPost councilPost}) async {
    Database db = await database;

    await db.insert(councilDetailString, councilDetailToMap(councilPost));

    await insertPORHoldersIntoDatabase(
        db: db,
        councilId: councilPost.id,
        mainPOR: councilPost.gensec,
        jointPOR: councilPost.joint_gensec);

    await insertClubsSummaryIntoDatabase(db: db, clubs: councilPost.clubs);
  }

  Future insertPORHoldersIntoDatabase(
      {@required Database db,
      @required int councilId,
      @required SecyPost mainPOR,
      @required BuiltList<SecyPost> jointPOR}) async {
    if (mainPOR != null) {
      await db.insert(porHoldersString, porInfoToMap(mainPOR, councilId));
    }

    if (jointPOR.isEmpty != true) {
      await db.insert(porHoldersString, porInfoToMap(jointPOR[0], councilId));

      if (jointPOR.length > 1) {
        await db.insert(porHoldersString, porInfoToMap(jointPOR[1], councilId));
      }
    }
  }

  Future insertClubsSummaryIntoDatabase(
      {@required Database db, @required BuiltList<ClubListPost> clubs}) async {
    for (var club in clubs) {
      await db.insert(clubSummaryString, clubSummaryInfoToMap(club));
    }
  }

  Future<BuiltList<BuiltWorkshopSummaryPost>> getAllWorkshopsSummary(
      {@required Database db}) async {
    List<Map> maps = await db.query(
      workshopSummaryString,
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

    if (maps.isEmpty) {
      return null;
    }

    BuiltList<BuiltWorkshopSummaryPost> list =
        BuiltList<BuiltWorkshopSummaryPost>([]);
    var builder = list.toBuilder();

    for (var map in maps) {
      BuiltWorkshopSummaryPost workshop = workshopSummaryFromMap(map);
      builder.add(workshop);
    }
    var workshops = builder.build();
    return workshops;
  }

  Future<BuiltList<BuiltAllCouncilsPost>> getAllCouncilsSummary(
      {@required Database db}) async {
    List<Map> maps = await db.query(allCouncislSummaryString,
        columns: [
          idString,
          nameString,
          smallImageUrlString,
          largeImageUrlString,
        ],
        orderBy: idString);

    BuiltList<BuiltAllCouncilsPost> list = BuiltList<BuiltAllCouncilsPost>([]);
    var builder = list.toBuilder();

    for (var map in maps) {
      builder.add(councilSummaryFromMap(map));
    }

    var councilsSummary = builder.build();
    return councilsSummary;
  }

// TODO; fetch council only when its required , do not store all councils beforehand.

  Future<BuiltCouncilPost> getCouncilDetail(
      {@required Database db, @required int councilId}) async {
    // it will return only 1 map as every council has unique id

    List<Map> maps = await db.query(
      councilDetailString,
      columns: [
        idString,
        nameString,
        descriptionString,
        gensecIdString,
        jointGensecId1String,
        jointGensecId2String,
        smallImageUrlString,
        largeImageUrlString,
      ],
      where: '$idString  = $councilId',
    );

    print(
        'council id = $councilId -----------------------------------------------------');
    print(maps.length);

    if (maps.isEmpty) {
      return null;
    }

    var map = maps[0];

    SecyPost gensec;
    if (map[gensecIdString] != -1) {
      gensec = await getPORHolderInfo(db: db, porId: map[gensecIdString]);
    }

    BuiltList<SecyPost> porList = BuiltList<SecyPost>([]);
    var porBuilder = porList.toBuilder();

    if (map[jointGensecId1String] != -1) {
      var jg1 =
          await getPORHolderInfo(db: db, porId: map[jointGensecId1String]);
      porBuilder.add(jg1);
    }

    if (map[jointGensecId2String] != -1) {
      var jg2 =
          await getPORHolderInfo(db: db, porId: map[jointGensecId2String]);
      porBuilder.add(jg2);
    }

    BuiltList<SecyPost> jointGensec = porBuilder.build();

    BuiltList<ClubListPost> clubs =
        await getClubsSummary(db: db, councilId: councilId);

    final BuiltCouncilPost councilDetail = BuiltCouncilPost((b) => b
      ..id = map[idString]
      ..name = map[nameString]
      ..description = map[descriptionString]
      ..gensec = gensec.toBuilder()
      ..joint_gensec = jointGensec.toBuilder()
      ..clubs = clubs.toBuilder()
      ..small_image_url = map[smallImageUrlString]
      ..large_image_url = map[largeImageUrlString]);
    return councilDetail;
  }

  Future<SecyPost> getPORHolderInfo(
      {@required Database db, @required int porId}) async {
    // it will return only 1 map as every POR Holder has unique id

    List<Map> maps = await db.query(
      porHoldersString,
      columns: [
        idString,
        nameString,
        emailString,
        phoneNumberString,
        photoUrlString,
      ],
      where: '$idString  = $porId',
    );

    var map = maps[0];

    SecyPost porHolder = porHolderInfoFromMap(map);

    return porHolder;
  }

  Future<BuiltList<ClubListPost>> getClubsSummary(
      {@required Database db, @required councilId}) async {
    List<Map> maps = await db.query(
      clubSummaryString,
      columns: [
        idString,
        nameString,
        councilIdString,
        smallImageUrlString,
        largeImageUrlString,
      ],
      where: '$councilIdString  = $councilId',
    );

    BuiltList<ClubListPost> list = BuiltList<ClubListPost>([]);
    var builder = list.toBuilder();

    for (var map in maps) {
      builder.add(clubSummaryFromMap(map));
    }

    var clubsSummary = builder.build();
    return clubsSummary;
  }

  Future deleteWorkshopsSummary({@required Database db}) async {
    await db.delete(workshopSummaryString);
  }

  Future deleteAllCouncilsSummary({@required Database db}) async {
    await db.delete(allCouncislSummaryString);
  }

  Future deleteEntryOfCouncilDetail(
      {@required Database db, @required int councilId}) async {
    await db.delete(councilDetailString, where: '$idString = $councilId');
    await db.delete(porHoldersString, where: '$councilIdString = $councilId');
    await db.delete(clubSummaryString, where: '$councilIdString = $councilId');
  }

  Future closeDatabase({@required Database db}) async => db.close();
}
