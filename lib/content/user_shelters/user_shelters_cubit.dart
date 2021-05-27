import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_repository.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_state.dart';
import 'package:zoo_home/services/image_url_cache.dart';

class UserSheltersCubit extends Cubit<UserSheltersState> {
  final ContentCubit contentCubit;
  final UserSheltersRepository userShelterRepo;

  UserSheltersCubit(
      {@required this.contentCubit, @required this.userShelterRepo})
      : super(LoadingUserShelters());

  void getUserShelters() async {
    if (state is ListUserSheltersSuccess == false) {
      emit(LoadingUserShelters());
    }

    try {
      // load all shelters
      final userShelters = await userShelterRepo.getUserShelters();
      // preload avatars urls
      final avatarsKeyUrl = Map<String, String>();
      await Future.wait(userShelters.map((userShelter) async {
        if (userShelter.avatarKey != null && userShelter.avatarKey.isNotEmpty)
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

  void observeUserShelters() {
    final userSheltersStream = userShelterRepo.observeUserShelters();
    userSheltersStream.listen((_) => getUserShelters());
  }
}
