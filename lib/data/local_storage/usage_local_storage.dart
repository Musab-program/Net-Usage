import '../../core/services/database_service.dart';
import '../models/usage_model.dart';

class UsageLocalStorage {
  final DatabaseService _dbService = DatabaseService();

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

  Future<int> insertUsage(UsageModel usage) async {
    final db = await _dbService.database;
    return await db.insert('usage', usage.toMap());
  }

  Future<int> updateUsage(UsageModel usage) async {
    final db = await _dbService.database;
    return await db.update(
      'usage',
      usage.toMap(),
      where: 'id = ?',
      whereArgs: [usage.id],
    );
  }
}