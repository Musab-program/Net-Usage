import '../local_storage/settings_local_storage.dart';
import '../models/settings_model.dart';

class SettingsRepository {
  final SettingsLocalStorage _settingsStorage;

  SettingsRepository(this._settingsStorage);

  Future<SettingsModel?> getSettings() async {
    return await _settingsStorage.getSettings();
  }

  Future<int> updateSettings(SettingsModel settings) async {
    return await _settingsStorage.updateSettings(settings);
  }
}