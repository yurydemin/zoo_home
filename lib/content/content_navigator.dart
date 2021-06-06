import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/content_state.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_bloc.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_view.dart';
import 'package:zoo_home/content/shelters/shelters_cubit.dart';
import 'package:zoo_home/repositories/pets_repository.dart';
import 'package:zoo_home/repositories/shelters_repository.dart';
import 'package:zoo_home/content/shelters/shelters_view.dart';
import 'package:zoo_home/content/shelter_profile/shelter_profile_view.dart';

class ContentNavigator extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(builder: ((context, state) {
      return WillPopScope(
        onWillPop: () async {
          _navigatorKey.currentState.maybePop();
          return false;
        },
        child: Navigator(
          key: _navigatorKey,
          pages: [
            MaterialPage(
                child: BlocProvider(
              create: (context) => SheltersCubit(
                  contentCubit: context.read<ContentCubit>(),
                  sheltersRepo: context.read<SheltersRepository>(),
                  petsRepo: context.read<PetsRepository>())
                ..getShelters()
                ..observeShelters(),
              child: BlocProvider(
                create: (context) => FilteredSheltersBloc(
                  sheltersCubit: context.read<SheltersCubit>(),
                ),
                child: SheltersView(),
              ),
            )),
            if (state.selectedShelter != null && state.selectedPetIndex == null)
              MaterialPage(
                  child: ShelterProfileView(
                selectedShelter: state.selectedShelter,
              )),
            if (state.selectedShelter != null && state.selectedPetIndex != null)
              MaterialPage(
                  child: PetProfileView(
                selectedPet: state.selectedShelter.pets[state.selectedPetIndex],
                selectedPetShelter: state.selectedShelter,
              )),
          ],
          onPopPage: (route, result) {
            BlocProvider.of<ContentCubit>(context).popToMain();
            return route.didPop(result);
          },
        ),
      );
    }));
  }
}
