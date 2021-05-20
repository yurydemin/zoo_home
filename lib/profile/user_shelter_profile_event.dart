abstract class UserShelterProfileEvent {}

class ChangeAvatarRequest extends UserShelterProfileEvent {}

class UploadGalleryRequest extends UserShelterProfileEvent {}

class OpenImagePicker extends UserShelterProfileEvent {}

class OpenMultiImagePicker extends UserShelterProfileEvent {}

class ProvideImagePath extends UserShelterProfileEvent {
  final String avatarPath;

  ProvideImagePath({this.avatarPath});
}

class UserShelterProfileLocationChanged extends UserShelterProfileEvent {
  final String location;

  UserShelterProfileLocationChanged({this.location});
}

class UserShelterProfileTitleChanged extends UserShelterProfileEvent {
  final String title;

  UserShelterProfileTitleChanged({this.title});
}

class UserShelterProfileDescriptionChanged extends UserShelterProfileEvent {
  final String description;

  UserShelterProfileDescriptionChanged({this.description});
}

class SaveUserShelterProfileChanges extends UserShelterProfileEvent {}
