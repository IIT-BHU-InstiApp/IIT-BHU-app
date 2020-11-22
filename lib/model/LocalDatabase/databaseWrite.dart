import 'package:flutter/foundation.dart';
import 'package:iit_app/model/LocalDatabase/databaseMapping.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/LocalDatabase/stringConstants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:built_collection/built_collection.dart';

class DatabaseWrite {
  // Inserting the data-----------------------------------------------------------------------

  static Future insertWorkshopSummaryIntoDatabase(
      {@required Database db, @required BuiltWorkshopSummaryPost post}) async {
    await db.insert(StringConst.workshopSummaryString, DatabaseMapping.workshopInfoToMap(post));
  }

  static Future insertCouncilSummaryIntoDatabase(
      {@required Database db, @required BuiltList<BuiltAllCouncilsPost> councils}) async {
    for (var council in councils) {
      await db.insert(
          StringConst.allCouncislSummaryString, DatabaseMapping.councilSummaryInfoToMap(council));
    }
  }

  static Future insertCouncilDetailsIntoDatabase(
      {@required Database db, @required BuiltCouncilPost councilPost}) async {
    await db.insert(
        StringConst.councilDetailString, DatabaseMapping.councilDetailToMap(councilPost));

    await insertPORHoldersIntoDatabase(
        db: db,
        councilId: councilPost.id,
        mainPOR: councilPost.gensec,
        jointPOR: councilPost.joint_gensec);

    await insertClubsSummaryIntoDatabase(db: db, clubs: councilPost.clubs);
  }

  static Future insertPORHoldersIntoDatabase(
      {@required Database db,
      int councilId = -1,
      int clubId = -1,
      @required SecyPost mainPOR,
      @required BuiltList<SecyPost> jointPOR}) async {
    if (mainPOR != null) {
      await db.insert(StringConst.porHoldersString,
          DatabaseMapping.porInfoToMap(por: mainPOR, councilId: councilId, clubId: clubId));
    }

    jointPOR?.forEach((joint) async {
      await db.insert(StringConst.porHoldersString,
          DatabaseMapping.porInfoToMap(por: joint, councilId: councilId, clubId: clubId));
    });
  }

  static Future insertClubsSummaryIntoDatabase(
      {@required Database db, @required BuiltList<ClubListPost> clubs}) async {
    for (var club in clubs) {
      await db.insert(StringConst.clubSummaryString, DatabaseMapping.clubSummaryInfoToMap(club));
    }
  }

  static Future insertClubDetailsIntoDatabase(
      {@required Database db, @required BuiltClubPost clubPost}) async {
    await db.insert(StringConst.clubDetailsString, DatabaseMapping.clubDetailToMap(clubPost));

    await insertPORHoldersIntoDatabase(
        db: db, clubId: clubPost.id, mainPOR: clubPost.secy, jointPOR: clubPost.joint_secy);
  }

  static Future insertEntitiesSummaryIntoDatabase(
      {@required Database db, @required BuiltList<EntityListPost> entities}) async {
    for (var entity in entities) {
      await db.insert(
          StringConst.entitySummaryString, DatabaseMapping.entitySummaryInfoToMap(entity));
    }
  }

  static Future insertEntityDetailsIntoDatabase(
      {@required Database db, @required BuiltEntityPost entityPost}) async {
    await db.insert(StringConst.entityDetailsString, DatabaseMapping.entityDetailToMap(entityPost));

    await insertPointOfContactIntoDatabase(db: db, poc: entityPost.point_of_contact);
  }

  static Future insertPointOfContactIntoDatabase(
      {@required Database db, int entityId = -1, @required BuiltList<SecyPost> poc}) async {
    poc?.forEach((secy) async {
      await db.insert(StringConst.porHoldersString,
          DatabaseMapping.porInfoToMap(por: secy, entityId: entityId));
    });
  }

  // Updating the data-------------------------------------------------------------------------------

  static Future updateClubSubcription(
      {@required Database db,
      @required int clubId,
      @required bool isSubscribed,
      @required int subscribedUsers}) async {
    await db.update(
      StringConst.clubDetailsString,
      {
        StringConst.isSubscribedString: isSubscribed ? 1 : 0,
        StringConst.subscribedUsersString: subscribedUsers
      },
      where: '${StringConst.idString}  = $clubId',
    );
  }

  static Future updateEntitySubcription(
      {@required Database db,
      @required int entityId,
      @required bool isSubscribed,
      @required int subscribedUsers}) async {
    await db.update(
      StringConst.entityDetailsString,
      {
        StringConst.isSubscribedString: isSubscribed ? 1 : 0,
        StringConst.subscribedUsersString: subscribedUsers
      },
      where: '${StringConst.idString}  = $entityId',
    );
  }

  // Deleting the data-----------------------------------------------------------------------

  static Future deleteEntryOfCouncilDetail({@required Database db, @required int councilId}) async {
    await db.delete(StringConst.councilDetailString, where: '${StringConst.idString} = $councilId');

    await db.delete(StringConst.porHoldersString,
        where: '${StringConst.councilIdString} = $councilId');

    await db.delete(StringConst.clubSummaryString,
        where: '${StringConst.councilIdString} = $councilId');
  }

  static Future deleteEntryOfClubDetail({@required Database db, @required int clubId}) async {
    await db.delete(StringConst.clubDetailsString, where: '${StringConst.idString} = $clubId');

    await db.delete(StringConst.porHoldersString, where: '${StringConst.clubIdString} = $clubId');
  }

  static Future deleteEntryOfEntityDetail({@required Database db, @required int entityId}) async {
    await db.delete(StringConst.entityDetailsString, where: '${StringConst.idString} = $entityId');

    await db.delete(StringConst.porHoldersString,
        where: '${StringConst.entityIdString} = $entityId');
  }

  static Future deleteAllWorkshopsSummary({@required Database db}) async {
    await db.delete(StringConst.workshopSummaryString);
  }

  static Future deleteAllCouncilsSummary({@required Database db}) async {
    await db.delete(StringConst.allCouncislSummaryString);
  }

  static Future deleteAllCouncilDetails({@required Database db}) async {
    await db.delete(StringConst.councilDetailString);
  }

  static Future deleteAllPORHolders({@required Database db}) async {
    await db.delete(StringConst.porHoldersString);
  }

  static Future deleteAllClubSummary({@required Database db}) async {
    await db.delete(StringConst.clubSummaryString);
  }

  static Future deleteAllEntitySummary({@required Database db}) async {
    await db.delete(StringConst.entitySummaryString);
  }

  static Future deleteAllClubDetails({@required Database db}) async {
    await db.delete(StringConst.clubDetailsString);
  }

  static Future deleteAllEntityDetails({@required Database db}) async {
    await db.delete(StringConst.entityDetailsString);
  }

  static Future deleteWholeDatabase({@required Database db}) async {
    await deleteAllWorkshopsSummary(db: db);
    await deleteAllCouncilsSummary(db: db);
    await deleteAllCouncilDetails(db: db);
    await deleteAllPORHolders(db: db);
    await deleteAllClubSummary(db: db);
    await deleteAllClubDetails(db: db);
    await deleteAllEntitySummary(db: db);
    await deleteAllEntityDetails(db: db);
  }
}
