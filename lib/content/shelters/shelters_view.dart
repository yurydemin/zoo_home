import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_bloc.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_event.dart';
import 'package:zoo_home/content/filtered_shelters/filtered_shelters_state.dart';
import 'package:zoo_home/content/shelters/shelters_cubit.dart';
import 'package:zoo_home/views/create_pet_view.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/widgets/pet_card.dart';
import 'package:zoo_home/widgets/search_textfield.dart';
import 'package:zoo_home/widgets/user_shelter_card.dart';

class SheltersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<ContentCubit>().isUserLoggedIn;
    String loggedInUserShelterID = context.read<ContentCubit>().userShelterID;
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
            onPressed: () {
              _dropFocusNode(context);
              isLoggedIn
                  ? context.read<ContentCubit>().showShelterProfile()
                  : context.read<ContentCubit>().showAuth();
            },
          ),
        ],
      ),
      body: BlocBuilder<FilteredSheltersBloc, FilteredSheltersState>(
          builder: (context, state) {
        if (state is FilteredSheltersLoadSuccessState) {
          // check index to set current shelter to the top of shelters list
          final loggedUserShelterIndex = loggedInUserShelterID == null
              ? -1
              : state.filteredShelters
                  .indexWhere((item) => item.id == loggedInUserShelterID);
          return state.filteredShelters.isEmpty
              ? _emptyUserSheltersView()
              : RefreshIndicator(
                  child: _userSheltersListView(
                    state.filteredShelters,
                    state.filteredPets,
                    state.avatarsKeyUrl,
                    loggedUserShelterIndex,
                  ),
                  onRefresh: () async {
                    context.read<SheltersCubit>().getShelters();
                  });
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
                      builder: (routedContext) => CreatePetView(
                            isEditing: false,
                            onSave: (
                              PetKind kind,
                              PetStatus status,
                              String title,
                              String description,
                            ) {
                              BlocProvider.of<SheltersCubit>(context)
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

  Widget _userSheltersListView(List<Shelter> shelters, List<Pet> pets,
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
        final shelterPets =
            pets.where((pet) => pet.shelterID == shelter.id).toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShelterCard(
                onTap: () {
                  _dropFocusNode(context);
                  context
                      .read<ContentCubit>()
                      .showShelterProfile(selectedShelter: shelter);
                },
                shelter: shelter,
                avatarUrl: avatarsKeyUrl.containsKey(shelter.avatarKey)
                    ? avatarsKeyUrl[shelter.avatarKey]
                    : null),
            shelterPets == null || shelterPets.isEmpty
                ? Text('Еще не добавлено ни одного животного')
                : Column(
                    children: [
                      ...shelterPets.map((pet) {
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
                              onTap: () {
                                _dropFocusNode(context);
                                context.read<ContentCubit>().showPetProfile(
                                    selectedShelter: shelter, selectedPet: pet);
                              }),
                        );
                      }).toList(),
                    ],
                  ),
          ],
        );
      },
    );
  }

  void _dropFocusNode(BuildContext context) {
    FocusScopeNode curentScope = FocusScope.of(context);
    if (!curentScope.hasPrimaryFocus && curentScope.hasFocus) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
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
