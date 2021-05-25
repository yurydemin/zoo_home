import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/session/session_cubit.dart';

class ContentCubit extends Cubit<UserShelter> {
  final SessionCubit sessionCubit;

  ContentCubit({@required this.sessionCubit}) : super(sessionCubit.currentUser);

  bool get isUserLoggedIn => sessionCubit.isUserLoggedIn;

  void showAuth() => sessionCubit.showAuth();

  void showProfile({
    UserShelter selectedUser,
  }) =>
      emit(selectedUser ?? sessionCubit.currentUser);

  void popToMain() => emit(null);

  void signOut() {
    popToMain();
    sessionCubit.signOut();
  }
}
