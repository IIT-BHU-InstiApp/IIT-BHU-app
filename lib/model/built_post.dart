import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'built_post.g.dart';

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltPost implements Built<BuiltPost, BuiltPostBuilder> {
  @nullable
  int get id;
  String get title;
  String get date;
  String get time;

  BuiltPost._();

  factory BuiltPost([updates(BuiltPostBuilder b)]) = _$BuiltPost;

  static Serializer<BuiltPost> get serializer => _$builtPostSerializer;
}

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

  factory BuiltAllCouncilsPost([updates(BuiltAllCouncilsPostBuilder b)]) =
      _$BuiltAllCouncilsPost;

  static Serializer<BuiltAllCouncilsPost> get serializer =>
      _$builtAllCouncilsPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltCouncilPost
    implements Built<BuiltCouncilPost, BuiltCouncilPostBuilder> {
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

  BuiltCouncilPost._();

  factory BuiltCouncilPost([updates(BuiltCouncilPostBuilder b)]) =
      _$BuiltCouncilPost;

  static Serializer<BuiltCouncilPost> get serializer =>
      _$builtCouncilPostSerializer;
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
abstract class ClubListPost
    implements Built<ClubListPost, ClubListPostBuilder> {
  @nullable
  int get id;
  @nullable
  String get name;
  @nullable
  int get council;
  @nullable
  String get small_image_url;
  @nullable
  String get large_image_url;

  ClubListPost._();
  factory ClubListPost([updates(ClubListPostBuilder b)]) = _$ClubListPost;
  static Serializer<ClubListPost> get serializer => _$clubListPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltClubPost
    implements Built<BuiltClubPost, BuiltClubPostBuilder> {
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
  BuiltList<WorkshopPost> get active_workshops;
  @nullable
  BuiltList<WorkshopPost> get past_workshops;
  @nullable
  String get small_image_url;
  @nullable
  String get large_image_url;
  @nullable
  bool get is_subscribed;
  @nullable
  int get subscribed_users;

  BuiltClubPost._();

  factory BuiltClubPost([updates(BuiltClubPostBuilder b)]) = _$BuiltClubPost;

  static Serializer<BuiltClubPost> get serializer => _$builtClubPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class WorkshopPost
    implements Built<WorkshopPost, WorkshopPostBuilder> {
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

  WorkshopPost._();
  factory WorkshopPost([updates(WorkshopPostBuilder b)]) = _$WorkshopPost;
  static Serializer<WorkshopPost> get serializer => _$workshopPostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
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
  String get audience;
  @nullable
  String get resources;

  // TODO: watch for type of contacts

  @nullable
  BuiltList<String> get contacts;

  @nullable
  String get image_url;
  @nullable
  bool get is_attendee;
  @nullable
  int get attendees;

  BuiltWorkshopDetailPost._();

  factory BuiltWorkshopDetailPost([updates(BuiltWorkshopDetailPostBuilder b)]) =
      _$BuiltWorkshopDetailPost;

  static Serializer<BuiltWorkshopDetailPost> get serializer =>
      _$builtWorkshopDetailPostSerializer;
}

abstract class BuiltProfilePost
    implements Built<BuiltProfilePost, BuiltProfilePostBuilder> {
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

  // TODO: watch for type of club_privileges

  @nullable
  BuiltList<String> get club_privileges;

  BuiltProfilePost._();

  factory BuiltProfilePost([updates(BuiltProfilePostBuilder b)]) =
      _$BuiltProfilePost;

  static Serializer<BuiltProfilePost> get serializer =>
      _$builtProfilePostSerializer;
}

// !--------------------------------------------------------------------------------------------------------------------
abstract class BuiltTeamMemberPost
    implements Built<BuiltTeamMemberPost, BuiltTeamMemberPostBuilder> {
  @nullable
  String get name;
  @nullable
  String get github_username;
  @nullable
  String get github_image_url;

  BuiltTeamMemberPost._();
  factory BuiltTeamMemberPost([updates(BuiltTeamMemberPostBuilder b)]) =
      _$BuiltTeamMemberPost;
  static Serializer<BuiltTeamMemberPost> get serializer =>
      _$builtTeamMemberPostSerializer;
}
