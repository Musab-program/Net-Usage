import 'package:get/get.dart';
import '../../data/models/settings_model.dart';
import '../../data/repositories/settings_repository.dart';

class SettingsController extends GetxController {
  final SettingsRepository _settingsRepo = Get.find<SettingsRepository>();

  var gigabytePrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadGigabytePrice();
  }

  void _loadGigabytePrice() async {
    final settingsModel = await _settingsRepo.getSettings();
    if (settingsModel != null) {
      gigabytePrice.value = settingsModel.gigabytePrice;
    } else {
      await updateGigabytePrice(100.0);
    }
  }

  Future<void> updateGigabytePrice(double newPrice) async {
    final settingsModel = SettingsModel(gigabytePrice: newPrice);
    await _settingsRepo.updateSettings(settingsModel);
    gigabytePrice.value = newPrice;
  }
}