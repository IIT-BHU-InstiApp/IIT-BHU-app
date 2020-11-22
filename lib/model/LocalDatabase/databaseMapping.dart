import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/LocalDatabase/stringConstants.dart';

class DatabaseMapping {
  static Map<String, dynamic> workshopInfoToMap(
      BuiltWorkshopSummaryPost workshop) {
    Map<String, dynamic> map = {
      StringConst.idString: workshop.id,
      StringConst.isWorkshopString: workshop.is_workshop ? 1 : 0,
      StringConst.clubIdString: workshop.club?.id,
      StringConst.clubString: workshop.club?.name ?? '',
      StringConst.councilIdString: workshop.club?.council?.id,
      StringConst.entityIdString: workshop.entity?.id,
      StringConst.entityString: workshop.entity?.name,
      StringConst.smallImageUrlString: workshop.club?.small_image_url ??
          workshop.entity?.small_image_url ??
          '',
      StringConst.largeImageUrlString: workshop.club?.large_image_url ??
          workshop.entity?.large_image_url ??
          '',
      StringConst.titleString: workshop.title == null ? '' : workshop.title,
      StringConst.dateString: workshop.date == null ? '' : workshop.date,
      StringConst.timeString: workshop.time == null ? '' : workshop.time,
    };
    return map;
  }

  static Map<String, dynamic> councilSummaryInfoToMap(
      BuiltAllCouncilsPost councilSummary) {
    Map<String, dynamic> map = {
      StringConst.idString: councilSummary.id,
      StringConst.nameString: councilSummary.name ?? '',
      StringConst.smallImageUrlString: councilSummary.small_image_url ?? '',
      StringConst.largeImageUrlString: councilSummary.large_image_url ?? '',
    };
    return map;
  }

  static Map<String, dynamic> councilDetailToMap(BuiltCouncilPost councilPost) {
    Map<String, dynamic> map = {
      StringConst.idString: councilPost.id,
      StringConst.nameString: councilPost.name ?? '',
      StringConst.descriptionString: councilPost.description ?? '',
      StringConst.gensecIdString: councilPost.gensec?.id ?? -1,
      StringConst.jointGensecId1String: (councilPost.joint_gensec.isEmpty)
          ? -1
          : councilPost.joint_gensec[0].id,
      StringConst.jointGensecId2String: (councilPost.joint_gensec.length < 2)
          ? -1
          : councilPost.joint_gensec[1].id,
      StringConst.smallImageUrlString: councilPost.small_image_url ?? '',
      StringConst.largeImageUrlString: councilPost.large_image_url ?? '',
      StringConst.isPORHolderString: councilPost.is_por_holder == null
          ? 0
          : (councilPost.is_por_holder == true ? 1 : 0),
      StringConst.websiteUrlString: councilPost.website_url ?? '',
      StringConst.facebookUrlString: councilPost.facebook_url ?? '',
      StringConst.twitterUrlString: councilPost.twitter_url ?? '',
      StringConst.instagramUrlString: councilPost.instagram_url ?? '',
      StringConst.linkedinUrlString: councilPost.linkedin_url ?? '',
      StringConst.youtubeUrlString: councilPost.youtube_url ?? '',
    };
    return map;
  }

  static Map<String, dynamic> porInfoToMap(
      {SecyPost por, int councilId = -1, int clubId = -1, int entityId = -1}) {
    Map<String, dynamic> map = {
      StringConst.idString: por.id,
      StringConst.councilIdString: councilId,
      StringConst.clubIdString: clubId,
      StringConst.entityIdString: entityId,
      StringConst.nameString: por.name ?? '',
      StringConst.emailString: por.email ?? '',
      StringConst.phoneNumberString: por.phone_number ?? '',
      StringConst.photoUrlString: por.photo_url ?? '',
    };
    return map;
  }

  static Map<String, dynamic> clubSummaryInfoToMap(ClubListPost clubSummary) {
    Map<String, dynamic> map = {
      StringConst.idString: clubSummary.id,
      StringConst.nameString: clubSummary.name ?? '',
      StringConst.councilIdString:
          (clubSummary.council == null || clubSummary.council.id == null)
              ? 0
              : clubSummary.council.id,
      StringConst.smallImageUrlString: clubSummary.small_image_url ?? '',
      StringConst.largeImageUrlString: clubSummary.large_image_url ?? '',
    };
    return map;
  }

  static Map<String, dynamic> entitySummaryInfoToMap(
      EntityListPost entitySummary) {
    Map<String, dynamic> map = {
      StringConst.idString: entitySummary.id,
      StringConst.nameString: entitySummary.name ?? '',
      StringConst.smallImageUrlString: entitySummary.small_image_url ?? '',
      StringConst.largeImageUrlString: entitySummary.large_image_url ?? '',
    };
    return map;
  }

