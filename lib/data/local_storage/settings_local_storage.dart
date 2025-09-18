import '../../core/services/database_service.dart';
import '../models/settings_model.dart';


class SettingsLocalStorage {
  final DatabaseService _dbService = DatabaseService();

  Future<SettingsModel?> getSettings() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('settings');
    if (maps.isNotEmpty) {
      return SettingsModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateSettings(SettingsModel settings) async {
    final db = await _dbService.database;
    return await db.update(
      'settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}