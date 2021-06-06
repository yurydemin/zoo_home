import 'package:amplify_flutter/amplify.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class SheltersRepository {
  Future<List<Shelter>> getShelters() async {
    try {
      final shelters = await Amplify.DataStore.query(
        Shelter.classType,
      );
      return shelters;
    } catch (e) {
      throw e;
    }
  }

  Future<Shelter> updateShelter(Shelter updatedShelter) async {
    try {
      await Amplify.DataStore.save(updatedShelter);
      return updatedShelter;
    } catch (e) {
      throw e;
    }
  }

  Stream observeShelters() {
    return Amplify.DataStore.observe(Shelter.classType);
  }

  Future<String> createEmptyShelter(String contact, String userID) async {
    final emptyShelter = Shelter(
        contact: contact, userID: userID, imageKeys: <String>[], pets: <Pet>[]);
    try {
      await Amplify.DataStore.save(emptyShelter);
      return emptyShelter.id;
    } catch (e) {
      throw (e);
    }
  }
}
