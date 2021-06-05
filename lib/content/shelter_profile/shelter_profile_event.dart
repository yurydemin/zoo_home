import 'package:image_picker/image_picker.dart';

abstract class ShelterProfileEvent {}

class ChangeAvatarRequest extends ShelterProfileEvent {}

class OpenImagePicker extends ShelterProfileEvent {
  final ImageSource imageSource;

  OpenImagePicker({this.imageSource});
}

class ProvideAvatarImagePath extends ShelterProfileEvent {
  final String avatarUrl;

  ProvideAvatarImagePath({this.avatarUrl});
}

class OpenMultiImagePicker extends ShelterProfileEvent {
  final ImageSource imageSource;
  OpenMultiImagePicker({this.imageSource});
}

class ProvideProfileImagesPaths extends ShelterProfileEvent {
  final List<String> imageUrls;

  ProvideProfileImagesPaths({this.imageUrls});
}

class ShelterProfileLocationChanged extends ShelterProfileEvent {
  final String location;

  ShelterProfileLocationChanged({this.location});
}

class ShelterProfileTitleChanged extends ShelterProfileEvent {
  final String title;

  ShelterProfileTitleChanged({this.title});
}

class ShelterProfileDescriptionChanged extends ShelterProfileEvent {
  final String description;

  ShelterProfileDescriptionChanged({this.description});
}

class ShelterProfileRemoveImage extends ShelterProfileEvent {
  final String imageKey;
  final String imageUrl;

  ShelterProfileRemoveImage({this.imageKey, this.imageUrl});
}

class SaveShelterProfileChanges extends ShelterProfileEvent {}
