import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/content_state.dart';
import 'package:zoo_home/content/pet_profile/pet_profile_view.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_cubit.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_repository.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_view.dart';
import 'package:zoo_home/content/user_shelter_profile/user_shelter_profile_view.dart';

class ContentNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(builder: ((context, state) {
      return Navigator(
        pages: [
          MaterialPage(
            child: BlocProvider(
              create: (context) => UserSheltersCubit(
                  contentCubit: context.read<ContentCubit>(),
                  userShelterRepo: context.read<UserSheltersRepository>())
                ..getUserShelters()
                ..observeUserShelters(),
              child: UserSheltersView(),
            ),
          ),
          if (state.currentUserShelter != null)
            MaterialPage(
                child: UserShelterProfileView(
              selectedUser: state.currentUserShelter,
            )),
          if (state.currentPet != null)
            MaterialPage(
                child: PetProfileView(
              selectedPet: state.currentPet,
            )),
        ],
        onPopPage: (route, result) {
          BlocProvider.of<ContentCubit>(context).popToMain();
          return route.didPop(result);
        },
      );
    }));
  }
}
