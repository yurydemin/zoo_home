import 'package:image_picker/image_picker.dart';
import 'package:zoo_home/models/ModelProvider.dart';

abstract class PetProfileEvent {}

class PetProfileKindChanged extends PetProfileEvent {
  final PetKind kind;

  PetProfileKindChanged({this.kind});
}

class PetProfileStatusChanged extends PetProfileEvent {
  final PetStatus status;

  PetProfileStatusChanged({this.status});
}

class PetProfileTitleChanged extends PetProfileEvent {
  final String title;

  PetProfileTitleChanged({this.title});
}

class PetProfileDescriptionChanged extends PetProfileEvent {
  final String description;

  PetProfileDescriptionChanged({this.description});
}

class OpenMultiImagePicker extends PetProfileEvent {
  final ImageSource imageSource;
  OpenMultiImagePicker({this.imageSource});
}

class ProvideProfileImagesPaths extends PetProfileEvent {
  final List<String> imageUrls;

  ProvideProfileImagesPaths({this.imageUrls});
}

class PetProfileRemoveImage extends PetProfileEvent {
  final String imageKey;
  final String imageUrl;

  PetProfileRemoveImage({this.imageKey, this.imageUrl});
}

class SavePetProfileChanges extends PetProfileEvent {}
