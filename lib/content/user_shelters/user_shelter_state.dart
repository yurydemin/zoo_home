import 'package:zoo_home/models/UserShelter.dart';

abstract class UserShelterState {}

class LoadingUserShelters extends UserShelterState {}

class ListUserSheltersSuccess extends UserShelterState {
  final List<UserShelter> userShelters;
  final Map<String, String> avatarsKeyUrl;

  ListUserSheltersSuccess({this.userShelters, this.avatarsKeyUrl});
}

class ListUserSheltersFailure extends UserShelterState {
  final Exception exception;

  ListUserSheltersFailure({this.exception});
}
