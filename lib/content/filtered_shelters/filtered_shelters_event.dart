import 'package:zoo_home/models/ModelProvider.dart';

abstract class FilteredSheltersEvent {}

class FilterUpdated extends FilteredSheltersEvent {
  final String searchFilter;

  FilterUpdated(this.searchFilter);
}

class SheltersUpdated extends FilteredSheltersEvent {
  final List<Shelter> shelters;

  SheltersUpdated(this.shelters);
}
