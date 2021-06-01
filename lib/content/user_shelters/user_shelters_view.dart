import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/filtered_user_shelters/filtered_user_shelters_bloc.dart';
import 'package:zoo_home/content/filtered_user_shelters/filtered_user_shelters_event.dart';
import 'package:zoo_home/content/filtered_user_shelters/filtered_user_shelters_state.dart';
import 'package:zoo_home/content/pets/pets_add_view.dart';
import 'package:zoo_home/content/pets/pets_cubit.dart';
import 'package:zoo_home/content/user_shelter_pets/user_shelter_pets_bloc.dart';
import 'package:zoo_home/content/user_shelter_pets/user_shelter_pets_event.dart';
import 'package:zoo_home/content/user_shelter_pets/user_shelter_pets_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/widgets/pet_card.dart';
import 'package:zoo_home/widgets/search_textfield.dart';
import 'package:zoo_home/widgets/user_shelter_card.dart';

class UserSheltersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<ContentCubit>().isUserLoggedIn;
    String loggedUserShelterId = context.read<ContentCubit>().userId;
    return Scaffold(
      appBar: AppBar(
        title: SearchTextfield(
          searchFilter: '',
          onChanged: (value) {
            BlocProvider.of<FilteredUserSheltersBloc>(context)
                .add(FilterUpdated(value));
          },
        ),
        leading: Icon(Icons.search),
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
      body: BlocBuilder<FilteredUserSheltersBloc, FilteredUserSheltersState>(
          builder: (context, state) {
        if (state is FilteredUserSheltersLoadSuccessState) {
          final loggedUserShelterIndex = loggedUserShelterId == null
              ? -1
              : state.filteredUserShelters
                  .indexWhere((item) => item.id == loggedUserShelterId);
          return state.filteredUserShelters.isEmpty
              ? _emptyUserSheltersView()
              : _userSheltersListView(
                  state.filteredUserShelters,
                  state.avatarsKeyUrl,
                  loggedUserShelterIndex,
                );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
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

  // Widget _exceptionView(Exception exception) {
  //   return Text(exception.toString());
  // }

  Widget _emptyUserSheltersView() {
    return Center(child: Text('Еще не создано ни одного зоодома'));
  }

  Widget _userSheltersListView(List<UserShelter> userShelters,
      Map<String, String> avatarsKeyUrl, int loggedUserShelterIndex) {
    return ListView.builder(
      itemCount: userShelters.length,
      itemBuilder: (BuildContext context, int index) {
        final userShelter = loggedUserShelterIndex == -1
            ? userShelters[index]
            : index == 0
                ? userShelters[loggedUserShelterIndex]
                : index == loggedUserShelterIndex
                    ? userShelters[0]
                    : userShelters[index];
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
                    final avatarUrl = pet.images.isNotEmpty
                        ? state.avatarsKeyUrl.containsKey(pet.images.first)
                            ? state.avatarsKeyUrl[pet.images.first]
                            : null
                        : null;
                    return Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: PetCard(
                        avatarUrl: avatarUrl,
                        pet: pet,
                        onTap: () => context
                            .read<ContentCubit>()
                            .showPetProfile(selectedPet: pet),
                      ),
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
