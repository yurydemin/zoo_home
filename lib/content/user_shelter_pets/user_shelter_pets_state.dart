import 'package:zoo_home/models/ModelProvider.dart';

abstract class UserShelterPetsState {}

class UserShelterPetsInitialState extends UserShelterPetsState {}

class UserShelterPetsLoadSuccessState extends UserShelterPetsState {
  final String userShelterId;
  final List<Pet> pets;

  UserShelterPetsLoadSuccessState(
    this.userShelterId,
    this.pets,
  );
}
