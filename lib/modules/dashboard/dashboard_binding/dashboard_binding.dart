import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

/// Dependency binding for the Dashboard module.
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
