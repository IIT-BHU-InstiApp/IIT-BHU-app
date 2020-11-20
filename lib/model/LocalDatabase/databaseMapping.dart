import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/LocalDatabase/stringConstants.dart';

class DatabaseMapping {
  static Map<String, dynamic> workshopInfoToMap(BuiltWorkshopSummaryPost workshop) {
    Map<String, dynamic> map = {
      StringConst.idString: workshop.id,
      StringConst.clubIdString: workshop.club.id,
      StringConst.clubString: workshop.club.name == null ? '' : workshop.club.name,
      StringConst.councilIdString: workshop.club.council.id,
      StringConst.smallImageUrlString:
          workshop.club.small_image_url == null ? '' : workshop.club.small_image_url,
      StringConst.largeImageUrlString:
          workshop.club.large_image_url == null ? '' : workshop.club.large_image_url,
      StringConst.titleString: workshop.title == null ? '' : workshop.title,
      StringConst.dateString: workshop.date == null ? '' : workshop.date,
      StringConst.timeString: workshop.time == null ? '' : workshop.time,
    };
    return map;
  }

  static Map<String, dynamic> councilSummaryInfoToMap(BuiltAllCouncilsPost councilSummary) {
    Map<String, dynamic> map = {
      StringConst.idString: councilSummary.id,
      StringConst.nameString: councilSummary.name == null ? '' : councilSummary.name,
      StringConst.smallImageUrlString:
          councilSummary.small_image_url == null ? '' : councilSummary.small_image_url,
      StringConst.largeImageUrlString:
          councilSummary.large_image_url == null ? '' : councilSummary.large_image_url,
    };
    return map;
  }

  static Map<String, dynamic> councilDetailToMap(BuiltCouncilPost councilPost) {
    Map<String, dynamic> map = {
      StringConst.idString: councilPost.id,
      StringConst.nameString: councilPost.name == null ? '' : councilPost.name,
      StringConst.descriptionString: councilPost.description == null ? '' : councilPost.description,
      StringConst.gensecIdString: councilPost.gensec == null ? -1 : councilPost.gensec.id,
      StringConst.jointGensecId1String:
          (councilPost.joint_gensec.isEmpty) ? -1 : councilPost.joint_gensec[0].id,
      StringConst.jointGensecId2String:
          (councilPost.joint_gensec.length < 2) ? -1 : councilPost.joint_gensec[1].id,
      StringConst.smallImageUrlString:
          councilPost.small_image_url == null ? '' : councilPost.small_image_url,
      StringConst.largeImageUrlString:
          councilPost.large_image_url == null ? '' : councilPost.large_image_url,
      StringConst.isPORHolderString:
          councilPost.is_por_holder == null ? 0 : (councilPost.is_por_holder == true ? 1 : 0),
      StringConst.websiteUrlString: councilPost.website_url == null ? '' : councilPost.website_url,
      StringConst.facebookUrlString:
          councilPost.facebook_url == null ? '' : councilPost.facebook_url,
      StringConst.twitterUrlString: councilPost.twitter_url == null ? '' : councilPost.twitter_url,
      StringConst.instagramUrlString:
          councilPost.instagram_url == null ? '' : councilPost.instagram_url,
      StringConst.linkedinUrlString:
          councilPost.linkedin_url == null ? '' : councilPost.linkedin_url,
      StringConst.youtubeUrlString: councilPost.youtube_url == null ? '' : councilPost.youtube_url,
    };
    return map;
  }

  static Map<String, dynamic> porInfoToMap({SecyPost por, int councilId = -1, int clubId = -1}) {
    Map<String, dynamic> map = {
      StringConst.idString: por.id,
      StringConst.councilIdString: councilId,
      StringConst.clubIdString: clubId,
      StringConst.nameString: por.name == null ? '' : por.name,
      StringConst.emailString: por.email == null ? '' : por.email,
      StringConst.phoneNumberString: por.phone_number == null ? '' : por.phone_number,
      StringConst.photoUrlString: por.photo_url == null ? '' : por.photo_url,
    };
    return map;
  }

