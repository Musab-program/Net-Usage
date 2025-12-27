import '../../core/services/database_service.dart';
import '../models/user_model.dart';

/// Local storage provider for user data using SQLite.
class UserLocalStorage {
  final DatabaseService _dbService = DatabaseService();

  /// Retrieves all users from the database.
  Future<List<UserModel>> getUsers() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  /// Inserts a new user into the database.
  Future<int> insertUser(UserModel user) async {
    final db = await _dbService.database;
    return await db.insert('users', user.toMap());
  }

  /// Updates an existing user's details in the database.
  Future<int> updateUser(UserModel user) async {
    final db = await _dbService.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Deletes a user from the database by ID.
  Future<void> deleteUser(int id) async {
    final db = await _dbService.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  /// Updates the remaining balance for a list of users in a transaction.
  ///
  /// [users] The list of users with updated balances.
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
