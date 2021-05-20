import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_credentials.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/repositories/data_repository.dart';
import 'package:zoo_home/session/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  final DataRepository dataRepo;

  SessionCubit({
    @required this.authRepo,
    @required this.dataRepo,
  }) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepo.attemptAutoLogin();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      UserShelter user = await dataRepo.getUserById(userId);
      if (user == null) {
        //TODO AuthenticatedAsGuest
        user = await dataRepo.createUser(
          userId: userId,
          email: user.email,
        );
      }
      emit(Authenticated(userShelter: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) async {
    try {
      UserShelter user = await dataRepo.getUserById(credentials.userShelterId);

      if (user == null) {
        user = await dataRepo.createUser(
          userId: credentials.userShelterId,
          email: credentials.email,
        );
      }
      //TODO AuthenticatedAsUser
      emit(Authenticated(userShelter: user));
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
