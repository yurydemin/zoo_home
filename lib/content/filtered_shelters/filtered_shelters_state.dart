import 'package:zoo_home/models/ModelProvider.dart';

abstract class FilteredSheltersState {}

class FilteredSheltersLoadInProgressState extends FilteredSheltersState {}

class FilteredSheltersLoadSuccessState extends FilteredSheltersState {
  final List<Shelter> filteredShelters;
  final List<Pet> filteredPets;
  final Map<String, String> avatarsKeyUrl;
  final String searchFilter;

  FilteredSheltersLoadSuccessState(
    this.filteredShelters,
    this.filteredPets,
    this.avatarsKeyUrl,
    this.searchFilter,
  );
}
