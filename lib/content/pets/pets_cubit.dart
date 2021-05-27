import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/pets/pets_repository.dart';
import 'package:zoo_home/content/pets/pets_state.dart';

class PetsCubit extends Cubit<PetsState> {
  final ContentCubit contentCubit;
  final PetsRepository petsRepo;

  PetsCubit({@required this.contentCubit, @required this.petsRepo})
      : super(LoadingPets());

  void getPets() async {
    if (state is ListPetsSuccess == false) {
      emit(LoadingPets());
    }

    try {
      // load all shelters
      final pets = await petsRepo.getPets();
      // ok
      emit(ListPetsSuccess(
        pets: pets,
      ));
    } catch (e) {
      emit(ListPetsFailure(exception: e));
    }
  }

  void observePets() {
    final petsStream = petsRepo.observePets();
    petsStream.listen((_) => getPets());
  }
}
