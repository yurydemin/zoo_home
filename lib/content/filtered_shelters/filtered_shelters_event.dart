import 'package:zoo_home/models/ModelProvider.dart';

abstract class FilteredSheltersEvent {}

class FilterUpdated extends FilteredSheltersEvent {
  final String searchFilter;

  FilterUpdated(this.searchFilter);
}

class SheltersUpdated extends FilteredSheltersEvent {
  final List<Shelter> shelters;
  final List<Pet> pets;

  SheltersUpdated(this.shelters, this.pets);
}
