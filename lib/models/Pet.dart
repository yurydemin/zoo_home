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
  final String userShelterId;
  final PetKind kind;
  final PetStatus status;
  final String title;
  final String description;
  final List<String> images;
  final String contact;
  final TemporalDateTime date;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const Pet._internal(
      {@required this.id,
      @required this.userShelterId,
      this.kind,
      this.status,
      this.title,
      this.description,
      @required this.images,
      this.contact,
      @required this.date});

  factory Pet(
      {String id,
      @required String userShelterId,
      PetKind kind,
      PetStatus status,
      String title,
      String description,
      @required List<String> images,
      String contact,
      @required TemporalDateTime date}) {
    return Pet._internal(
        id: id == null ? UUID.getUUID() : id,
        userShelterId: userShelterId,
        kind: kind,
        status: status,
        title: title,
        description: description,
        images: images != null ? List.unmodifiable(images) : images,
        contact: contact,
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
        userShelterId == other.userShelterId &&
        kind == other.kind &&
        status == other.status &&
        title == other.title &&
        description == other.description &&
        DeepCollectionEquality().equals(images, other.images) &&
        contact == other.contact &&
        date == other.date;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Pet {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userShelterId=" + "$userShelterId" + ", ");
    buffer.write("kind=" + (kind != null ? enumToString(kind) : "null") + ", ");
    buffer.write(
        "status=" + (status != null ? enumToString(status) : "null") + ", ");
    buffer.write("title=" + "$title" + ", ");
    buffer.write("description=" + "$description" + ", ");
    buffer.write(
        "images=" + (images != null ? images.toString() : "null") + ", ");
    buffer.write("contact=" + "$contact" + ", ");
    buffer.write("date=" + (date != null ? date.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Pet copyWith(
      {String id,
      String userShelterId,
      PetKind kind,
      PetStatus status,
      String title,
      String description,
      List<String> images,
      String contact,
      TemporalDateTime date}) {
    return Pet(
        id: id ?? this.id,
        userShelterId: userShelterId ?? this.userShelterId,
        kind: kind ?? this.kind,
        status: status ?? this.status,
        title: title ?? this.title,
        description: description ?? this.description,
        images: images ?? this.images,
        contact: contact ?? this.contact,
        date: date ?? this.date);
  }

  Pet.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userShelterId = json['userShelterId'],
        kind = enumFromString<PetKind>(json['kind'], PetKind.values),
        status = enumFromString<PetStatus>(json['status'], PetStatus.values),
        title = json['title'],
        description = json['description'],
        images = json['images']?.cast<String>(),
        contact = json['contact'],
        date = json['date'] != null
            ? TemporalDateTime.fromString(json['date'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userShelterId': userShelterId,
        'kind': enumToString(kind),
        'status': enumToString(status),
        'title': title,
        'description': description,
        'images': images,
        'contact': contact,
        'date': date?.format()
      };

  static final QueryField ID = QueryField(fieldName: "pet.id");
  static final QueryField USERSHELTERID =
      QueryField(fieldName: "userShelterId");
  static final QueryField KIND = QueryField(fieldName: "kind");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField IMAGES = QueryField(fieldName: "images");
  static final QueryField CONTACT = QueryField(fieldName: "contact");
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
        key: Pet.USERSHELTERID,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.KIND,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.STATUS,
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
        key: Pet.IMAGES,
        isRequired: true,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.string))));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Pet.CONTACT,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

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
