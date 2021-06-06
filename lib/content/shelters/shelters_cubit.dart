import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/repositories/pets_repository.dart';
import 'package:zoo_home/repositories/shelters_repository.dart';
import 'package:zoo_home/content/shelters/shelters_state.dart';
import 'package:zoo_home/services/image_url_cache.dart';

class SheltersCubit extends Cubit<SheltersState> {
  final ContentCubit contentCubit;
  final SheltersRepository sheltersRepo;
  final PetsRepository petsRepo;

  SheltersCubit(
      {@required this.contentCubit,
      @required this.sheltersRepo,
      @required this.petsRepo})
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

  void createPet(
    PetKind kind,
    PetStatus status,
    String title,
    String description,
  ) async {
    if (!contentCubit.isUserLoggedIn) return;
    try {
      // create new pet item
      final newPet = await petsRepo.createPet(
        shelterID: contentCubit.userShelterID,
        kind: kind,
        status: status,
        title: title,
        description: description,
        imageKeys: [],
        date: TemporalDateTime(DateTime.now()),
      );
      _updateShelterWithPet(newPet);
    } catch (e) {
      print(e.toString());
    }
  }

  void _updateShelterWithPet(Pet updatedPet) async {
    if (state is ListSheltersSuccessState == false) return;
    try {
      // get shelter to add/update pet
      final currentShelter = (state as ListSheltersSuccessState)
          .shelters
          .firstWhere((shelter) => shelter.id == contentCubit.userShelterID);
      // add/update pet
      final newPetsList = [
        ...currentShelter.pets.where((pet) => pet.id != updatedPet.id).toList(),
        updatedPet
      ];
      final updatedShelter = currentShelter.copyWith(pets: newPetsList);
      // update shelter with new pets list
      await sheltersRepo.updateShelter(updatedShelter);
    } catch (e) {
      print(e.toString());
    }
    getShelters();
  }
}
