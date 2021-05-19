import 'package:flutter/foundation.dart';

abstract class SessionState {}

class UnknownSessionState extends SessionState {}

class Unauthenticated extends SessionState {}

class Authenticated extends SessionState {
  final dynamic userShelter;

  Authenticated({@required this.userShelter});
}
