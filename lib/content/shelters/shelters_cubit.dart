import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/repositories/shelters_repository.dart';
import 'package:zoo_home/content/shelters/shelters_state.dart';
import 'package:zoo_home/services/image_url_cache.dart';

class SheltersCubit extends Cubit<SheltersState> {
  final ContentCubit contentCubit;
  final SheltersRepository sheltersRepo;

  SheltersCubit({@required this.contentCubit, @required this.sheltersRepo})
      : super(LoadingSheltersState());

  void getShelters() async {
    if (state is ListSheltersSuccessState == false) {
      emit(LoadingSheltersState());
    }

    try {
      // load all shelters
      final shelters = await sheltersRepo.getShelters();
      // preload avatars urls
      final avatarsKeyUrl = Map<String, String>();
      Future.wait(shelters.map((shelter) async {
        if (shelter.avatarKey != null && shelter.avatarKey.isNotEmpty)
          avatarsKeyUrl[shelter.avatarKey] =
              await ImageUrlCache.instance.getUrl(shelter.avatarKey);
        await Future.wait(shelter.pets.map((pet) async {
          if (pet.imageKeys.isNotEmpty)
            avatarsKeyUrl[pet.imageKeys.first] =
                await ImageUrlCache.instance.getUrl(pet.imageKeys.first);
        }));
      })).then((_) => // ok
          emit(ListSheltersSuccessState(
            shelters: shelters,
            avatarsKeyUrl: avatarsKeyUrl,
          )));
    } catch (e) {
      emit(ListSheltersFailureState(exception: e));
    }
  }

  void observeShelters() {
    final sheltersStream = sheltersRepo.observeShelters();
    sheltersStream.listen((_) => getShelters());
  }
}
