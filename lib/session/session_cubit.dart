import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_credentials.dart';
import 'package:zoo_home/auth/auth_repository.dart';
import 'package:zoo_home/session/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;

  SessionCubit({this.authRepo}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepo.attemptAutoLogin();
      // final user = dataRepo.getUser(userId);
      final user = userId;
      emit(Authenticated(userShelter: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showSession(AuthCredentials credentials) {
    // final user = dataRepo.getUser(credentials.userId);
    final user = credentials.email;
    emit(Authenticated(userShelter: user));
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
