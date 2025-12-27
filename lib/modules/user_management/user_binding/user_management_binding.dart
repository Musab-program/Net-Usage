import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';

/// Dependency binding for the User Management module.
class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(() => UserManagementController());
  }
}
