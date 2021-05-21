import 'package:image_picker/image_picker.dart';

abstract class UserShelterProfileEvent {}

class ChangeAvatarRequest extends UserShelterProfileEvent {}

class OpenImagePicker extends UserShelterProfileEvent {
  final ImageSource imageSource;

  OpenImagePicker({this.imageSource});
}

class ProvideAvatarImagePath extends UserShelterProfileEvent {
  final String avatarPath;

  ProvideAvatarImagePath({this.avatarPath});
}

class ChangeProfileImagesRequest extends UserShelterProfileEvent {}

class OpenMultiImagePicker extends UserShelterProfileEvent {}

class ProvideProfileImagesPaths extends UserShelterProfileEvent {
  final List<String> images;

  ProvideProfileImagesPaths({this.images});
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
