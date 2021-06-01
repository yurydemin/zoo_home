import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/pets/pets_repository.dart';
import 'package:zoo_home/content/pets/pets_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class PetsCubit extends Cubit<PetsState> {
  final ContentCubit contentCubit;
  final PetsRepository petsRepo;

  PetsCubit({@required this.contentCubit, @required this.petsRepo})
      : super(LoadingPetsState());

  void getPets() async {
    if (state is ListPetsSuccessState == false) {
      emit(LoadingPetsState());
    }

    try {
      // load all shelters
      final pets = await petsRepo.getPets();
      // ok
      emit(ListPetsSuccessState(
        pets: pets,
      ));
    } catch (e) {
      emit(ListPetsFailureState(exception: e));
    }
  }

  void observePets() {
    final petsStream = petsRepo.observePets();
    petsStream.listen((_) => getPets());
  }

  void createPet(
    PetKind kind,
    PetStatus status,
    String title,
    String description,
  ) async {
    if (!contentCubit.isUserLoggedIn) return;
    await petsRepo.createPet(
      userShelterId: contentCubit.userId,
      kind: kind,
      status: status,
      title: title,
      description: description,
      images: [],
      contact: contentCubit.userContact,
      date: TemporalDateTime(DateTime.now()),
    );
  }
}
