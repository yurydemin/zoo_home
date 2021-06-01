import 'package:zoo_home/models/UserShelter.dart';

abstract class UserSheltersState {}

class LoadingUserSheltersState extends UserSheltersState {}

class ListUserSheltersSuccessState extends UserSheltersState {
  final List<UserShelter> userShelters;
  final Map<String, String> avatarsKeyUrl;

  ListUserSheltersSuccessState({this.userShelters, this.avatarsKeyUrl});
}

class ListUserSheltersFailureState extends UserSheltersState {
  final Exception exception;

  ListUserSheltersFailureState({this.exception});
}
