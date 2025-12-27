import '../local_storage/settings_local_storage.dart';
import '../models/settings_model.dart';

/// Repository for managing application settings data.
class SettingsRepository {
  final SettingsLocalStorage _settingsStorage;

  SettingsRepository(this._settingsStorage);

  /// Retrieves the current settings.
  Future<SettingsModel?> getSettings() async {
    return await _settingsStorage.getSettings();
  }

  /// Updates the application settings.
  ///
  /// [settings] The settings model to update.
  Future<int> updateSettings(SettingsModel settings) async {
    return await _settingsStorage.updateSettings(settings);
  }

  /// Initializes default settings if they don't exist.
  Future<void> initializeSettings() async {
    await _settingsStorage.initializeSettings();
  }
}
