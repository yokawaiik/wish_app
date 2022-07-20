// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetWishCollectionCollection on Isar {
  IsarCollection<WishCollection> get wishCollections => collection();
}

const WishCollectionSchema = CollectionSchema(
  name: r'WishCollection',
  schema:
      r'{"name":"WishCollection","idName":"key","properties":[{"name":"id","type":"Long"},{"name":"imageUrl","type":"String"},{"name":"title","type":"String"},{"name":"userColor","type":"String"}],"indexes":[{"name":"id","unique":true,"replace":false,"properties":[{"name":"id","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: r'key',
  propertyIds: {r'id': 0, r'imageUrl': 1, r'title': 2, r'userColor': 3},
  listProperties: {},
  indexIds: {r'id': 0},
  indexValueTypes: {
    r'id': [
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _wishCollectionGetId,
  getLinks: _wishCollectionGetLinks,
  attachLinks: _wishCollectionAttachLinks,
  serializeNative: _wishCollectionSerializeNative,
  deserializeNative: _wishCollectionDeserializeNative,
  deserializePropNative: _wishCollectionDeserializePropNative,
  serializeWeb: _wishCollectionSerializeWeb,
  deserializeWeb: _wishCollectionDeserializeWeb,
  deserializePropWeb: _wishCollectionDeserializePropWeb,
  version: 4,
);

int? _wishCollectionGetId(WishCollection object) {
  if (object.key == Isar.autoIncrement) {
    return null;
  } else {
    return object.key;
  }
}

List<IsarLinkBase<dynamic>> _wishCollectionGetLinks(WishCollection object) {
  return [];
}

void _wishCollectionSerializeNative(
    IsarCollection<WishCollection> collection,
    IsarCObject cObj,
    WishCollection object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  IsarUint8List? imageUrl$Bytes;
  final imageUrl$Value = object.imageUrl;
  if (imageUrl$Value != null) {
    imageUrl$Bytes = IsarBinaryWriter.utf8Encoder.convert(imageUrl$Value);
  }
  final title$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.title);
  IsarUint8List? userColor$Bytes;
  final userColor$Value = object.userColor;
  if (userColor$Value != null) {
    userColor$Bytes = IsarBinaryWriter.utf8Encoder.convert(userColor$Value);
  }
  final size = (staticSize +
      3 +
      (imageUrl$Bytes?.length ?? 0) +
      3 +
      (title$Bytes.length) +
      3 +
      (userColor$Bytes?.length ?? 0)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeLong(offsets[0], object.id);
  writer.writeByteList(offsets[1], imageUrl$Bytes);
  writer.writeByteList(offsets[2], title$Bytes);
  writer.writeByteList(offsets[3], userColor$Bytes);
}

WishCollection _wishCollectionDeserializeNative(
    IsarCollection<WishCollection> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = WishCollection(
    id: reader.readLong(offsets[0]),
    imageUrl: reader.readStringOrNull(offsets[1]),
    title: reader.readString(offsets[2]),
    userColor: reader.readStringOrNull(offsets[3]),
  );
  return object;
}

P _wishCollectionDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _wishCollectionSerializeWeb(
    IsarCollection<WishCollection> collection, WishCollection object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'imageUrl', object.imageUrl);
  IsarNative.jsObjectSet(jsObj, r'key', object.key);
  IsarNative.jsObjectSet(jsObj, r'title', object.title);
  IsarNative.jsObjectSet(jsObj, r'userColor', object.userColor);
  return jsObj;
}

WishCollection _wishCollectionDeserializeWeb(
    IsarCollection<WishCollection> collection, Object jsObj) {
  final object = WishCollection(
    id: IsarNative.jsObjectGet(jsObj, r'id') ??
        (double.negativeInfinity as int),
    imageUrl: IsarNative.jsObjectGet(jsObj, r'imageUrl'),
    title: IsarNative.jsObjectGet(jsObj, r'title') ?? '',
    userColor: IsarNative.jsObjectGet(jsObj, r'userColor'),
  );
  return object;
}

P _wishCollectionDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id') ??
          (double.negativeInfinity as int)) as P;
    case r'imageUrl':
      return (IsarNative.jsObjectGet(jsObj, r'imageUrl')) as P;
    case r'key':
      return (IsarNative.jsObjectGet(jsObj, r'key')) as P;
    case r'title':
      return (IsarNative.jsObjectGet(jsObj, r'title') ?? '') as P;
    case r'userColor':
      return (IsarNative.jsObjectGet(jsObj, r'userColor')) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _wishCollectionAttachLinks(
    IsarCollection<dynamic> col, int id, WishCollection object) {}

extension WishCollectionByIndex on IsarCollection<WishCollection> {
  Future<WishCollection?> getById(int id) {
    return getByIndex(r'id', [id]);
  }

  WishCollection? getByIdSync(int id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(int id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(int id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<WishCollection?>> getAllById(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<WishCollection?> getAllByIdSync(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<int> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<int> putById(WishCollection object) {
    return putByIndex(r'id', object);
  }

  int putByIdSync(WishCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<int>> putAllById(List<WishCollection> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<int> putAllByIdSync(List<WishCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension WishCollectionQueryWhereSort
    on QueryBuilder<WishCollection, WishCollection, QWhere> {
  QueryBuilder<WishCollection, WishCollection, QAfterWhere> anyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'id'),
      );
    });
  }
}

extension WishCollectionQueryWhere
    on QueryBuilder<WishCollection, WishCollection, QWhereClause> {
  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> keyEqualTo(
      int key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: key,
        upper: key,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> keyNotEqualTo(
      int key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: key, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: key, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: key, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: key, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause>
      keyGreaterThan(int key, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: key, includeLower: include),
      );
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> keyLessThan(
      int key,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: key, includeUpper: include),
      );
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> keyBetween(
    int lowerKey,
    int upperKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerKey,
        includeLower: includeLower,
        upper: upperKey,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> idEqualTo(
      int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> idNotEqualTo(
      int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [id],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [],
        upper: [id],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [lowerId],
        includeLower: includeLower,
        upper: [upperId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WishCollectionQueryFilter
    on QueryBuilder<WishCollection, WishCollection, QFilterCondition> {
  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      imageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      keyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      keyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      keyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      keyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userColor',
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterFilterCondition>
      userColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension WishCollectionQueryLinks
    on QueryBuilder<WishCollection, WishCollection, QFilterCondition> {}

extension WishCollectionQueryWhereSortBy
    on QueryBuilder<WishCollection, WishCollection, QSortBy> {
  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy>
      sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> sortByUserColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userColor', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy>
      sortByUserColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userColor', Sort.desc);
    });
  }
}

extension WishCollectionQueryWhereSortThenBy
    on QueryBuilder<WishCollection, WishCollection, QSortThenBy> {
  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy>
      thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy> thenByUserColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userColor', Sort.asc);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QAfterSortBy>
      thenByUserColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userColor', Sort.desc);
    });
  }
}

extension WishCollectionQueryWhereDistinct
    on QueryBuilder<WishCollection, WishCollection, QDistinct> {
  QueryBuilder<WishCollection, WishCollection, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<WishCollection, WishCollection, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WishCollection, WishCollection, QDistinct> distinctByUserColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userColor', caseSensitive: caseSensitive);
    });
  }
}

extension WishCollectionQueryProperty
    on QueryBuilder<WishCollection, WishCollection, QQueryProperty> {
  QueryBuilder<WishCollection, int, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<WishCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WishCollection, String?, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<WishCollection, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<WishCollection, String?, QQueryOperations> userColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userColor');
    });
  }
}
