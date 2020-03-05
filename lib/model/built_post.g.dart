// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'built_post.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BuiltPost> _$builtPostSerializer = new _$BuiltPostSerializer();
Serializer<BuiltAllCouncilsPost> _$builtAllCouncilsPostSerializer =
    new _$BuiltAllCouncilsPostSerializer();
Serializer<BuiltCouncilPost> _$builtCouncilPostSerializer =
    new _$BuiltCouncilPostSerializer();
Serializer<SecyPost> _$secyPostSerializer = new _$SecyPostSerializer();
Serializer<ClubListPost> _$clubListPostSerializer =
    new _$ClubListPostSerializer();

class _$BuiltPostSerializer implements StructuredSerializer<BuiltPost> {
  @override
  final Iterable<Type> types = const [BuiltPost, _$BuiltPost];
  @override
  final String wireName = 'BuiltPost';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltPost object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(String)),
      'time',
      serializers.serialize(object.time, specifiedType: const FullType(String)),
    ];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  BuiltPost deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltPostBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'date':
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'time':
          result.time = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltAllCouncilsPostSerializer
    implements StructuredSerializer<BuiltAllCouncilsPost> {
  @override
  final Iterable<Type> types = const [
    BuiltAllCouncilsPost,
    _$BuiltAllCouncilsPost
  ];
  @override
  final String wireName = 'BuiltAllCouncilsPost';

  @override
  Iterable<Object> serialize(
      Serializers serializers, BuiltAllCouncilsPost object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.small_image_url != null) {
      result
        ..add('small_image_url')
        ..add(serializers.serialize(object.small_image_url,
            specifiedType: const FullType(String)));
    }
    if (object.large_image_url != null) {
      result
        ..add('large_image_url')
        ..add(serializers.serialize(object.large_image_url,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltAllCouncilsPost deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltAllCouncilsPostBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'small_image_url':
          result.small_image_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'large_image_url':
          result.large_image_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltCouncilPostSerializer
    implements StructuredSerializer<BuiltCouncilPost> {
  @override
  final Iterable<Type> types = const [BuiltCouncilPost, _$BuiltCouncilPost];
  @override
  final String wireName = 'BuiltCouncilPost';

  @override
  Iterable<Object> serialize(Serializers serializers, BuiltCouncilPost object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.gensec != null) {
      result
        ..add('gensec')
        ..add(serializers.serialize(object.gensec,
            specifiedType: const FullType(SecyPost)));
    }
    if (object.joint_gensec != null) {
      result
        ..add('joint_gensec')
        ..add(serializers.serialize(object.joint_gensec,
            specifiedType:
                const FullType(BuiltList, const [const FullType(SecyPost)])));
    }
    if (object.clubs != null) {
      result
        ..add('clubs')
        ..add(serializers.serialize(object.clubs,
            specifiedType: const FullType(
                BuiltList, const [const FullType(ClubListPost)])));
    }
    if (object.small_image_url != null) {
      result
        ..add('small_image_url')
        ..add(serializers.serialize(object.small_image_url,
            specifiedType: const FullType(String)));
    }
    if (object.large_image_url != null) {
      result
        ..add('large_image_url')
        ..add(serializers.serialize(object.large_image_url,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuiltCouncilPost deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuiltCouncilPostBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gensec':
          result.gensec.replace(serializers.deserialize(value,
              specifiedType: const FullType(SecyPost)) as SecyPost);
          break;
        case 'joint_gensec':
          result.joint_gensec.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SecyPost)]))
              as BuiltList<dynamic>);
          break;
        case 'clubs':
          result.clubs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(ClubListPost)]))
              as BuiltList<dynamic>);
          break;
        case 'small_image_url':
          result.small_image_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'large_image_url':
          result.large_image_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SecyPostSerializer implements StructuredSerializer<SecyPost> {
  @override
  final Iterable<Type> types = const [SecyPost, _$SecyPost];
  @override
  final String wireName = 'SecyPost';

  @override
  Iterable<Object> serialize(Serializers serializers, SecyPost object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    if (object.phone_number != null) {
      result
        ..add('phone_number')
        ..add(serializers.serialize(object.phone_number,
            specifiedType: const FullType(String)));
    }
    if (object.photo_url != null) {
      result
        ..add('photo_url')
        ..add(serializers.serialize(object.photo_url,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SecyPost deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SecyPostBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phone_number':
          result.phone_number = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'photo_url':
          result.photo_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ClubListPostSerializer implements StructuredSerializer<ClubListPost> {
  @override
  final Iterable<Type> types = const [ClubListPost, _$ClubListPost];
  @override
  final String wireName = 'ClubListPost';

  @override
  Iterable<Object> serialize(Serializers serializers, ClubListPost object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.council != null) {
      result
        ..add('council')
        ..add(serializers.serialize(object.council,
            specifiedType: const FullType(int)));
    }
    if (object.small_image_url != null) {
      result
        ..add('small_image_url')
        ..add(serializers.serialize(object.small_image_url,
            specifiedType: const FullType(String)));
    }
    if (object.large_image_url != null) {
      result
        ..add('large_image_url')
        ..add(serializers.serialize(object.large_image_url,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ClubListPost deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ClubListPostBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'council':
          result.council = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'small_image_url':
          result.small_image_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'large_image_url':
          result.large_image_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BuiltPost extends BuiltPost {
  @override
  final int id;
  @override
  final String title;
  @override
  final String date;
  @override
  final String time;

  factory _$BuiltPost([void Function(BuiltPostBuilder) updates]) =>
      (new BuiltPostBuilder()..update(updates)).build();

  _$BuiltPost._({this.id, this.title, this.date, this.time}) : super._() {
    if (title == null) {
      throw new BuiltValueNullFieldError('BuiltPost', 'title');
    }
    if (date == null) {
      throw new BuiltValueNullFieldError('BuiltPost', 'date');
    }
    if (time == null) {
      throw new BuiltValueNullFieldError('BuiltPost', 'time');
    }
  }

  @override
  BuiltPost rebuild(void Function(BuiltPostBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltPostBuilder toBuilder() => new BuiltPostBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltPost &&
        id == other.id &&
        title == other.title &&
        date == other.date &&
        time == other.time;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc($jc(0, id.hashCode), title.hashCode), date.hashCode),
        time.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltPost')
          ..add('id', id)
          ..add('title', title)
          ..add('date', date)
          ..add('time', time))
        .toString();
  }
}

class BuiltPostBuilder implements Builder<BuiltPost, BuiltPostBuilder> {
  _$BuiltPost _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _date;
  String get date => _$this._date;
  set date(String date) => _$this._date = date;

  String _time;
  String get time => _$this._time;
  set time(String time) => _$this._time = time;

  BuiltPostBuilder();

  BuiltPostBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _date = _$v.date;
      _time = _$v.time;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltPost other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltPost;
  }

  @override
  void update(void Function(BuiltPostBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltPost build() {
    final _$result =
        _$v ?? new _$BuiltPost._(id: id, title: title, date: date, time: time);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltAllCouncilsPost extends BuiltAllCouncilsPost {
  @override
  final int id;
  @override
  final String name;
  @override
  final String small_image_url;
  @override
  final String large_image_url;

  factory _$BuiltAllCouncilsPost(
          [void Function(BuiltAllCouncilsPostBuilder) updates]) =>
      (new BuiltAllCouncilsPostBuilder()..update(updates)).build();

  _$BuiltAllCouncilsPost._(
      {this.id, this.name, this.small_image_url, this.large_image_url})
      : super._();

  @override
  BuiltAllCouncilsPost rebuild(
          void Function(BuiltAllCouncilsPostBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltAllCouncilsPostBuilder toBuilder() =>
      new BuiltAllCouncilsPostBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltAllCouncilsPost &&
        id == other.id &&
        name == other.name &&
        small_image_url == other.small_image_url &&
        large_image_url == other.large_image_url;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, id.hashCode), name.hashCode), small_image_url.hashCode),
        large_image_url.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltAllCouncilsPost')
          ..add('id', id)
          ..add('name', name)
          ..add('small_image_url', small_image_url)
          ..add('large_image_url', large_image_url))
        .toString();
  }
}

class BuiltAllCouncilsPostBuilder
    implements Builder<BuiltAllCouncilsPost, BuiltAllCouncilsPostBuilder> {
  _$BuiltAllCouncilsPost _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _small_image_url;
  String get small_image_url => _$this._small_image_url;
  set small_image_url(String small_image_url) =>
      _$this._small_image_url = small_image_url;

  String _large_image_url;
  String get large_image_url => _$this._large_image_url;
  set large_image_url(String large_image_url) =>
      _$this._large_image_url = large_image_url;

  BuiltAllCouncilsPostBuilder();

  BuiltAllCouncilsPostBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _small_image_url = _$v.small_image_url;
      _large_image_url = _$v.large_image_url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltAllCouncilsPost other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltAllCouncilsPost;
  }

  @override
  void update(void Function(BuiltAllCouncilsPostBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltAllCouncilsPost build() {
    final _$result = _$v ??
        new _$BuiltAllCouncilsPost._(
            id: id,
            name: name,
            small_image_url: small_image_url,
            large_image_url: large_image_url);
    replace(_$result);
    return _$result;
  }
}

class _$BuiltCouncilPost extends BuiltCouncilPost {
  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final SecyPost gensec;
  @override
  final BuiltList<SecyPost> joint_gensec;
  @override
  final BuiltList<ClubListPost> clubs;
  @override
  final String small_image_url;
  @override
  final String large_image_url;

  factory _$BuiltCouncilPost(
          [void Function(BuiltCouncilPostBuilder) updates]) =>
      (new BuiltCouncilPostBuilder()..update(updates)).build();

  _$BuiltCouncilPost._(
      {this.id,
      this.name,
      this.description,
      this.gensec,
      this.joint_gensec,
      this.clubs,
      this.small_image_url,
      this.large_image_url})
      : super._();

  @override
  BuiltCouncilPost rebuild(void Function(BuiltCouncilPostBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuiltCouncilPostBuilder toBuilder() =>
      new BuiltCouncilPostBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuiltCouncilPost &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        gensec == other.gensec &&
        joint_gensec == other.joint_gensec &&
        clubs == other.clubs &&
        small_image_url == other.small_image_url &&
        large_image_url == other.large_image_url;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, id.hashCode), name.hashCode),
                            description.hashCode),
                        gensec.hashCode),
                    joint_gensec.hashCode),
                clubs.hashCode),
            small_image_url.hashCode),
        large_image_url.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuiltCouncilPost')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('gensec', gensec)
          ..add('joint_gensec', joint_gensec)
          ..add('clubs', clubs)
          ..add('small_image_url', small_image_url)
          ..add('large_image_url', large_image_url))
        .toString();
  }
}

class BuiltCouncilPostBuilder
    implements Builder<BuiltCouncilPost, BuiltCouncilPostBuilder> {
  _$BuiltCouncilPost _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  SecyPostBuilder _gensec;
  SecyPostBuilder get gensec => _$this._gensec ??= new SecyPostBuilder();
  set gensec(SecyPostBuilder gensec) => _$this._gensec = gensec;

  ListBuilder<SecyPost> _joint_gensec;
  ListBuilder<SecyPost> get joint_gensec =>
      _$this._joint_gensec ??= new ListBuilder<SecyPost>();
  set joint_gensec(ListBuilder<SecyPost> joint_gensec) =>
      _$this._joint_gensec = joint_gensec;

  ListBuilder<ClubListPost> _clubs;
  ListBuilder<ClubListPost> get clubs =>
      _$this._clubs ??= new ListBuilder<ClubListPost>();
  set clubs(ListBuilder<ClubListPost> clubs) => _$this._clubs = clubs;

  String _small_image_url;
  String get small_image_url => _$this._small_image_url;
  set small_image_url(String small_image_url) =>
      _$this._small_image_url = small_image_url;

  String _large_image_url;
  String get large_image_url => _$this._large_image_url;
  set large_image_url(String large_image_url) =>
      _$this._large_image_url = large_image_url;

  BuiltCouncilPostBuilder();

  BuiltCouncilPostBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _description = _$v.description;
      _gensec = _$v.gensec?.toBuilder();
      _joint_gensec = _$v.joint_gensec?.toBuilder();
      _clubs = _$v.clubs?.toBuilder();
      _small_image_url = _$v.small_image_url;
      _large_image_url = _$v.large_image_url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuiltCouncilPost other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuiltCouncilPost;
  }

  @override
  void update(void Function(BuiltCouncilPostBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuiltCouncilPost build() {
    _$BuiltCouncilPost _$result;
    try {
      _$result = _$v ??
          new _$BuiltCouncilPost._(
              id: id,
              name: name,
              description: description,
              gensec: _gensec?.build(),
              joint_gensec: _joint_gensec?.build(),
              clubs: _clubs?.build(),
              small_image_url: small_image_url,
              large_image_url: large_image_url);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'gensec';
        _gensec?.build();
        _$failedField = 'joint_gensec';
        _joint_gensec?.build();
        _$failedField = 'clubs';
        _clubs?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuiltCouncilPost', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SecyPost extends SecyPost {
  @override
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String phone_number;
  @override
  final String photo_url;

  factory _$SecyPost([void Function(SecyPostBuilder) updates]) =>
      (new SecyPostBuilder()..update(updates)).build();

  _$SecyPost._(
      {this.id, this.name, this.email, this.phone_number, this.photo_url})
      : super._();

  @override
  SecyPost rebuild(void Function(SecyPostBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SecyPostBuilder toBuilder() => new SecyPostBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SecyPost &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        phone_number == other.phone_number &&
        photo_url == other.photo_url;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), name.hashCode), email.hashCode),
            phone_number.hashCode),
        photo_url.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SecyPost')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('phone_number', phone_number)
          ..add('photo_url', photo_url))
        .toString();
  }
}

class SecyPostBuilder implements Builder<SecyPost, SecyPostBuilder> {
  _$SecyPost _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phone_number;
  String get phone_number => _$this._phone_number;
  set phone_number(String phone_number) => _$this._phone_number = phone_number;

  String _photo_url;
  String get photo_url => _$this._photo_url;
  set photo_url(String photo_url) => _$this._photo_url = photo_url;

  SecyPostBuilder();

  SecyPostBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _email = _$v.email;
      _phone_number = _$v.phone_number;
      _photo_url = _$v.photo_url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SecyPost other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SecyPost;
  }

  @override
  void update(void Function(SecyPostBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SecyPost build() {
    final _$result = _$v ??
        new _$SecyPost._(
            id: id,
            name: name,
            email: email,
            phone_number: phone_number,
            photo_url: photo_url);
    replace(_$result);
    return _$result;
  }
}

class _$ClubListPost extends ClubListPost {
  @override
  final int id;
  @override
  final String name;
  @override
  final int council;
  @override
  final String small_image_url;
  @override
  final String large_image_url;

  factory _$ClubListPost([void Function(ClubListPostBuilder) updates]) =>
      (new ClubListPostBuilder()..update(updates)).build();

  _$ClubListPost._(
      {this.id,
      this.name,
      this.council,
      this.small_image_url,
      this.large_image_url})
      : super._();

  @override
  ClubListPost rebuild(void Function(ClubListPostBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClubListPostBuilder toBuilder() => new ClubListPostBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClubListPost &&
        id == other.id &&
        name == other.name &&
        council == other.council &&
        small_image_url == other.small_image_url &&
        large_image_url == other.large_image_url;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), name.hashCode), council.hashCode),
            small_image_url.hashCode),
        large_image_url.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClubListPost')
          ..add('id', id)
          ..add('name', name)
          ..add('council', council)
          ..add('small_image_url', small_image_url)
          ..add('large_image_url', large_image_url))
        .toString();
  }
}

class ClubListPostBuilder
    implements Builder<ClubListPost, ClubListPostBuilder> {
  _$ClubListPost _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _council;
  int get council => _$this._council;
  set council(int council) => _$this._council = council;

  String _small_image_url;
  String get small_image_url => _$this._small_image_url;
  set small_image_url(String small_image_url) =>
      _$this._small_image_url = small_image_url;

  String _large_image_url;
  String get large_image_url => _$this._large_image_url;
  set large_image_url(String large_image_url) =>
      _$this._large_image_url = large_image_url;

  ClubListPostBuilder();

  ClubListPostBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _council = _$v.council;
      _small_image_url = _$v.small_image_url;
      _large_image_url = _$v.large_image_url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClubListPost other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClubListPost;
  }

  @override
  void update(void Function(ClubListPostBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ClubListPost build() {
    final _$result = _$v ??
        new _$ClubListPost._(
            id: id,
            name: name,
            council: council,
            small_image_url: small_image_url,
            large_image_url: large_image_url);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
