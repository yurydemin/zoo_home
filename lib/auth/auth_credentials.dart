import 'package:flutter/foundation.dart';

class AuthCredentials {
  final String email;
  final String password;
  String userId;

  AuthCredentials({
    @required this.email,
    this.password,
    this.userId,
  });
}
