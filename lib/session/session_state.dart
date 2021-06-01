import 'package:flutter/foundation.dart';
import 'package:zoo_home/models/UserShelter.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class UnauthenticatedState extends SessionState {}

class AuthenticatedAsGuestState extends SessionState {}

class AuthenticatedAsUserState extends SessionState {
  final UserShelter user;

  AuthenticatedAsUserState({@required this.user});
}
