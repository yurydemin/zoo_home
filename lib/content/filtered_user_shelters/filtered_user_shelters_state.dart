import 'package:zoo_home/models/UserShelter.dart';

abstract class FilteredUserSheltersState {}

class FilteredUserSheltersLoadInProgressState
    extends FilteredUserSheltersState {}

class FilteredUserSheltersLoadSuccessState extends FilteredUserSheltersState {
  final List<UserShelter> filteredUserShelters;
  final Map<String, String> avatarsKeyUrl;
  final String searchFilter;

  FilteredUserSheltersLoadSuccessState(
    this.filteredUserShelters,
    this.avatarsKeyUrl,
    this.searchFilter,
  );
}
