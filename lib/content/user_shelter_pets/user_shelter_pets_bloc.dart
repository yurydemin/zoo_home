import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/pets/pets_cubit.dart';
import 'package:zoo_home/content/pets/pets_state.dart';
import 'package:zoo_home/content/user_shelter_pets/user_shelter_pets_event.dart';
import 'package:zoo_home/content/user_shelter_pets/user_shelter_pets_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/services/image_url_cache.dart';

class UserShelterPetsBloc
    extends Bloc<UserShelterPetsEvent, UserShelterPetsState> {
  final String userShelterId;
  final PetsCubit petsCubit;
  StreamSubscription petsSubscription;

  UserShelterPetsBloc({@required this.userShelterId, @required this.petsCubit})
      : super(UserShelterPetsInitialState()) {
    petsSubscription = petsCubit.stream.listen((state) {
      if (state is ListPetsSuccess) {
        add(UserShelterPetsUpdatedEvent(userShelterId));
      }
    });
  }

  @override
  Stream<UserShelterPetsState> mapEventToState(
      UserShelterPetsEvent event) async* {
    if (event is UserShelterPetsUpdatedEvent) {
      yield* _mapPetsUpdateToState(event);
    }
  }

  Stream<UserShelterPetsState> _mapPetsUpdateToState(
      UserShelterPetsUpdatedEvent event) async* {
    if (petsCubit.state is ListPetsSuccess) {
      // filter pets by userShelterId
      final filteredPets = _mapPetsToShelterPets(
        event.userShelterId,
        (petsCubit.state as ListPetsSuccess).pets,
      );
      // preload avatars urls
      final avatarsKeyUrl = Map<String, String>();
      await Future.wait(filteredPets.map((pet) async {
        if (pet.images.isNotEmpty)
          avatarsKeyUrl[pet.images.first] =
              await ImageUrlCache.instance.getUrl(pet.images.first);
      }));
      yield UserShelterPetsLoadSuccessState(
        userShelterId: event.userShelterId,
        pets: filteredPets,
        avatarsKeyUrl: avatarsKeyUrl,
      );
    }
  }

  List<Pet> _mapPetsToShelterPets(String userShelterId, List<Pet> pets) {
    return pets.where((pet) {
      return pet.userShelterId == userShelterId;
    }).toList();
  }

  @override
  Future<void> close() {
    petsSubscription.cancel();
    return super.close();
  }
}
