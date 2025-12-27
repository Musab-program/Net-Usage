import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/usage_controller.dart';
import 'package:net_uasge/core/base_controllers/user_controller.dart';
import 'package:net_uasge/modules/home/controllers/home_controller.dart';
import 'package:net_uasge/modules/main_screen/controllers/main_screen_controller.dart';
import 'package:net_uasge/modules/user_management/controllers/user_management_controller.dart';
import '../../calculator/controllers/calculator_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

/// Dependency binding for the Main Screen and all its sub-modules.
class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainScreenController>(() => MainScreenController());

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<UserManagementController>(() => UserManagementController());
    Get.lazyPut<CalculatorController>(() => CalculatorController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.find<UserController>();
    Get.find<UsageController>();
  }
}
