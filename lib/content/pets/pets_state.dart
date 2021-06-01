import 'package:zoo_home/models/ModelProvider.dart';

abstract class PetsState {}

class LoadingPetsState extends PetsState {}

class ListPetsSuccessState extends PetsState {
  final List<Pet> pets;

  ListPetsSuccessState({this.pets});
}

class ListPetsFailureState extends PetsState {
  final Exception exception;

  ListPetsFailureState({this.exception});
}
