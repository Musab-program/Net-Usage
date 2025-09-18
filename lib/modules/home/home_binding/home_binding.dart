import 'package:get/get.dart';
import '../../../core/base_controllers/usage_controller.dart';
import '../../../core/base_controllers/user_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<UserController>(() => UserController(Get.find<UserRepository>()));
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<UsageController>(() => UsageController());

  }
}