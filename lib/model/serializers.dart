import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';

import 'built_post.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  BuiltPost,
  BuiltCouncilPost,
  BuiltAllCouncilsPost,
  SecyPost,
  ClubListPost,
  BuiltClubPost,
  WorkshopPost,
  BuiltWorkshopDetailPost,
  BuiltProfilePost,
  BuiltTeamMemberPost,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
