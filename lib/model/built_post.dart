import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'built_post.g.dart';

abstract class TagCreate implements Built<TagCreate, TagCreateBuilder> {
  @nullable
  int get id;
  @nullable
  String get tag_name;
  @nullable
  int get club;

  TagCreate._();
  factory TagCreate([updates(TagCreateBuilder b)]) = _$TagCreate;
  static Serializer<TagCreate> get serializer => _$tagCreateSerializer;
}

abstract class TagSearch implements Built<TagSearch, TagSearchBuilder> {
  @nullable
  int get id;
  @nullable
  String get tag_name;
  @nullable
  int get club;

  TagSearch._();
  factory TagSearch([updates(TagSearchBuilder b)]) = _$TagSearch;
  static Serializer<TagSearch> get serializer => _$tagSearchSerializer;
}

abstract class TagDetail implements Built<TagDetail, TagDetailBuilder> {
  @nullable
  int get id;
  @nullable
  String get tag_name;
  @nullable
  ClubListPost get club;

  TagDetail._();
  factory TagDetail([updates(TagDetailBuilder b)]) = _$TagDetail;
  static Serializer<TagDetail> get serializer => _$tagDetailSerializer;
}

abstract class ClubTags implements Built<ClubTags, ClubTagsBuilder> {
  @nullable
  BuiltList<TagDetail> get club_tags;

  ClubTags._();
  factory ClubTags([updates(ClubTagsBuilder b)]) = _$ClubTags;
  static Serializer<ClubTags> get serializer => _$clubTagsSerializer;
}

abstract class WorkshopResources implements Built<WorkshopResources, WorkshopResourcesBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  String get link;
  @nullable
  String get resource_type;

  WorkshopResources._();
  factory WorkshopResources([updates(WorkshopResourcesBuilder b)]) = _$WorkshopResources;
  static Serializer<WorkshopResources> get serializer => _$workshopResourcesSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltAllWorkshopsPost
    implements Built<BuiltAllWorkshopsPost, BuiltAllWorkshopsPostBuilder> {
  @nullable
  BuiltList<BuiltWorkshopSummaryPost> get active_workshops;
  @nullable
  BuiltList<BuiltWorkshopSummaryPost> get past_workshops;

  BuiltAllWorkshopsPost._();

  factory BuiltAllWorkshopsPost([updates(BuiltAllWorkshopsPostBuilder b)]) =
      _$BuiltAllWorkshopsPost;

  static Serializer<BuiltAllWorkshopsPost> get serializer => _$builtAllWorkshopsPostSerializer;
}

///* In backend - this model is named Active workshops
abstract class BuiltWorkshopSummaryPost
    implements Built<BuiltWorkshopSummaryPost, BuiltWorkshopSummaryPostBuilder> {
  @nullable
  int get id;
  @nullable
  ClubListPost get club;
  @nullable
  String get title;
  @nullable
  String get date;
  @nullable
  String get time;
  @nullable
  BuiltList<TagDetail> get tags;

  BuiltWorkshopSummaryPost._();

  factory BuiltWorkshopSummaryPost([updates(BuiltWorkshopSummaryPostBuilder b)]) =
      _$BuiltWorkshopSummaryPost;

  static Serializer<BuiltWorkshopSummaryPost> get serializer =>
      _$builtWorkshopSummaryPostSerializer;
}

abstract class BuiltWorkshopDetailPost
    implements Built<BuiltWorkshopDetailPost, BuiltWorkshopDetailPostBuilder> {
  @nullable
  int get id;
  @nullable
  String get title;
  @nullable
  String get description;
  @nullable
  ClubListPost get club;
  @nullable
  String get date;
  @nullable
  String get time;
  @nullable
  String get location;

  @nullable
  String get latitude;
  @nullable
  String get longitude;

  @nullable
  String get audience;
  @nullable
  BuiltList<WorkshopResources> get resources;
  @nullable
  BuiltList<ContactPost> get contacts;
  @nullable
  String get image_url;
  @nullable
  bool get is_interested;
  @nullable
  int get interested_users;
  @nullable
  bool get is_workshop_contact;
  @nullable
  bool get is_por_holder;

  @nullable
  BuiltList<TagDetail> get tags;

  @nullable
  String get link;

  BuiltWorkshopDetailPost._();

  factory BuiltWorkshopDetailPost([updates(BuiltWorkshopDetailPostBuilder b)]) =
      _$BuiltWorkshopDetailPost;

  static Serializer<BuiltWorkshopDetailPost> get serializer => _$builtWorkshopDetailPostSerializer;
}

