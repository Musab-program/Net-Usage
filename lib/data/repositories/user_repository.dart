import '../local_storage/user_local_storage.dart';
import '../models/user_model.dart';

/// Repository for managing user data.
class UserRepository {
  final UserLocalStorage _userStorage;

  UserRepository(this._userStorage);

  /// Retrieves all users.
  Future<List<UserModel>> getUsers() async {
    return await _userStorage.getUsers();
  }

  /// Inserts a new user.
  ///
  /// [user] The user model to insert.
  Future<int> insertUser(UserModel user) async {
    return await _userStorage.insertUser(user);
  }

  /// Updates an existing user.
  ///
  /// [user] The user model to update.
  Future<int> updateUser(UserModel user) async {
    return await _userStorage.updateUser(user);
  }

  /// Deletes a user by ID.
  ///
  /// [id] The ID of the user to delete.
  Future<void> deleteUser(int id) async {
    await _userStorage.deleteUser(id);
  }

  /// Updates remaining balances for multiple users in a batch.
  ///
  /// [users] The list of users with updated balances.
  Future<void> reconcileBalances(List<UserModel> users) async {
    await _userStorage.reconcileBalances(users);
  }
}
