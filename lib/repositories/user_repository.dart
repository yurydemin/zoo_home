import 'package:amplify_flutter/amplify.dart';
import 'package:zoo_home/models/ModelProvider.dart';

class UserRepository {
  Future<User> getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      throw e;
    }
  }

  Future<User> createUser({
    String userId,
    String email,
  }) async {
    final newUser = User(id: userId, email: email);
    try {
      await Amplify.DataStore.save(newUser);
      return newUser;
    } catch (e) {
      throw e;
    }
  }
}
