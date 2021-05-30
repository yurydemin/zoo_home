import 'package:flutter/foundation.dart';
import 'package:zoo_home/auth/form_submission_status.dart';
import 'package:zoo_home/models/UserShelter.dart';

class UserShelterProfileState {
  final UserShelter user;
  final bool isCurrentUser;
  final String location;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String avatarUrl;
  final bool isUserChanged;

  String get email => user.email;

  final FormSubmissionStatus formStatus;
  bool avatarImageSourceActionSheetIsVisible;

  UserShelterProfileState({
    @required UserShelter user,
    @required bool isCurrentUser,
    String location,
    String title,
    String description,
    List<String> imageUrls,
    String avatarUrl,
    this.formStatus = const InitialFormStatus(),
    avatarImageSourceActionSheetIsVisible = false,
    isUserChanged = false,
  })  : this.user = user,
        this.isCurrentUser = isCurrentUser,
        this.location = location ?? user.location,
        this.title = title ?? user.title,
        this.description = description ?? user.description,
        this.imageUrls = imageUrls ?? <String>[],
        this.avatarUrl = avatarUrl,
        this.avatarImageSourceActionSheetIsVisible =
            avatarImageSourceActionSheetIsVisible,
        this.isUserChanged = isUserChanged;

  UserShelterProfileState copyWith({
    UserShelter user,
    String location,
    String title,
    String description,
    List<String> imageUrls,
    String avatarUrl,
    FormSubmissionStatus formStatus,
    bool avatarImageSourceActionSheetIsVisible,
    bool isUserChanged,
  }) {
    return UserShelterProfileState(
      user: user ?? this.user,
      isCurrentUser: this.isCurrentUser,
      location: location ?? this.location,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      formStatus: formStatus ?? this.formStatus,
      avatarImageSourceActionSheetIsVisible:
          avatarImageSourceActionSheetIsVisible ??
              this.avatarImageSourceActionSheetIsVisible,
      isUserChanged: isUserChanged ?? this.isUserChanged,
    );
  }
}
