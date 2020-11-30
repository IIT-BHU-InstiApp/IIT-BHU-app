import 'package:flutter/foundation.dart';
import 'package:iit_app/model/LocalDatabase/databaseMapping.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/LocalDatabase/stringConstants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:built_collection/built_collection.dart';

class DatabaseQuery {
  // Fetching the data-----------------------------------------------------------------------

  static Future<BuiltList<BuiltWorkshopSummaryPost>> getAllWorkshopsSummary(
      {@required Database db}) async {
    List<Map> maps = await db.query(
      StringConst.workshopSummaryString,
      columns: [
        StringConst.idString,
        StringConst.isWorkshopString,
        StringConst.clubIdString,
        StringConst.clubString,
        StringConst.councilIdString,
        StringConst.entityIdString,
        StringConst.entityString,
        StringConst.smallImageUrlString,
        StringConst.largeImageUrlString,
        StringConst.titleString,
        StringConst.dateString,
        StringConst.timeString,
      ],
    );

    if (maps.isEmpty) {
      return null;
    }

    BuiltList<BuiltWorkshopSummaryPost> list =
        BuiltList<BuiltWorkshopSummaryPost>([]);
    var builder = list.toBuilder();

    for (var map in maps) {
      // need to fetch council summary data

      BuiltAllCouncilsPost councilSummary = await getCouncilsSummaryById(
          db: db, councilId: map[StringConst.councilIdString]);

      BuiltWorkshopSummaryPost workshop =
          DatabaseMapping.workshopSummaryFromMap(map, councilSummary);
      builder.add(workshop);
    }
    var workshops = builder.build();
    return workshops;
  }

  static Future<BuiltAllCouncilsPost> getCouncilsSummaryById(
      {@required Database db, @required int councilId}) async {
    if (councilId == null) return null;

    List<Map> maps = await db.query(
      StringConst.allCouncislSummaryString,
      columns: [
        StringConst.idString,
        StringConst.nameString,
        StringConst.smallImageUrlString,
        StringConst.largeImageUrlString,
      ],
      where: '${StringConst.idString}  = $councilId',
    );

    if (maps.isEmpty) {
      return null;
    }

    var map = maps[0];

    BuiltAllCouncilsPost councilSummary =
        DatabaseMapping.councilSummaryFromMap(map);

    return councilSummary;
  }

  static Future<BuiltList<BuiltAllCouncilsPost>> getAllCouncilsSummary(
      {@required Database db}) async {
    List<Map> maps = await db.query(StringConst.allCouncislSummaryString,
        columns: [
          StringConst.idString,
          StringConst.nameString,
          StringConst.smallImageUrlString,
          StringConst.largeImageUrlString,
        ],
        orderBy: StringConst.idString);

    BuiltList<BuiltAllCouncilsPost> list = BuiltList<BuiltAllCouncilsPost>([]);
    var builder = list.toBuilder();

    for (var map in maps) {
      builder.add(DatabaseMapping.councilSummaryFromMap(map));
    }

    var councilsSummary = builder.build();
    return councilsSummary;
  }

// TODO; fetch council only when its required , do not store all councils beforehand.

  static Future<BuiltCouncilPost> getCouncilDetail(
      {@required Database db, @required int councilId}) async {
    // it will return only 1 map as every council has unique id

    List<Map> maps = await db.query(
      StringConst.councilDetailString,
      columns: [
        StringConst.idString,
        StringConst.nameString,
        StringConst.descriptionString,
        StringConst.mainPoRString,
        StringConst.jointPoRListAsStringString,
        StringConst.smallImageUrlString,
        StringConst.largeImageUrlString,
        StringConst.isPORHolderString,
        StringConst.websiteUrlString,
        StringConst.facebookUrlString,
        StringConst.twitterUrlString,
        StringConst.instagramUrlString,
        StringConst.linkedinUrlString,
        StringConst.youtubeUrlString,
      ],
      where: '${StringConst.idString}  = $councilId',
    );

    if (maps.isEmpty) {
      return null;
    }

    var map = maps[0];

    SecyPost gensec;

    if (map[StringConst.mainPoRString] != -1) {
      gensec =
          await getPORHolderInfo(db: db, porId: map[StringConst.mainPoRString]);
    }

    List<int> secies = [];
    (map[StringConst.jointPoRListAsStringString] ?? '')
        ?.split(' ')
        ?.forEach((secyId) {
      final id = int.tryParse(secyId);
      if (id != null) secies.add(id);
    });

    BuiltList<SecyPost> jointSecyList = BuiltList<SecyPost>([]);
    var jointSecyBuilder = jointSecyList.toBuilder();

    secies?.forEach((element) async {
      final secy = await getPORHolderInfo(db: db, porId: element);
      if (secy != null) jointSecyBuilder.add(secy);
    });

    BuiltList<ClubListPost> clubs =
        await getClubsSummary(db: db, councilId: councilId);

    final BuiltCouncilPost councilDetails = BuiltCouncilPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..description = map[StringConst.descriptionString]
      ..gensec = (gensec?.toBuilder())
      ..joint_gensec = jointSecyBuilder
      ..clubs = (clubs?.toBuilder())
      ..small_image_url = map[StringConst.smallImageUrlString]
      ..large_image_url = map[StringConst.largeImageUrlString]
      ..is_por_holder = map[StringConst.isPORHolderString] == 1 ? true : false
      ..website_url = map[StringConst.websiteUrlString]
      ..facebook_url = map[StringConst.facebookUrlString]
      ..twitter_url = map[StringConst.twitterUrlString]
      ..instagram_url = map[StringConst.instagramUrlString]
      ..linkedin_url = map[StringConst.linkedinUrlString]
      ..youtube_url = map[StringConst.youtubeUrlString]);

