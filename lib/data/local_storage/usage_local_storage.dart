import 'package:sqflite/sqflite.dart';

import '../../core/services/database_service.dart';
import '../models/usage_model.dart';

/// Local storage provider for usage records using SQLite.
class UsageLocalStorage {
  final DatabaseService _dbService = DatabaseService();

  /// Retrieves usage records for a specific user, ordered by date.
  ///
  /// [userId] The ID of the user.
  Future<List<UsageModel>> getUserUsage(int userId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usage',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'recordDate DESC',
    );
    return List.generate(maps.length, (i) => UsageModel.fromMap(maps[i]));
  }

  /// Inserts a new usage record into the database.
  Future<int> insertUsage(UsageModel usage) async {
    final db = await _dbService.database;
    return await db.insert('usage', usage.toMap());
  }

  /// Updates an existing usage record in the database.
  Future<int> updateUsage(UsageModel usage) async {
    final db = await _dbService.database;
    return await db.update(
      'usage',
      usage.toMap(),
      where: 'id = ?',
      whereArgs: [usage.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes all records from the usage table.
  Future<void> clearAllUsageRecords() async {
    final db = await _dbService.database;
    await db.delete('usage');
  }

  /// Retrieves all usage records from the database.
  Future<List<UsageModel>> getAllUsageRecords() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('usage');
    return List.generate(maps.length, (i) => UsageModel.fromMap(maps[i]));
  }
}