abstract class ContactPost implements Built<ContactPost, ContactPostBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  String get email;
  @nullable
  String get phone_number;
  @nullable
  String get photo_url;

  ContactPost._();
  factory ContactPost([updates(ContactPostBuilder b)]) = _$ContactPost;
  static Serializer<ContactPost> get serializer => _$contactPostSerializer;
}

abstract class BuiltWorkshopSearchByStringPost
    implements Built<BuiltWorkshopSearchByStringPost, BuiltWorkshopSearchByStringPostBuilder> {
  @nullable
  String get search_by;
  @nullable
  String get search_string;

  BuiltWorkshopSearchByStringPost._();

  factory BuiltWorkshopSearchByStringPost([updates(BuiltWorkshopSearchByStringPostBuilder b)]) =
      _$BuiltWorkshopSearchByStringPost;

  static Serializer<BuiltWorkshopSearchByStringPost> get serializer =>
      _$builtWorkshopSearchByStringPostSerializer;
}

// abstract class BuiltWorkshopSearchByDatePost
//     implements
//         Built<BuiltWorkshopSearchByDatePost,
//             BuiltWorkshopSearchByDatePostBuilder> {
//   @nullable
//   String get start_date;
//   @nullable
//   String get end_date;

//   BuiltWorkshopSearchByDatePost._();

//   factory BuiltWorkshopSearchByDatePost(
//           [updates(BuiltWorkshopSearchByDatePostBuilder b)]) =
//       _$BuiltWorkshopSearchByDatePost;

//   static Serializer<BuiltWorkshopSearchByDatePost> get serializer =>
//       _$builtWorkshopSearchByDatePostSerializer;
// }

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltAllCouncilsPost
    implements Built<BuiltAllCouncilsPost, BuiltAllCouncilsPostBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  String get small_image_url;
  @nullable
  String get large_image_url;

  BuiltAllCouncilsPost._();

  factory BuiltAllCouncilsPost([updates(BuiltAllCouncilsPostBuilder b)]) = _$BuiltAllCouncilsPost;

  static Serializer<BuiltAllCouncilsPost> get serializer => _$builtAllCouncilsPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltCouncilPost implements Built<BuiltCouncilPost, BuiltCouncilPostBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  String get description;
  @nullable
  SecyPost get gensec;
  @nullable
  BuiltList<SecyPost> get joint_gensec;
  @nullable
  BuiltList<ClubListPost> get clubs;
  @nullable
  String get small_image_url;
  @nullable
  String get large_image_url;
  @nullable
  bool get is_por_holder;
  @nullable
  String get website_url;
  @nullable
  String get facebook_url;
  @nullable
  String get twitter_url;
  @nullable
  String get instagram_url;
  @nullable
  String get linkedin_url;
  @nullable
  String get youtube_url;

  BuiltCouncilPost._();

  factory BuiltCouncilPost([updates(BuiltCouncilPostBuilder b)]) = _$BuiltCouncilPost;

  static Serializer<BuiltCouncilPost> get serializer => _$builtCouncilPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class SecyPost implements Built<SecyPost, SecyPostBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  String get email;
  @nullable
  String get phone_number;
  @nullable
  String get photo_url;

  SecyPost._();
  factory SecyPost([updates(SecyPostBuilder b)]) = _$SecyPost;
  static Serializer<SecyPost> get serializer => _$secyPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class ClubListPost implements Built<ClubListPost, ClubListPostBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  BuiltAllCouncilsPost get council;
  @nullable
  String get small_image_url;
  @nullable
  String get large_image_url;

  ClubListPost._();
  factory ClubListPost([updates(ClubListPostBuilder b)]) = _$ClubListPost;
  static Serializer<ClubListPost> get serializer => _$clubListPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltClubPost implements Built<BuiltClubPost, BuiltClubPostBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  String get description;
  @nullable
  BuiltAllCouncilsPost get council;
  @nullable
  SecyPost get secy;
  @nullable
  BuiltList<SecyPost> get joint_secy;
  @nullable
  String get small_image_url;
  @nullable
  String get large_image_url;
  @nullable
  bool get is_subscribed;
  @nullable
  int get subscribed_users;

  @nullable
  bool get is_por_holder;
  @nullable
  String get website_url;
  @nullable
  String get facebook_url;
  @nullable
  String get twitter_url;
  @nullable
  String get instagram_url;
  @nullable
  String get linkedin_url;
  @nullable
  String get youtube_url;

  BuiltClubPost._();

  factory BuiltClubPost([updates(BuiltClubPostBuilder b)]) = _$BuiltClubPost;

  static Serializer<BuiltClubPost> get serializer => _$builtClubPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltWorkshopCreatePost
    implements Built<BuiltWorkshopCreatePost, BuiltWorkshopCreatePostBuilder> {
  @nullable
  int get id;

  String get title;
  int get club;
  String get date;

  @nullable
  String get description;
  @nullable
  String get time;
  @nullable
  String get location;

  @nullable
  String get latitude;
  @nullable
  String get longitude;

  @nullable
  String get audience;
  @nullable
  BuiltList<int> get contacts;

  @nullable
  String get image_url;

  @nullable
  BuiltList<int> get tags;

  @nullable
  String get link;

  BuiltWorkshopCreatePost._();
  factory BuiltWorkshopCreatePost([updates(BuiltWorkshopCreatePostBuilder b)]) =
      _$BuiltWorkshopCreatePost;
  static Serializer<BuiltWorkshopCreatePost> get serializer => _$builtWorkshopCreatePostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------

abstract class BuiltProfilePost implements Built<BuiltProfilePost, BuiltProfilePostBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  String get email;
  @nullable
  String get phone_number;
  @nullable
  String get department;
  @nullable
  String get year_of_joining;
  @nullable
  BuiltList<ClubListPost> get subscriptions;
  @nullable
  BuiltList<ClubListPost> get club_privileges;
  @nullable
  String get photo_url;

  BuiltProfilePost._();

  factory BuiltProfilePost([updates(BuiltProfilePostBuilder b)]) = _$BuiltProfilePost;

  static Serializer<BuiltProfilePost> get serializer => _$builtProfilePostSerializer;
}

