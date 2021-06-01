import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_credentials.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_repository.dart';
import 'package:zoo_home/session/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  final UserSheltersRepository userShelterRepo;

  bool get isGuestLoggedIn => (state is AuthenticatedAsGuestState);
  bool get isUserLoggedIn => (state is AuthenticatedAsUserState);
  UserShelter get currentUser =>
      isUserLoggedIn ? (state as AuthenticatedAsUserState).user : null;

  SessionCubit({
    @required this.authRepo,
    @required this.userShelterRepo,
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
        UserShelter user = await userShelterRepo.getUserById(userId);
        if (user == null) {
          // user = await userShelterRepo.createUser(
          //   userId: userId,
          //   email: user.email,
          // );
          //throw Exception('User auth exception');
          emit(AuthenticatedAsGuestState());
        } else {
          emit(AuthenticatedAsUserState(user: user));
        }
      }
    } on Exception catch (e) {
      print(e.toString());
      //emit(AuthenticatedAsGuest());
    }
  }

  void showAuth() => emit(UnauthenticatedState());

  void popToMain() => emit(AuthenticatedAsGuestState());

  void showSession(AuthCredentials credentials) async {
    try {
      UserShelter user =
          await userShelterRepo.getUserById(credentials.userShelterId);

      if (user == null) {
        user = await userShelterRepo.createUser(
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
