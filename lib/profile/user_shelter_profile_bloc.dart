import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/profile/user_shelter_profile_event.dart';
import 'package:zoo_home/profile/user_shelter_profile_state.dart';

class UserShelterProfileBloc
    extends Bloc<UserShelterProfileEvent, UserShelterProfileState> {
  UserShelterProfileBloc(
      {@required UserShelter user, @required bool isCurrentUser})
      : super(
            UserShelterProfileState(user: user, isCurrentUser: isCurrentUser));

  @override
  Stream<UserShelterProfileState> mapEventToState(
      UserShelterProfileEvent event) async* {
    if (event is ChangeAvatarRequest) {
      // show action sheet (gallery or camera)
    } else if (event is OpenImagePicker) {
      // open image picker
    } else if (event is UploadGalleryRequest) {
      // show action sheet (gallery or camera)
    } else if (event is OpenMultiImagePicker) {
      // open multi image picker to fill gallery
    } else if (event is ProvideImagePath) {
      yield state.copyWith(avatarPath: event.avatarPath);
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
