import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/session/session_cubit.dart';

class ContentCubit extends Cubit<ContentState> {
  final SessionCubit sessionCubit;

  ContentCubit({@required this.sessionCubit})
      : super(ContentState(selectedShelter: null, selectedPet: null));

  bool get isUserLoggedIn => sessionCubit.isUserLoggedIn;
  String get userShelterID =>
      sessionCubit.isUserLoggedIn ? sessionCubit.loggedInUserShelterID : null;

  void showAuth() => sessionCubit.showAuth();

  void showShelterProfile({
    Shelter selectedShelter,
  }) =>
      emit(ContentState(selectedShelter: selectedShelter, selectedPet: null));

  void showPetProfile({Shelter selectedShelter, Pet selectedPet}) => emit(
      ContentState(selectedShelter: selectedShelter, selectedPet: selectedPet));

  void popToMain() =>
      emit(ContentState(selectedShelter: null, selectedPet: null));

  void signOut() {
    popToMain();
    sessionCubit.signOut();
  }
}
