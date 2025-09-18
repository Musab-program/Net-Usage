import 'package:get/get.dart';
import '../../../data/local_storage/user_local_storage.dart';
import '../../../data/repositories/user_repository.dart';
import '../controllers/user_management_controller.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<UserController>(() => UserController(Get.find<UserRepository>()));
    Get.find()<UserLocalStorage>(() => UserLocalStorage());
    Get.lazyPut<UserRepository>(() => UserRepository(Get.find()));
    Get.lazyPut<UserManagementController>(() => UserManagementController(Get.find()));
        }
}