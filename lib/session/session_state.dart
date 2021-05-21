import 'package:flutter/foundation.dart';
import 'package:zoo_home/models/UserShelter.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class AuthenticatedAsGuest extends SessionState {}

class AuthenticatedAsUser extends SessionState {
  final UserShelter user;

  AuthenticatedAsUser({@required this.user});
}

//TODO Rejected states
class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final UserShelter user;
  UserShelter selectedUser;

  Authenticated({@required this.user});
}
