import 'package:zoo_home/models/ModelProvider.dart';

abstract class PetsState {}

class LoadingPets extends PetsState {}

class ListPetsSuccess extends PetsState {
  final List<Pet> pets;

  ListPetsSuccess({this.pets});
}

class ListPetsFailure extends PetsState {
  final Exception exception;

  ListPetsFailure({this.exception});
}
