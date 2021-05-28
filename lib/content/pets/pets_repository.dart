import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class PetsRepository {
  Future<List<Pet>> getPets() async {
    try {
      final pets = await Amplify.DataStore.query(
        Pet.classType,
      );
      return pets;
    } catch (e) {
      throw e;
    }
  }

  Future<Pet> createPet({
    @required String userShelterId,
    @required PetKind kind,
    @required PetStatus status,
    @required String title,
    @required String description,
    @required List<String> images,
    @required TemporalDateTime date,
  }) async {
    final newPet = Pet(
        userShelterId: userShelterId,
        kind: kind,
        status: status,
        title: title,
        description: description,
        images: images,
        date: date);
    try {
      await Amplify.DataStore.save(newPet);
      return newPet;
    } catch (e) {
      throw e;
    }
  }

  Future<Pet> updatePet(Pet updatedPet) async {
    try {
      await Amplify.DataStore.save(updatedPet);
      return updatedPet;
    } catch (e) {
      throw e;
    }
  }

  Future<void> deletePet(Pet petToDelete) async {
    try {
      await Amplify.DataStore.delete(petToDelete);
    } catch (e) {
      throw e;
    }
  }

  Stream observePets() {
    return Amplify.DataStore.observe(Pet.classType);
  }
}