  static Map<String, dynamic> clubSummaryInfoToMap(ClubListPost clubSummary) {
    Map<String, dynamic> map = {
      StringConst.idString: clubSummary.id,
      StringConst.nameString: clubSummary.name == null ? '' : clubSummary.name,
      StringConst.councilIdString: (clubSummary.council == null || clubSummary.council.id == null)
          ? 0
          : clubSummary.council.id,
      StringConst.smallImageUrlString:
          clubSummary.small_image_url == null ? '' : clubSummary.small_image_url,
      StringConst.largeImageUrlString:
          clubSummary.large_image_url == null ? '' : clubSummary.large_image_url,
    };
    return map;
  }

  static Map<String, dynamic> clubDetailToMap(BuiltClubPost clubPost) {
    Map<String, dynamic> map = {
      StringConst.idString: clubPost.id,
      StringConst.nameString: clubPost.name == null ? '' : clubPost.name,
      StringConst.descriptionString: clubPost.description == null ? '' : clubPost.description,
      StringConst.councilIdString: clubPost.council.id,
      StringConst.councilNameString: clubPost.council.name,
      StringConst.councilSmallImageUrlString: clubPost.council.small_image_url,
      StringConst.councilLargeImageUrlString: clubPost.council.large_image_url,
      StringConst.secyIdString: clubPost.secy == null ? -1 : clubPost.secy.id,
      StringConst.jointSecyId1String:
          (clubPost.joint_secy.isEmpty) ? -1 : clubPost.joint_secy[0].id,
      StringConst.jointSecyId2String:
          (clubPost.joint_secy.length < 2) ? -1 : clubPost.joint_secy[1].id,
      StringConst.smallImageUrlString:
          clubPost.small_image_url == null ? '' : clubPost.small_image_url,
      StringConst.largeImageUrlString:
          clubPost.large_image_url == null ? '' : clubPost.large_image_url,
      StringConst.isSubscribedString: clubPost.is_subscribed == true ? 1 : 0,
      StringConst.subscribedUsersString: clubPost.subscribed_users,
      StringConst.isPORHolderString:
          clubPost.is_por_holder == null ? 0 : (clubPost.is_por_holder == true ? 1 : 0),
      StringConst.websiteUrlString: clubPost.website_url == null ? '' : clubPost.website_url,
      StringConst.facebookUrlString: clubPost.facebook_url == null ? '' : clubPost.facebook_url,
      StringConst.twitterUrlString: clubPost.twitter_url == null ? '' : clubPost.twitter_url,
      StringConst.instagramUrlString: clubPost.instagram_url == null ? '' : clubPost.instagram_url,
      StringConst.linkedinUrlString: clubPost.linkedin_url == null ? '' : clubPost.linkedin_url,
      StringConst.youtubeUrlString: clubPost.youtube_url == null ? '' : clubPost.youtube_url,
    };
    return map;
  }

// -------------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------------------

  static BuiltWorkshopSummaryPost workshopSummaryFromMap(
      dynamic map, BuiltAllCouncilsPost councilSummary) {
    final workshop = BuiltWorkshopSummaryPost((b) => b
      ..id = map[StringConst.idString]
      ..club.id = map[StringConst.clubIdString]
      ..club.name = map[StringConst.clubString]
      ..club.council = councilSummary == null ? null : (councilSummary.toBuilder())
      ..club.small_image_url = map[StringConst.smallImageUrlString]
      ..club.large_image_url = map[StringConst.largeImageUrlString]
      ..title = map[StringConst.titleString]
      ..date = map[StringConst.dateString]
      ..time = map[StringConst.timeString]);
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

// var councilDetailFromMap(dynamic map) { }

  static SecyPost porHolderInfoFromMap(dynamic map) {
    final porHolder = SecyPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..email = map[StringConst.emailString]
      ..phone_number = map[StringConst.phoneNumberString]
      ..photo_url = map[StringConst.photoUrlString]);
    return porHolder;
  }

  static ClubListPost clubSummaryFromMap(dynamic map, BuiltAllCouncilsPost councilSummary) {
    final clubSummary = ClubListPost((b) => b
      ..id = map[StringConst.idString]
      ..name = map[StringConst.nameString]
      ..council = councilSummary == null ? null : (councilSummary.toBuilder())
      ..small_image_url = map[StringConst.smallImageUrlString]
      ..large_image_url = map[StringConst.largeImageUrlString]);
    return clubSummary;
  }
}
