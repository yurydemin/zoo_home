import 'package:flutter/foundation.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class PetProfileState {
  final Pet pet;
  final bool isCurrentPet;
  final PetKind kind;
  final PetStatus status;
  final String title;
  final String description;
  final List<String> imageUrls;

  String get ownerUserShelterId => pet.userShelterId;
  final FormSubmissionStatus formStatus;

  PetProfileState({
    @required Pet pet,
    @required bool isCurrentPet,
    PetKind kind,
    PetStatus status,
    String title,
    String description,
    List<String> imageUrls,
    this.formStatus = const InitialFormStatus(),
  })  : this.pet = pet,
        this.isCurrentPet = isCurrentPet,
        this.kind = kind ?? pet.kind,
        this.status = status ?? pet.status,
        this.title = title ?? pet.title,
        this.description = description ?? pet.description,
        this.imageUrls = imageUrls ?? <String>[];

  PetProfileState copyWith({
    Pet pet,
    bool isCurrentPet,
    PetKind kind,
    PetStatus status,
    String title,
    String description,
    List<String> imageUrls,
    FormSubmissionStatus formStatus,
  }) {
    return PetProfileState(
      pet: pet ?? this.pet,
      isCurrentPet: this.isCurrentPet,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
