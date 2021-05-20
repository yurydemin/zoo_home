import 'package:flutter/foundation.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/models/UserShelter.dart';

class UserShelterProfileState {
  final UserShelter user;
  final bool isCurrentUser;
  final String location;
  final String title;
  final String description;
  final List<String> images;
  final String avatarPath;

  String get email => user.email;

  final FormSubmissionStatus formStatus;

  UserShelterProfileState({
    @required UserShelter user,
    @required bool isCurrentUser,
    String location,
    String title,
    String description,
    List<String> images,
    String avatarPath,
    this.formStatus = const InitialFormStatus(),
  })  : this.user = user,
        this.isCurrentUser = isCurrentUser,
        this.location = location ?? user.location,
        this.title = title ?? user.title,
        this.description = description ?? user.description,
        this.images = images ?? user.images,
        this.avatarPath = avatarPath;

  UserShelterProfileState copyWith({
    UserShelter user,
    String location,
    String title,
    String description,
    List<String> images,
    String avatarPath,
    FormSubmissionStatus formStatus,
  }) {
    return UserShelterProfileState(
      user: user ?? this.user,
      isCurrentUser: this.isCurrentUser,
      location: location ?? this.location,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      avatarPath: avatarPath ?? this.avatarPath,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