abstract class BuiltProfileSearchPost
    implements Built<BuiltProfileSearchPost, BuiltProfileSearchPostBuilder> {
  @nullable
  String get search_by;
  @nullable
  String get search_string;

  BuiltProfileSearchPost._();

  factory BuiltProfileSearchPost([updates(BuiltProfileSearchPostBuilder b)]) =
      _$BuiltProfileSearchPost;

  static Serializer<BuiltProfileSearchPost> get serializer => _$builtProfileSearchPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
/// * In Backend - this model is named as Role
abstract class BuiltTeamMemberPost
    implements Built<BuiltTeamMemberPost, BuiltTeamMemberPostBuilder> {
  @nullable
  String get role;
  @nullable
  BuiltList<TeamMember> get team_members;

  BuiltTeamMemberPost._();
  factory BuiltTeamMemberPost([updates(BuiltTeamMemberPostBuilder b)]) = _$BuiltTeamMemberPost;
  static Serializer<BuiltTeamMemberPost> get serializer => _$builtTeamMemberPostSerializer;
}

abstract class TeamMember implements Built<TeamMember, TeamMemberBuilder> {
  @nullable
  String get name;
  @nullable
  String get github_username;
  @nullable
  String get github_image_url;

  TeamMember._();
  factory TeamMember([updates(TeamMemberBuilder b)]) = _$TeamMember;
  static Serializer<TeamMember> get serializer => _$teamMemberSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltContacts implements Built<BuiltContacts, BuiltContactsBuilder> {
  @nullable
  BuiltList<int> get contacts;

  BuiltContacts._();
  factory BuiltContacts([updates(BuiltContactsBuilder b)]) = _$BuiltContacts;
  static Serializer<BuiltContacts> get serializer => _$builtContactsSerializer;
}

abstract class BuiltTags implements Built<BuiltTags, BuiltTagsBuilder> {
  @nullable
  BuiltList<int> get tags;

  BuiltTags._();
  factory BuiltTags([updates(BuiltTagsBuilder b)]) = _$BuiltTags;
  static Serializer<BuiltTags> get serializer => _$builtTagsSerializer;
}

abstract class LoginPost implements Built<LoginPost, LoginPostBuilder> {
  String get id_token;

  LoginPost._();
  factory LoginPost([updates(LoginPostBuilder b)]) = _$LoginPost;
  static Serializer<LoginPost> get serializer => _$loginPostSerializer;
}

abstract class Token implements Built<Token, TokenBuilder> {
  String get token;

  Token._();
  factory Token([updates(TokenBuilder b)]) = _$Token;
  static Serializer<Token> get serializer => _$tokenSerializer;
}
