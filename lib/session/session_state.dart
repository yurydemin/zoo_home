import 'package:flutter/foundation.dart';
import 'package:zoo_home/models/UserShelter.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final UserShelter userShelter;

  Authenticated({@required this.userShelter});
}
