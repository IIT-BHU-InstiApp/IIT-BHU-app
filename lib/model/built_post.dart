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
abstract class ClubListPost implements Built<ClubListPost, ClubListPostBuilder> {
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
