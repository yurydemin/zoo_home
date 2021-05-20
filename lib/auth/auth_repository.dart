import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  Future<String> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'sub')
          .value;
      return userId;
    } catch (e) {
      throw e;
    }
  }

  Future<String> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      throw e;
    }
  }

  Future<String> login({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email.trim(),
        password: password.trim(),
      );

      return result.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> signUp({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: email.trim(),
        password: password.trim(),
      );
      return result.isSignUpComplete;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> confirmSignUp({
    @required String email,
    @required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email.trim(),
        confirmationCode: confirmationCode.trim(),
      );
      return result.isSignUpComplete;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }
}
