import 'package:get/get.dart';
import 'package:net_uasge/data/models/settings_model.dart';
import 'package:net_uasge/data/repositories/settings_repository.dart';

class SettingsController extends GetxController {
  final SettingsRepository _settingsRepo = Get.find<SettingsRepository>();

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