/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Pet type in your schema. */
@immutable
class Pet extends Model {
  static const classType = const _PetModelType();
  final String id;
  final String shelterID;
  final PetStatus status;
  final PetKind kind;
  final String title;
  final String description;
  final List<String> imageKeys;
  final TemporalDateTime date;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const Pet._internal(
      {@required this.id,
      this.shelterID,
      this.status,
      this.kind,
      this.title,
      this.description,
      @required this.imageKeys,
      @required this.date});

  factory Pet(
      {String id,
      String shelterID,
      PetStatus status,
      PetKind kind,
      String title,
      String description,
      @required List<String> imageKeys,
      @required TemporalDateTime date}) {
    return Pet._internal(
        id: id == null ? UUID.getUUID() : id,
        shelterID: shelterID,
        status: status,
        kind: kind,
        title: title,
        description: description,
        imageKeys: imageKeys != null ? List.unmodifiable(imageKeys) : imageKeys,
        date: date);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Pet &&
        id == other.id &&
        shelterID == other.shelterID &&
        status == other.status &&
        kind == other.kind &&
        title == other.title &&
        description == other.description &&
        DeepCollectionEquality().equals(imageKeys, other.imageKeys) &&
        date == other.date;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Pet {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("shelterID=" + "$shelterID" + ", ");
    buffer.write(
        "status=" + (status != null ? enumToString(status) : "null") + ", ");
    buffer.write("kind=" + (kind != null ? enumToString(kind) : "null") + ", ");
    buffer.write("title=" + "$title" + ", ");
    buffer.write("description=" + "$description" + ", ");
    buffer.write("imageKeys=" +
        (imageKeys != null ? imageKeys.toString() : "null") +
        ", ");
    buffer.write("date=" + (date != null ? date.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Pet copyWith(
      {String id,
      String shelterID,
      PetStatus status,
      PetKind kind,
      String title,
      String description,
      List<String> imageKeys,
      TemporalDateTime date}) {
    return Pet(
        id: id ?? this.id,
        shelterID: shelterID ?? this.shelterID,
        status: status ?? this.status,
        kind: kind ?? this.kind,
        title: title ?? this.title,
        description: description ?? this.description,
        imageKeys: imageKeys ?? this.imageKeys,
        date: date ?? this.date);
  }

  Pet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        shelterID = json['shelterID'],
        status = enumFromString<PetStatus>(json['status'], PetStatus.values),
        kind = enumFromString<PetKind>(json['kind'], PetKind.values),
        title = json['title'],
        description = json['description'],
        imageKeys = json['imageKeys']?.cast<String>(),
        date = json['date'] != null
            ? TemporalDateTime.fromString(json['date'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'shelterID': shelterID,
        'status': enumToString(status),
        'kind': enumToString(kind),
        'title': title,
        'description': description,
        'imageKeys': imageKeys,
        'date': date?.format()
      };

  static final QueryField ID = QueryField(fieldName: "pet.id");
  static final QueryField SHELTERID = QueryField(fieldName: "shelterID");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static final QueryField KIND = QueryField(fieldName: "kind");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField IMAGEKEYS = QueryField(fieldName: "imageKeys");
  static final QueryField DATE = QueryField(fieldName: "date");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Pet";
    modelSchemaDefinition.pluralName = "Pets";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.SHELTERID,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.STATUS,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.KIND,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.TITLE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.DESCRIPTION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.IMAGEKEYS,
        isRequired: true,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.string))));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.DATE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));
  });
}

class _PetModelType extends ModelType<Pet> {
  const _PetModelType();

  @override
  Pet fromJson(Map<String, dynamic> jsonData) {
    return Pet.fromJson(jsonData);
  }
}
