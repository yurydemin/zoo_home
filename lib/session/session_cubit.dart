import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_credentials.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/repositories/users_repository.dart';
import 'package:zoo_home/session/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  final UsersRepository usersRepo;

  bool get isUserLoggedIn => (state is AuthenticatedAsUserState);
  User get loggedInUser =>
      isUserLoggedIn ? (state as AuthenticatedAsUserState).user : null;

  SessionCubit({
    @required this.authRepo,
    @required this.usersRepo,
  }) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepo.attemptAutoLogin();
      if (userId == null) {
        //throw Exception('User not logged in');
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
      User user = await usersRepo.getUserById(credentials.userShelterId);

      if (user == null) {
        user = await usersRepo.createUser(
          userId: credentials.userShelterId,
          email: credentials.email,
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
