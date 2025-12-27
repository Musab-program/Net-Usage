import 'package:get/get.dart';
import 'package:net_uasge/data/models/settings_model.dart';
import 'package:net_uasge/data/repositories/settings_repository.dart';

/// Controller for managing application settings.
///
/// Handles operations related to settings configuration, such as setting the gigabyte price.
class SettingsController extends GetxController {
  final SettingsRepository _settingsRepo = Get.find<SettingsRepository>();

  /// The price per gigabyte.
  var gigabytePrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadGigabytePrice();
  }

  void _loadGigabytePrice() async {
    try {
      await _settingsRepo.initializeSettings();
      final settingsModel = await _settingsRepo.getSettings();
      if (settingsModel != null) {
        gigabytePrice.value = settingsModel.gigabytePrice;
      } else {
        final defaultSettings = SettingsModel(gigabytePrice: 200.0);
        await _settingsRepo.updateSettings(defaultSettings);
        gigabytePrice.value = defaultSettings.gigabytePrice;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الإعدادات: $e');
    }
  }

  /// Updates the price per gigabyte in the settings.
  ///
  /// [newPrice] is the new price to be set.
  /// Updates the local storage and the observable value.
  Future<void> updateGigabytePrice(double newPrice) async {
    try {
      final currentSettings = await _settingsRepo.getSettings();
      final updatedSettings = SettingsModel(
        id: currentSettings!.id,
        gigabytePrice: newPrice,
      );
      await _settingsRepo.updateSettings(updatedSettings);
      gigabytePrice.value = newPrice;
      Get.snackbar('نجاح', 'تم تحديث السعر بنجاح.');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث السعر: $e');
    }
  }
}
