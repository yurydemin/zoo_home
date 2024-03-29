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

/** This is an auto generated class representing the Shelter type in your schema. */
@immutable
class Shelter extends Model {
  static const classType = const _ShelterModelType();
  final String id;
  final String location;
  final String title;
  final String description;
  final String contact;
  final String avatarKey;
  final List<String> imageKeys;
  final String userID;
  final List<String> pets;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const Shelter._internal(
      {@required this.id,
      this.location,
      this.title,
      this.description,
      @required this.contact,
      this.avatarKey,
      @required this.imageKeys,
      @required this.userID,
      @required this.pets});

  factory Shelter(
      {String id,
      String location,
      String title,
      String description,
      @required String contact,
      String avatarKey,
      @required List<String> imageKeys,
      @required String userID,
      @required List<String> pets}) {
    return Shelter._internal(
        id: id == null ? UUID.getUUID() : id,
        location: location,
        title: title,
        description: description,
        contact: contact,
        avatarKey: avatarKey,
        imageKeys: imageKeys != null ? List.unmodifiable(imageKeys) : imageKeys,
        userID: userID,
        pets: pets != null ? List.unmodifiable(pets) : pets);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Shelter &&
        id == other.id &&
        location == other.location &&
        title == other.title &&
        description == other.description &&
        contact == other.contact &&
        avatarKey == other.avatarKey &&
        DeepCollectionEquality().equals(imageKeys, other.imageKeys) &&
        userID == other.userID &&
        DeepCollectionEquality().equals(pets, other.pets);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Shelter {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("location=" + "$location" + ", ");
    buffer.write("title=" + "$title" + ", ");
    buffer.write("description=" + "$description" + ", ");
    buffer.write("contact=" + "$contact" + ", ");
    buffer.write("avatarKey=" + "$avatarKey" + ", ");
    buffer.write("imageKeys=" +
        (imageKeys != null ? imageKeys.toString() : "null") +
        ", ");
    buffer.write("userID=" + "$userID" + ", ");
    buffer.write("pets=" + (pets != null ? pets.toString() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Shelter copyWith(
      {String id,
      String location,
      String title,
      String description,
      String contact,
      String avatarKey,
      List<String> imageKeys,
      String userID,
      List<String> pets}) {
    return Shelter(
        id: id ?? this.id,
        location: location ?? this.location,
        title: title ?? this.title,
        description: description ?? this.description,
        contact: contact ?? this.contact,
        avatarKey: avatarKey ?? this.avatarKey,
        imageKeys: imageKeys ?? this.imageKeys,
        userID: userID ?? this.userID,
        pets: pets ?? this.pets);
  }

  Shelter.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        location = json['location'],
        title = json['title'],
        description = json['description'],
        contact = json['contact'],
        avatarKey = json['avatarKey'],
        imageKeys = json['imageKeys']?.cast<String>(),
        userID = json['userID'],
        pets = json['pets']?.cast<String>();

  Map<String, dynamic> toJson() => {
        'id': id,
        'location': location,
        'title': title,
        'description': description,
        'contact': contact,
        'avatarKey': avatarKey,
        'imageKeys': imageKeys,
        'userID': userID,
        'pets': pets
      };

  static final QueryField ID = QueryField(fieldName: "shelter.id");
  static final QueryField LOCATION = QueryField(fieldName: "location");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField CONTACT = QueryField(fieldName: "contact");
  static final QueryField AVATARKEY = QueryField(fieldName: "avatarKey");
  static final QueryField IMAGEKEYS = QueryField(fieldName: "imageKeys");
  static final QueryField USERID = QueryField(fieldName: "userID");
  static final QueryField PETS = QueryField(fieldName: "pets");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Shelter";
    modelSchemaDefinition.pluralName = "Shelters";

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
        key: Shelter.LOCATION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Shelter.TITLE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Shelter.DESCRIPTION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Shelter.CONTACT,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Shelter.AVATARKEY,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Shelter.IMAGEKEYS,
        isRequired: true,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.string))));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Shelter.USERID,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Shelter.PETS,
        isRequired: true,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.string))));
  });
}

class _ShelterModelType extends ModelType<Shelter> {
  const _ShelterModelType();

  @override
  Shelter fromJson(Map<String, dynamic> jsonData) {
    return Shelter.fromJson(jsonData);
  }
}
