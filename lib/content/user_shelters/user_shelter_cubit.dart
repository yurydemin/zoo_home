import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/user_shelters/user_shelter_repository.dart';
import 'package:zoo_home/content/user_shelters/user_shelter_state.dart';
import 'package:zoo_home/services/image_url_cache.dart';

class UserShelterCubit extends Cubit<UserShelterState> {
  final UserShelterRepository userShelterRepo;

  UserShelterCubit({@required this.userShelterRepo})
      : super(LoadingUserShelters());

  void getTodos() async {
    if (state is ListUserSheltersSuccess == false) {
      emit(LoadingUserShelters());
    }

    try {
      // load all shelters
      final userShelters = await userShelterRepo.getUserShelters();
      // preload avatars urls
      final avatarsKeyUrl = Map<String, String>();
      Future.wait(userShelters.map((userShelter) async {
        avatarsKeyUrl[userShelter.avatarKey] =
            await ImageUrlCache.instance.getUrl(userShelter.avatarKey);
      }));
      // ok
      emit(ListUserSheltersSuccess(
        userShelters: userShelters,
        avatarsKeyUrl: avatarsKeyUrl,
      ));
    } catch (e) {
      emit(ListUserSheltersFailure(exception: e));
    }
  }
}
