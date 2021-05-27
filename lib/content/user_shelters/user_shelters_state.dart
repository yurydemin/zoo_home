import 'package:zoo_home/models/UserShelter.dart';

abstract class UserSheltersState {}

class LoadingUserShelters extends UserSheltersState {}

class ListUserSheltersSuccess extends UserSheltersState {
  final List<UserShelter> userShelters;
  final Map<String, String> avatarsKeyUrl;

  ListUserSheltersSuccess({this.userShelters, this.avatarsKeyUrl});
}

class ListUserSheltersFailure extends UserSheltersState {
  final Exception exception;

  ListUserSheltersFailure({this.exception});
}
