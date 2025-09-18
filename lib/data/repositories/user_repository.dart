import '../local_storage/user_local_storage.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserLocalStorage _userStorage;

  UserRepository(this._userStorage);

  Future<List<UserModel>> getUsers() async {
    return await _userStorage.getUsers();
  }

  Future<int> insertUser(UserModel user) async {
    return await _userStorage.insertUser(user);
  }

  Future<int> updateUser(UserModel user) async {
    return await _userStorage.updateUser(user);
  }

  Future<void> deleteUser(int id) async {
    await _userStorage.deleteUser(id);
  }
}