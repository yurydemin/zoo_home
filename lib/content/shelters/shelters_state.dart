import 'package:zoo_home/models/ModelProvider.dart';

abstract class SheltersState {}

class LoadingSheltersState extends SheltersState {}

class ListSheltersSuccessState extends SheltersState {
  final List<Shelter> shelters;
  final List<Pet> pets;
  final Map<String, String> avatarsKeyUrl;

  ListSheltersSuccessState({this.shelters, this.pets, this.avatarsKeyUrl});
}

class ListSheltersFailureState extends SheltersState {
  final Exception exception;

  ListSheltersFailureState({this.exception});
}
