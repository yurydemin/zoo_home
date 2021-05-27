import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/models/UserShelter.dart';
import 'package:zoo_home/session/session_cubit.dart';

class ContentCubit extends Cubit<ContentState> {
  final SessionCubit sessionCubit;

  ContentCubit({@required this.sessionCubit})
      : super(ContentState(
            currentUserShelter: sessionCubit.currentUser, currentPet: null));

  bool get isUserLoggedIn => sessionCubit.isUserLoggedIn;

  void showAuth() => sessionCubit.showAuth();

  void showUserProfile({
    UserShelter selectedUser,
  }) =>
      emit(ContentState(
          currentUserShelter: selectedUser ?? sessionCubit.currentUser,
          currentPet: null));

  void showPetProfile({Pet selectedPet}) =>
      emit(ContentState(currentUserShelter: null, currentPet: selectedPet));

  void popToMain() =>
      emit(ContentState(currentUserShelter: null, currentPet: null));

  void signOut() {
    popToMain();
    sessionCubit.signOut();
  }
}