  static Map<String, dynamic> clubDetailToMap(BuiltClubPost clubPost) {
    Map<String, dynamic> map = {
      StringConst.idString: clubPost.id,
      StringConst.nameString: clubPost.name ?? '',
      StringConst.descriptionString: clubPost.description ?? '',
      StringConst.councilIdString: clubPost.council.id,
      StringConst.councilNameString: clubPost.council.name,
      StringConst.councilSmallImageUrlString: clubPost.council.small_image_url,
      StringConst.councilLargeImageUrlString: clubPost.council.large_image_url,
      StringConst.secyIdString: clubPost.secy == null ? -1 : clubPost.secy.id,
      StringConst.jointSecyId1String:
          (clubPost.joint_secy.isEmpty) ? -1 : clubPost.joint_secy[0].id,
      StringConst.jointSecyId2String:
          (clubPost.joint_secy.length < 2) ? -1 : clubPost.joint_secy[1].id,
      StringConst.smallImageUrlString: clubPost.small_image_url ?? '',
      StringConst.largeImageUrlString: clubPost.large_image_url ?? '',
      StringConst.isSubscribedString: clubPost.is_subscribed == true ? 1 : 0,
      StringConst.subscribedUsersString: clubPost.subscribed_users,
      StringConst.isPORHolderString: clubPost.is_por_holder == null
          ? 0
          : (clubPost.is_por_holder == true ? 1 : 0),
      StringConst.websiteUrlString: clubPost.website_url ?? '',
      StringConst.facebookUrlString: clubPost.facebook_url ?? '',
      StringConst.twitterUrlString: clubPost.twitter_url ?? '',
      StringConst.instagramUrlString: clubPost.instagram_url ?? '',
      StringConst.linkedinUrlString: clubPost.linkedin_url ?? '',
      StringConst.youtubeUrlString: clubPost.youtube_url ?? '',
    };
    return map;
  }

  static Map<String, dynamic> entityDetailToMap(BuiltEntityPost entityPost) {
    String pocString = '';
    entityPost.point_of_contact?.forEach((secy) {
      if (secy == null) return;
      pocString += '${secy.id}' ' ';
    });

    pocString = pocString.trim();

    Map<String, dynamic> map = {
      StringConst.idString: entityPost.id,
      StringConst.nameString: entityPost.name ?? '',
      StringConst.descriptionString: entityPost.description ?? '',
      StringConst.pointOfContactAsStringArrayString: pocString,
      StringConst.smallImageUrlString: entityPost.small_image_url ?? '',
      StringConst.largeImageUrlString: entityPost.large_image_url ?? '',
      StringConst.isSubscribedString: entityPost.is_subscribed == true ? 1 : 0,
      StringConst.subscribedUsersString: entityPost.subscribed_users,
      StringConst.isPORHolderString: entityPost.is_por_holder == null
          ? 0
          : (entityPost.is_por_holder == true ? 1 : 0),
      StringConst.websiteUrlString: entityPost.website_url ?? '',
      StringConst.facebookUrlString: entityPost.facebook_url ?? '',
      StringConst.twitterUrlString: entityPost.twitter_url ?? '',
      StringConst.instagramUrlString: entityPost.instagram_url ?? '',
      StringConst.linkedinUrlString: entityPost.linkedin_url ?? '',
      StringConst.youtubeUrlString: entityPost.youtube_url ?? '',
    };
    return map;
  }

// -------------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------------------

  static BuiltWorkshopSummaryPost workshopSummaryFromMap(
      Map map, BuiltAllCouncilsPost councilSummary) {
    var workshop = BuiltWorkshopSummaryPost((b) => b
      ..id = map[StringConst.idString]
      ..title = map[StringConst.titleString]
      ..date = map[StringConst.dateString]
      ..time = map[StringConst.timeString]
      ..is_workshop = map[StringConst.isWorkshopString] == 1 ? true : false);

    if (map.containsKey(StringConst.clubIdString) &&
        map[StringConst.clubIdString] != null) {
      workshop = workshop.rebuild((b) => b
        ..club.id = map[StringConst.clubIdString]
        ..club.name = map[StringConst.clubString]
        ..club.small_image_url = map[StringConst.smallImageUrlString]
        ..club.large_image_url = map[StringConst.largeImageUrlString]
        ..club.council = councilSummary?.toBuilder()
        ..entity = null);
    } else if (map.containsKey(StringConst.entityIdString) &&
        map[StringConst.entityIdString] != null) {
      workshop = workshop.rebuild((b) => b
        ..entity.id = map[StringConst.entityIdString]
        ..entity.name = map[StringConst.entityString]
        ..entity.small_image_url = map[StringConst.smallImageUrlString]
        ..entity.large_image_url = map[StringConst.largeImageUrlString]
        ..club = null);
    }

    return workshop;
  }

  static BuiltAllCouncilsPost councilSummaryFromMap(dynamic map) {
    final council = BuiltAllCouncilsPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..small_image_url = map[StringConst.smallImageUrlString]
      ..large_image_url = map[StringConst.largeImageUrlString]);
    return council;
  }

  static EntityListPost entitySummaryFromMap(dynamic map) {
    final entity = EntityListPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..small_image_url = map[StringConst.smallImageUrlString]
      ..large_image_url = map[StringConst.largeImageUrlString]);
    return entity;
  }

  static SecyPost porHolderInfoFromMap(dynamic map) {
    final porHolder = SecyPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..email = map[StringConst.emailString]
      ..phone_number = map[StringConst.phoneNumberString]
      ..photo_url = map[StringConst.photoUrlString]);
    return porHolder;
  }

  static ClubListPost clubSummaryFromMap(
      dynamic map, BuiltAllCouncilsPost councilSummary) {
    final clubSummary = ClubListPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..council = councilSummary == null ? null : (councilSummary.toBuilder())
      ..small_image_url = map[StringConst.smallImageUrlString]
      ..large_image_url = map[StringConst.largeImageUrlString]);
    return clubSummary;
  }
}
