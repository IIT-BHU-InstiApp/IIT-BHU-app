import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';

import 'built_post.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  TagCreate,
  TagSearch,
  TagDetail,
  WorkshopResources,
  BuiltAllWorkshopsPost,
  BuiltWorkshopSummaryPost,
  BuiltWorkshopDetailPost,
  ContactPost,
  BuiltWorkshopSearchByStringPost,
  // BuiltWorkshopSearchByDatePost,
  BuiltAllCouncilsPost,
  BuiltCouncilPost,
  SecyPost,
  ClubListPost,
  BuiltClubPost,
  BuiltWorkshopCreatePost,
  // WorkshopPost,
  BuiltProfilePost,
  BuiltProfileSearchPost,
  BuiltTeamMemberPost,
  TeamMember,
  BuiltContacts,
  BuiltTags,
  LoginPost,
  Token,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
