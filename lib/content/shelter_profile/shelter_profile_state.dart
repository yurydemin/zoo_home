import 'package:flutter/foundation.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class ShelterProfileState {
  final Shelter shelter;
  final bool isCurrentShelter;
  final String location;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String avatarUrl;

  String get email => shelter.contact;

  final FormSubmissionStatus formStatus;
  bool avatarImageSourceActionSheetIsVisible;

  ShelterProfileState({
    @required Shelter shelter,
    @required bool isCurrentShelter,
    String location,
    String title,
    String description,
    List<String> imageUrls,
    String avatarUrl,
    this.formStatus = const InitialFormStatus(),
    avatarImageSourceActionSheetIsVisible = false,
  })  : this.shelter = shelter,
        this.isCurrentShelter = isCurrentShelter,
        this.location = location ?? shelter.location,
        this.title = title ?? shelter.title,
        this.description = description ?? shelter.description,
        this.imageUrls = imageUrls ?? <String>[],
        this.avatarUrl = avatarUrl,
        this.avatarImageSourceActionSheetIsVisible =
            avatarImageSourceActionSheetIsVisible;

  ShelterProfileState copyWith({
    Shelter shelter,
    String location,
    String title,
    String description,
    List<String> imageUrls,
    String avatarUrl,
    FormSubmissionStatus formStatus,
    bool avatarImageSourceActionSheetIsVisible,
  }) {
    return ShelterProfileState(
      shelter: shelter ?? this.shelter,
      isCurrentShelter: this.isCurrentShelter,
      location: location ?? this.location,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      formStatus: formStatus ?? this.formStatus,
      avatarImageSourceActionSheetIsVisible:
          avatarImageSourceActionSheetIsVisible ??
              this.avatarImageSourceActionSheetIsVisible,
    );
  }
}
