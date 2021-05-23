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

  bool get isUserLoggedIn => (state is AuthenticatedAsUser);
  UserShelter get currentUser =>
      isUserLoggedIn ? (state as AuthenticatedAsUser).user : null;

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
        user = await dataRepo.createUser(
          userId: userId,
          email: user.email,
        );
      }
      emit(AuthenticatedAsUser(user: user));
    } on Exception {
      emit(AuthenticatedAsGuest());
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
      emit(AuthenticatedAsUser(user: user));
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void signOut() {
    authRepo.signOut();
    emit(AuthenticatedAsGuest());
  }
}
