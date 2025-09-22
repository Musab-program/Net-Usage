import '../../core/services/database_service.dart';
import '../models/user_model.dart';

class UserLocalStorage {
  final DatabaseService _dbService = DatabaseService();

  Future<List<UserModel>> getUsers() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  Future<int> insertUser(UserModel user) async {
    final db = await _dbService.database;
    return await db.insert('users', user.toMap());
  }

  Future<int> updateUser(UserModel user) async {
    final db = await _dbService.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await _dbService.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> reconcileBalances(List<UserModel> users) async {
    final db = await _dbService.database;
    await db.transaction((txn) async {
      for (var user in users) {
        await txn.update(
          'users',
          {'remainingBalance': user.remainingBalance},
          where: 'id = ?',
          whereArgs: [user.id],
        );
      }
    });
  }

}