    return councilDetails;
  }

  static Future<SecyPost> getPORHolderInfo(
      {@required Database db, @required int porId}) async {
    // it will return only 1 map as every POR Holder has unique id

    List<Map> maps = await db.query(
      StringConst.porHoldersString,
      columns: [
        StringConst.idString,
        StringConst.nameString,
        StringConst.emailString,
        StringConst.phoneNumberString,
        StringConst.photoUrlString,
      ],
      where: '${StringConst.idString}  = $porId',
    );

    if (maps == null || maps.length == 0) return null;

    var map = maps[0];

    SecyPost porHolder = DatabaseMapping.porHolderInfoFromMap(map);

    return porHolder;
  }

  static Future<BuiltList<ClubListPost>> getClubsSummary(
      {@required Database db, @required councilId}) async {
    List<Map> maps = await db.query(
      StringConst.clubSummaryString,
      columns: [
        StringConst.idString,
        StringConst.nameString,
        StringConst.councilIdString,
        StringConst.smallImageUrlString,
        StringConst.largeImageUrlString,
      ],
      where: '${StringConst.councilIdString}  = $councilId',
    );

    BuiltList<ClubListPost> list = BuiltList<ClubListPost>([]);
    var builder = list.toBuilder();

    for (var map in maps) {
// need to fetch council summary data

      BuiltAllCouncilsPost councilSummary = await getCouncilsSummaryById(
          db: db, councilId: map[StringConst.councilIdString]);

      builder.add(DatabaseMapping.clubSummaryFromMap(map, councilSummary));
    }

    var clubsSummary = builder.build();
    return clubsSummary;
  }

