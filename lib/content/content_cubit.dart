import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/auth/auth_credentials.dart';
import 'package:zoo_home/content/content_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/session/session_cubit.dart';

class ContentCubit extends Cubit<ContentState> {
  final SessionCubit sessionCubit;

  ContentCubit({@required this.sessionCubit})
      : super(ContentState(currentShelter: null, currentPet: null));

  bool get isUserLoggedIn => sessionCubit.isUserLoggedIn;
  String get userId =>
      sessionCubit.isUserLoggedIn ? sessionCubit.currentUser.id : null;
  String get userContact =>
      sessionCubit.isUserLoggedIn ? sessionCubit.currentUser.email : '';

  void showAuth() => sessionCubit.showAuth();

  void showUserProfile({
    Shelter selectedShelter,
  }) =>
      emit(ContentState(currentShelter: selectedShelter, currentPet: null));

  void showPetProfile({Pet selectedPet}) =>
      emit(ContentState(currentShelter: null, currentPet: selectedPet));

  void popToMain() =>
      emit(ContentState(currentShelter: null, currentPet: null));

  void updateSession(Shelter updatedShelter) {
    sessionCubit.showSession(AuthCredentials(
        email: updatedShelter.contact, userShelterId: updatedShelter.id));
  }

  void signOut() {
    popToMain();
    sessionCubit.signOut();
  }
}
