import 'package:zoo_home/models/ModelProvider.dart';

abstract class FilteredUserSheltersEvent {}

class FilterUpdated extends FilteredUserSheltersEvent {
  final String searchFilter;

  FilterUpdated(this.searchFilter);
}

class UserSheltersUpdated extends FilteredUserSheltersEvent {
  final List<UserShelter> userShelters;

  UserSheltersUpdated(this.userShelters);
}
