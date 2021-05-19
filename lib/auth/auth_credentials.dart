import 'package:flutter/foundation.dart';

class AuthCredentials {
  final String email;
  final String password;
  String userShelterId;

  AuthCredentials({
    @required this.email,
    this.password,
    this.userShelterId,
  });
}
