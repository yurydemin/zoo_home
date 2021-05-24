import 'package:amplify_flutter/amplify.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class UserShelterRepository {
  Future<List<UserShelter>> getUserShelters() async {
    try {
      final userShelters = await Amplify.DataStore.query(
        UserShelter.classType,
      );
      return userShelters;
    } catch (e) {
      throw e;
    }
  }

  Future<UserShelter> getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        UserShelter.classType,
        where: UserShelter.ID.eq(userId),
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      throw e;
    }
  }

  Future<UserShelter> createUser({
    String userId,
    String email,
  }) async {
    final newUser = UserShelter(id: userId, email: email, images: []);
    try {
      await Amplify.DataStore.save(newUser);
      return newUser;
    } catch (e) {
      throw e;
    }
  }

  Future<UserShelter> updateUser(UserShelter updatedUser) async {
    try {
      await Amplify.DataStore.save(updatedUser);
      return updatedUser;
    } catch (e) {
      throw e;
    }
  }
}
