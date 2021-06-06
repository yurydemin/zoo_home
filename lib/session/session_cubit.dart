import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_credentials.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/repositories/shelters_repository.dart';
import 'package:zoo_home/repositories/users_repository.dart';
import 'package:zoo_home/session/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  final UsersRepository usersRepo;
  final SheltersRepository sheltersRepo;

  bool get isUserLoggedIn => (state is AuthenticatedAsUserState);
  String get loggedInUserShelterID => isUserLoggedIn
      ? (state as AuthenticatedAsUserState).user.shelterID
      : null;

  SessionCubit({
    @required this.authRepo,
    @required this.usersRepo,
    @required this.sheltersRepo,
  }) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepo.attemptAutoLogin();
      if (userId == null) {
        emit(AuthenticatedAsGuestState());
      } else {
        User user = await usersRepo.getUserById(userId);
        if (user == null) {
          emit(AuthenticatedAsGuestState());
        } else {
          emit(AuthenticatedAsUserState(user: user));
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void showAuth() => emit(UnauthenticatedState());

  void popToMain() => emit(AuthenticatedAsGuestState());

  void showSession(AuthCredentials credentials) async {
    try {
      User user = await usersRepo.getUserById(credentials.userId);

      if (user == null) {
        final newUserEmptyShelterID = await sheltersRepo.createEmptyShelter(
            credentials.email, credentials.userId);
        user = await usersRepo.createUser(
          userId: credentials.userId,
          email: credentials.email,
          shelterID: newUserEmptyShelterID,
        );
      }
      emit(AuthenticatedAsUserState(user: user));
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }

  void signOut() {
    authRepo.signOut();
    emit(AuthenticatedAsGuestState());
  }
}
