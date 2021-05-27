import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoo_home/content/content_cubit.dart';
import 'package:zoo_home/content/pets/pets_cubit.dart';
import 'package:zoo_home/content/pets/pets_state.dart';
import 'package:zoo_home/models/ModelProvider.dart';
import 'package:zoo_home/widgets/pet_card.dart';

class PetsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetsCubit, PetsState>(builder: (context, state) {
      if (state is ListPetsSuccess) {
        return state.pets.isEmpty
            ? _emptyPetsView()
            : _userPetsListView(state.pets);
      } else if (state is ListPetsFailure) {
        return _exceptionView(state.exception);
      } else {
        return ListTile(
          tileColor: Colors.white,
          title: CircularProgressIndicator(),
        );
      }
    });
  }

  Widget _exceptionView(Exception exception) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(Icons.error_outline),
      title: Text(exception.toString()),
    );
  }

  Widget _emptyPetsView() {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(Icons.pets),
      title: Text('Еще не добавлено ни одного животного'),
    );
  }

  Widget _userPetsListView(List<Pet> pets) {
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (BuildContext context, int index) {
        final pet = pets[index];
        return PetCard(
            onTap: () =>
                context.read<ContentCubit>().showPetProfile(selectedPet: pet),
            pet: pet);
      },
    );
  }
}
