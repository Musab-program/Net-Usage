import 'package:get/get.dart';
import '../../data/local_storage/settings_local_storage.dart';
import '../../data/local_storage/usage_local_storage.dart';
import '../../data/local_storage/user_local_storage.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/usage_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../base_controllers/app_controller.dart';
import '../base_controllers/settings_controller.dart';
import '../base_controllers/user_controller.dart';
import '../services/database_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<DatabaseService>(DatabaseService());
    Get.put<AppController>(AppController());

    Get.lazyPut<UserLocalStorage>(() => UserLocalStorage());
    Get.lazyPut<UsageLocalStorage>(() => UsageLocalStorage());
    Get.lazyPut<SettingsLocalStorage>(() => SettingsLocalStorage());

    Get.lazyPut<UserRepository>(() => UserRepository(Get.find<UserLocalStorage>()));
    Get.lazyPut<UsageRepository>(() => UsageRepository(Get.find<UsageLocalStorage>()));
    Get.lazyPut<SettingsRepository>(() => SettingsRepository(Get.find<SettingsLocalStorage>()));


    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<UserController>(() => UserController());
  }
}