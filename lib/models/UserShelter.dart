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

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the UserShelter type in your schema. */
@immutable
class UserShelter extends Model {
  static const classType = const _UserShelterModelType();
  final String id;
  final String email;
  final String location;
  final String title;
  final String description;
  final List<String> images;
  final String avatarKey;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const UserShelter._internal(
      {@required this.id,
      @required this.email,
      this.location,
      this.title,
      this.description,
      @required this.images,
      this.avatarKey});

  factory UserShelter(
      {String id,
      @required String email,
      String location,
      String title,
      String description,
      @required List<String> images,
      String avatarKey}) {
    return UserShelter._internal(
        id: id == null ? UUID.getUUID() : id,
        email: email,
        location: location,
        title: title,
        description: description,
        images: images != null ? List.unmodifiable(images) : images,
        avatarKey: avatarKey);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserShelter &&
        id == other.id &&
        email == other.email &&
        location == other.location &&
        title == other.title &&
        description == other.description &&
        DeepCollectionEquality().equals(images, other.images) &&
        avatarKey == other.avatarKey;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("UserShelter {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("email=" + "$email" + ", ");
    buffer.write("location=" + "$location" + ", ");
    buffer.write("title=" + "$title" + ", ");
    buffer.write("description=" + "$description" + ", ");
    buffer.write(
        "images=" + (images != null ? images.toString() : "null") + ", ");
    buffer.write("avatarKey=" + "$avatarKey");
    buffer.write("}");

    return buffer.toString();
  }

  UserShelter copyWith(
      {String id,
      String email,
      String location,
      String title,
      String description,
      List<String> images,
      String avatarKey}) {
    return UserShelter(
        id: id ?? this.id,
        email: email ?? this.email,
        location: location ?? this.location,
        title: title ?? this.title,
        description: description ?? this.description,
        images: images ?? this.images,
        avatarKey: avatarKey ?? this.avatarKey);
  }

  UserShelter.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        location = json['location'],
        title = json['title'],
        description = json['description'],
        images = json['images']?.cast<String>(),
        avatarKey = json['avatarKey'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'location': location,
        'title': title,
        'description': description,
        'images': images,
        'avatarKey': avatarKey
      };

  static final QueryField ID = QueryField(fieldName: "userShelter.id");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static final QueryField LOCATION = QueryField(fieldName: "location");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField IMAGES = QueryField(fieldName: "images");
  static final QueryField AVATARKEY = QueryField(fieldName: "avatarKey");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserShelter";
    modelSchemaDefinition.pluralName = "UserShelters";

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
        key: UserShelter.EMAIL,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserShelter.LOCATION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserShelter.TITLE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserShelter.DESCRIPTION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserShelter.IMAGES,
        isRequired: true,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.string))));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: UserShelter.AVATARKEY,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class _UserShelterModelType extends ModelType<UserShelter> {
  const _UserShelterModelType();

  @override
  UserShelter fromJson(Map<String, dynamic> jsonData) {
    return UserShelter.fromJson(jsonData);
  }
}
