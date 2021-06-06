import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_bloc.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_event.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_state.dart';
import 'package:zoo_home/content/pets/pets_add_view.dart';
import 'package:zoo_home/content/pets/pets_cubit.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/widgets/pet_card.dart';
import 'package:zoo_home/widgets/search_textfield.dart';
import 'package:zoo_home/widgets/user_shelter_card.dart';

class SheltersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FocusScopeNode curentScope = FocusScope.of(context);
    // if (!curentScope.hasPrimaryFocus && curentScope.hasFocus) {
    //   FocusManager.instance.primaryFocus.unfocus();
    // }
    bool isLoggedIn = context.read<ContentCubit>().isUserLoggedIn;
    String loggedInUserId = context.read<ContentCubit>().userId;
    return Scaffold(
      appBar: AppBar(
        title: SearchTextfield(
          searchFilter: '',
          onChanged: (value) {
            BlocProvider.of<FilteredSheltersBloc>(context)
                .add(FilterUpdated(value));
          },
        ),
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
                ? context.read<ContentCubit>().showShelterProfile()
                : context.read<ContentCubit>().showAuth(),
          ),
        ],
      ),
      body: BlocBuilder<FilteredSheltersBloc, FilteredSheltersState>(
          builder: (context, state) {
        if (state is FilteredSheltersLoadSuccessState) {
          final loggedUserShelterIndex = loggedInUserId == null
              ? -1
              : state.filteredShelters
                  .indexWhere((item) => item.userId == loggedInUserId);
          return state.filteredShelters.isEmpty
              ? _emptyUserSheltersView()
              : _userSheltersListView(
                  state.filteredShelters,
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
    return Container();
    //Center(child: Text('Еще не создано ни одного зоодома'));
  }

  Widget _userSheltersListView(List<Shelter> shelters,
      Map<String, String> avatarsKeyUrl, int loggedUserShelterIndex) {
    return ListView.builder(
      itemCount: shelters.length,
      itemBuilder: (BuildContext context, int index) {
        final shelter = loggedUserShelterIndex == -1
            ? shelters[index]
            : index == 0
                ? shelters[loggedUserShelterIndex]
                : index == loggedUserShelterIndex
                    ? shelters[0]
                    : shelters[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShelterCard(
                onTap: () => context
                    .read<ContentCubit>()
                    .showShelterProfile(selectedShelter: shelter),
                shelter: shelter,
                avatarUrl: avatarsKeyUrl.containsKey(shelter.avatarKey)
                    ? avatarsKeyUrl[shelter.avatarKey]
                    : null),
            shelter.pets.isEmpty
                ? Text('Еще не добавлено ни одного животного')
                : Column(
                    children: [
                      ...shelter.pets.map((pet) {
                        final avatarUrl = pet.imageKeys.isNotEmpty
                            ? avatarsKeyUrl.containsKey(pet.imageKeys.first)
                                ? avatarsKeyUrl[pet.imageKeys.first]
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
                  ),
          ],
        );
      },
    );
  }
}

// Widget _userShelterPetsList() {
//   return BlocBuilder<UserShelterPetsBloc, UserShelterPetsState>(
//     builder: (context, state) {
//       if (state is UserShelterPetsInitialState) {
//         return Text('Загрузка животных зоодома...');
//       } else if (state is UserShelterPetsLoadSuccessState) {
//         final pets = state.pets;
//         return pets.isEmpty
//             ? Text('Еще не добавлено ни одного животного')
//             : Column(
//                 children: [
//                   ...pets.map((pet) {
//                     final avatarUrl = pet.imageKeys.isNotEmpty
//                         ? state.avatarsKeyUrl.containsKey(pet.imageKeys.first)
//                             ? state.avatarsKeyUrl[pet.imageKeys.first]
//                             : null
//                         : null;
//                     return Padding(
//                       padding: const EdgeInsets.only(left: 24.0),
//                       child: PetCard(
//                         avatarUrl: avatarUrl,
//                         pet: pet,
//                         onTap: () => context
//                             .read<ContentCubit>()
//                             .showPetProfile(selectedPet: pet),
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               );
//       } else {
//         return Text('Ошибка при загрузке списка животных');
//       }
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
