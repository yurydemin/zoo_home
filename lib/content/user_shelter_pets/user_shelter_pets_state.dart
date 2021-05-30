import 'package:zoo_home/models/ModelProvider.dart';

abstract class UserShelterPetsState {}

class UserShelterPetsInitialState extends UserShelterPetsState {}

class UserShelterPetsLoadSuccessState extends UserShelterPetsState {
  final String userShelterId;
  final List<Pet> pets;
  final Map<String, String> avatarsKeyUrl;

  UserShelterPetsLoadSuccessState({
    this.userShelterId,
    this.pets,
    this.avatarsKeyUrl,
  });
}
