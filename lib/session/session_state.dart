import 'package:flutter/foundation.dart';
import 'package:zoo_home/models/ModelProvider.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class UnauthenticatedState extends SessionState {}

class AuthenticatedAsGuestState extends SessionState {}

class AuthenticatedAsUserState extends SessionState {
  final User user;

  AuthenticatedAsUserState({@required this.user});
}
