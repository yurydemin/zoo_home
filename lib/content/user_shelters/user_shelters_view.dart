import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/pets/pets_add_view.dart';
import 'package:zoo_home/content/pets/pets_cubit.dart';
import 'package:zoo_home/content/pets/pets_state.dart';
import 'package:zoo_home/content/user_shelter_pets/user_shelter_pets_bloc.dart';
import 'package:zoo_home/content/user_shelter_pets/user_shelter_pets_event.dart';
import 'package:zoo_home/content/user_shelter_pets/user_shelter_pets_state.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_cubit.dart';
import 'package:zoo_home/content/user_shelters/user_shelters_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/widgets/pet_card.dart';
import 'package:zoo_home/widgets/user_shelter_card.dart';

class UserSheltersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<ContentCubit>().isUserLoggedIn;
    return Scaffold(
      appBar: AppBar(
        title: Text('Зоодома'),
        centerTitle: true,
        actions: [
          if (!isLoggedIn)
            OneTapTooltip(
              message:
                  'Нажмите на кнопку справа, если хотите войти и создать свой Зоодом. Требуется авторизация',
              child: Icon(Icons.info_outline),
            ),
          IconButton(
            icon: Icon(isLoggedIn ? Icons.home : Icons.login),
            onPressed: () => isLoggedIn
                ? context.read<ContentCubit>().showUserProfile()
                : context.read<ContentCubit>().showAuth(),
          ),
        ],
      ),
      body: BlocBuilder<UserSheltersCubit, UserSheltersState>(
          builder: (context, state) {
        if (state is ListUserSheltersSuccess) {
          return state.userShelters.isEmpty
              ? _emptyUserSheltersView()
              : _userSheltersListView(state.userShelters, state.avatarsKeyUrl);
        } else if (state is ListUserSheltersFailure) {
          return _exceptionView(state.exception);
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
      //     BlocBuilder<PetsCubit, PetsState>(
      //   builder: (context, state) {
      //     if (state is LoadingPets) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (state is ListPetsSuccess) {
      //       return state.pets.isEmpty
      //           ? _emptyUserSheltersView()
      //           : _testPetsListView(state.pets);
      //     } else if (state is ListPetsFailure) {
      //       return _exceptionView(state.exception);
      //     } else {
      //       return Container(
      //         color: Colors.white,
      //         child: Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //       );
      //     }
      //   },
      // ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              tooltip: 'Добавить животное',
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (routedContext) => PetsAddView(
                            isEditing: false,
                            onSave: (
                              PetKind kind,
                              PetStatus status,
                              String title,
                              String description,
                            ) {
                              BlocProvider.of<PetsCubit>(context)
                                  .createPet(kind, status, title, description);
                            },
                          )),
                );
              },
            )
          : null,
    );
  }

  Widget _exceptionView(Exception exception) {
    return Text(exception.toString());
  }

  Widget _emptyUserSheltersView() {
    return Text('Еще не создано ни одного зоодома');
  }

  Widget _userSheltersListView(
      List<UserShelter> userShelters, Map<String, String> avatarsKeyUrl) {
    return ListView.builder(
      itemCount: userShelters.length,
      itemBuilder: (BuildContext context, int index) {
        final userShelter = userShelters[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserShelterCard(
                onTap: () => context
                    .read<ContentCubit>()
                    .showUserProfile(selectedUser: userShelter),
                userShelter: userShelter,
                avatarUrl: avatarsKeyUrl.containsKey(userShelter.avatarKey)
                    ? avatarsKeyUrl[userShelter.avatarKey]
                    : null),
            BlocProvider<UserShelterPetsBloc>(
              create: (context) => UserShelterPetsBloc(
                userShelterId: userShelter.id,
                petsCubit: BlocProvider.of<PetsCubit>(context),
              )..add(UserShelterPetsUpdatedEvent(userShelter.id)),
              child: _userShelterPetsList(),
            ),
          ],
        );
      },
    );
  }
}

Widget _userShelterPetsList() {
  return BlocBuilder<UserShelterPetsBloc, UserShelterPetsState>(
    builder: (context, state) {
      if (state is UserShelterPetsInitialState) {
        return Text('Загрузка животных зоодома...');
      } else if (state is UserShelterPetsLoadSuccessState) {
        final pets = state.pets;
        return pets.isEmpty
            ? Text('Еще не добавлено ни одного животного')
            : Column(
                children: [
                  ...pets.map((pet) {
                    return PetCard(
                      pet: pet,
                      onTap: () => context
                          .read<ContentCubit>()
                          .showPetProfile(selectedPet: pet),
                    );
                  }).toList(),
                ],
              );
      } else {
        return Text('Ошибка при загрузке списка животных');
      }
    },
  );
}

//TEST PETS LOADING AND PROFILE
// Widget _testPetsListView(List<Pet> pets) {
//   return ListView.builder(
//     itemCount: pets.length,
//     itemBuilder: (BuildContext context, int index) {
//       final pet = pets[index];
//       return PetCard(
//         pet: pet,
//         onTap: () =>
//             context.read<ContentCubit>().showPetProfile(selectedPet: pet),
//       );
//     },
//   );
// }

class OneTapTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  OneTapTooltip({@required this.message, @required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
      height: 50,
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
