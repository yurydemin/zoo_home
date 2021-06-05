import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/content_state.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_bloc.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_view.dart';
import 'package:zoo_home/content/pets/pets_cubit.dart';
import 'package:zoo_home/content/pets/pets_repository.dart';
import 'package:zoo_home/content/shelters/shelters_cubit.dart';
import 'package:zoo_home/content/shelters/shelters_repository.dart';
import 'package:zoo_home/content/shelters/shelters_view.dart';
import 'package:zoo_home/content/shelter_profile/shelter_profile_view.dart';
import 'package:zoo_home/models/ModelProvider.dart';

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
                child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SheltersCubit(
                      contentCubit: context.read<ContentCubit>(),
                      sheltersRepo: context.read<SheltersRepository>())
                    ..getShelters()
                    ..observeShelters(),
                ),
                BlocProvider(
                  create: (context) => PetsCubit(
                      contentCubit: context.read<ContentCubit>(),
                      petsRepo: context.read<PetsRepository>())
                    ..getPets()
                    ..observePets(),
                ),
              ],
              child: BlocProvider<FilteredSheltersBloc>(
                create: (context) => FilteredSheltersBloc(
                  sheltersCubit: context.read<SheltersCubit>(),
                ),
                child: SheltersView(),
              ),
            )),
            if (state.currentShelter != null)
              MaterialPage(
                  child: ShelterProfileView(
                selectedShelter: state.currentShelter,
              )),
            if (state.currentPet != null)
              MaterialPage(
                  child: PetProfileView(
                selectedPet: state.currentPet,
              )),
          ],
          onPopPage: (route, result) {
            BlocProvider.of<ContentCubit>(context).popToMain();
            if (result is Shelter)
              BlocProvider.of<ContentCubit>(context).updateSession(result);
            return route.didPop(result);
          },
        ),
      );
    }));
  }
}
