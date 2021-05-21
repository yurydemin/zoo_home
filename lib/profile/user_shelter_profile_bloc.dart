import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/profile/user_shelter_profile_event.dart';
import 'package:zoo_home/profile/user_shelter_profile_state.dart';

class UserShelterProfileBloc
    extends Bloc<UserShelterProfileEvent, UserShelterProfileState> {
  final _imagePicker = ImagePicker();

  UserShelterProfileBloc(
      {@required UserShelter user, @required bool isCurrentUser})
      : super(
            UserShelterProfileState(user: user, isCurrentUser: isCurrentUser));

  @override
  Stream<UserShelterProfileState> mapEventToState(
      UserShelterProfileEvent event) async* {
    if (event is ChangeAvatarRequest) {
      yield state.copyWith(avatarImageSourceActionSheetIsVisible: true);
    } else if (event is OpenImagePicker) {
      yield state.copyWith(avatarImageSourceActionSheetIsVisible: false);
      final pickedImage =
          await _imagePicker.getImage(source: event.imageSource);
      if (pickedImage == null) return;
      yield state.copyWith(avatarPath: pickedImage.path);
    } else if (event is ProvideAvatarImagePath) {
      yield state.copyWith(avatarPath: event.avatarPath);
    } else if (event is ChangeProfileImagesRequest) {
      // show action sheet (gallery or camera)
    } else if (event is OpenMultiImagePicker) {
      // open multi image picker to fill gallery
    } else if (event is ProvideProfileImagesPaths) {
      // get gallery images
    } else if (event is UserShelterProfileLocationChanged) {
      yield state.copyWith(location: event.location);
    } else if (event is UserShelterProfileTitleChanged) {
      yield state.copyWith(title: event.title);
    } else if (event is UserShelterProfileDescriptionChanged) {
      yield state.copyWith(description: event.description);
    } else if (event is SaveUserShelterProfileChanges) {
      // handle save changes
    }
  }
}