// TODO; fetch club only when its required , do not store all clubs beforehand.
  static Future<BuiltClubPost> getClubDetails(
      {@required Database db, @required int clubId}) async {
    // it will return only 1 map as every club  has unique id

    List<Map> maps = await db.query(
      StringConst.clubDetailsString,
      columns: [
        StringConst.idString,
        StringConst.nameString,
        StringConst.descriptionString,
        StringConst.councilIdString,
        StringConst.councilNameString,
        StringConst.councilSmallImageUrlString,
        StringConst.councilLargeImageUrlString,
        StringConst.mainPoRString,
        StringConst.jointPoRListAsStringString,
        StringConst.smallImageUrlString,
        StringConst.largeImageUrlString,
        StringConst.isSubscribedString,
        StringConst.subscribedUsersString,
        StringConst.isPORHolderString,
        StringConst.websiteUrlString,
        StringConst.facebookUrlString,
        StringConst.twitterUrlString,
        StringConst.instagramUrlString,
        StringConst.linkedinUrlString,
        StringConst.youtubeUrlString,
      ],
      where: '${StringConst.idString}  = $clubId',
    );
    print(
        'club id = $clubId -----------------------------------------------------');
    print('map length: ${maps.length}');

    if (maps.isEmpty) {
      return null;
    }
    var map = maps[0];

    BuiltAllCouncilsPost council = BuiltAllCouncilsPost((b) => b
      ..id = map[StringConst.councilIdString]
      ..name = map[StringConst.councilNameString]
      ..small_image_url = map[StringConst.councilSmallImageUrlString]
      ..large_image_url = map[StringConst.councilLargeImageUrlString]);

    SecyPost secy;
    if (map[StringConst.mainPoRString] != -1) {
      secy =
          await getPORHolderInfo(db: db, porId: map[StringConst.mainPoRString]);
    }

    List<int> secies = [];
    (map[StringConst.jointPoRListAsStringString] ?? '')
        ?.split(' ')
        ?.forEach((secyId) {
      final id = int.tryParse(secyId);
      if (id != null) secies.add(id);
    });

    BuiltList<SecyPost> jointSecyList = BuiltList<SecyPost>([]);
    var jointSecyBuilder = jointSecyList.toBuilder();

    secies?.forEach((element) async {
      final secy = await getPORHolderInfo(db: db, porId: element);
      if (secy != null) jointSecyBuilder.add(secy);
    });

    BuiltList<SecyPost> jointSecy = jointSecyBuilder.build();

    final BuiltClubPost clubDetails = BuiltClubPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..description = map[StringConst.descriptionString]
      ..council = (council?.toBuilder())
      ..secy = (secy?.toBuilder())
      ..joint_secy = (jointSecy?.toBuilder())
      ..small_image_url = map[StringConst.smallImageUrlString]
      ..large_image_url = map[StringConst.largeImageUrlString]
      ..is_subscribed = map[StringConst.isSubscribedString] == 1 ? true : false
      ..subscribed_users = map[StringConst.subscribedUsersString]
      ..is_por_holder = map[StringConst.isPORHolderString] == 1 ? true : false
      ..website_url = map[StringConst.websiteUrlString]
      ..facebook_url = map[StringConst.facebookUrlString]
      ..twitter_url = map[StringConst.twitterUrlString]
      ..instagram_url = map[StringConst.instagramUrlString]
      ..linkedin_url = map[StringConst.linkedinUrlString]
      ..youtube_url = map[StringConst.youtubeUrlString]);

    return clubDetails;
  }

  static Future<BuiltList<EntityListPost>> getAllEntitiesSummary(
      {@required Database db}) async {
    List<Map> maps = await db.query(
      StringConst.entitySummaryString,
      columns: [
        StringConst.idString,
        StringConst.nameString,
        StringConst.isPermanentString,
        StringConst.isHighlightedString,
        StringConst.smallImageUrlString,
        StringConst.largeImageUrlString,
      ],
      orderBy: StringConst.idString,
    );

    BuiltList<EntityListPost> list = BuiltList<EntityListPost>([]);
    var builder = list.toBuilder();

    for (var map in maps) {
      builder.add(DatabaseMapping.entitySummaryFromMap(map));
    }

    var entitiesSummary = builder.build();
    return entitiesSummary;
  }

  static Future<BuiltEntityPost> getEntityDetails(
      {@required Database db, @required int entityId}) async {
    // it will return only 1 map as every entity  has unique id

    List<Map> maps = await db.query(
      StringConst.entityDetailsString,
      columns: [
        StringConst.idString,
        StringConst.nameString,
        StringConst.descriptionString,
        StringConst.pointOfContactAsStringArrayString,
        StringConst.smallImageUrlString,
        StringConst.largeImageUrlString,
        StringConst.isSubscribedString,
        StringConst.subscribedUsersString,
        StringConst.isPORHolderString,
        StringConst.websiteUrlString,
        StringConst.facebookUrlString,
        StringConst.twitterUrlString,
        StringConst.instagramUrlString,
        StringConst.linkedinUrlString,
        StringConst.youtubeUrlString,
      ],
      where: '${StringConst.idString}  = $entityId',
    );
    print(
        'entity id = $entityId -----------------------------------------------------');
    print('map length: ${maps.length}');

    if (maps.isEmpty) {
      return null;
    }
    var map = maps[0];

    List<int> pocIds = [];
    (map[StringConst.pointOfContactAsStringArrayString] ?? '')
        ?.split(' ')
        ?.forEach((poc) {
      final id = int.tryParse(poc);
      if (id != null) pocIds.add(id);
    });

    BuiltList<SecyPost> pocList = BuiltList<SecyPost>([]);
    var pocBuilder = pocList.toBuilder();

    pocIds?.forEach((element) async {
      final secy = await getPORHolderInfo(db: db, porId: element);
      if (secy != null) pocBuilder.add(secy);
    });

    final BuiltEntityPost entityDetails = BuiltEntityPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..description = map[StringConst.descriptionString]
      ..point_of_contact = pocBuilder
      ..small_image_url = map[StringConst.smallImageUrlString]
      ..large_image_url = map[StringConst.largeImageUrlString]
      ..is_subscribed = map[StringConst.isSubscribedString] == 1 ? true : false
      ..subscribed_users = map[StringConst.subscribedUsersString]
      ..is_por_holder = map[StringConst.isPORHolderString] == 1 ? true : false
      ..website_url = map[StringConst.websiteUrlString]
      ..facebook_url = map[StringConst.facebookUrlString]
      ..twitter_url = map[StringConst.twitterUrlString]
      ..instagram_url = map[StringConst.instagramUrlString]
      ..linkedin_url = map[StringConst.linkedinUrlString]
      ..youtube_url = map[StringConst.youtubeUrlString]);

    return entityDetails;
  }
}
