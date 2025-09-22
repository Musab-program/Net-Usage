import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/user_controller.dart';
import 'package:net_uasge/data/models/user_model.dart';
import 'package:net_uasge/core/base_controllers/app_controller.dart';

class UserManagementController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final AppController _appController = Get.find<AppController>();

  var users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      await _userController.loadUsers();
      final fetchedUsers = _userController.users;
      users.assignAll(fetchedUsers);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل المستخدمين: $e');
      print('$e');
    }
  }

  void addUser(UserModel user) async {
    try {
      await _userController.addUser(user);
      fetchUsers();
      _appController.refreshAllData();
      Get.back();
      Get.snackbar('نجاح', 'تمت إضافة المستخدم بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إضافة المستخدم: $e');
    }
  }

  void updateUser(UserModel user) async {
    try {
      await _userController.updateUser(user);
      fetchUsers();
      _appController.refreshAllData();
      Get.back();
      Get.snackbar('نجاح', 'تم تعديل المستخدم بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تعديل المستخدم: $e');
    }
  }

  void deleteUser(int id) async {
    try {
      await _userController.deleteUser(id);
      fetchUsers();
      _appController.refreshAllData();
      Get.snackbar('نجاح', 'تم حذف المستخدم بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حذف المستخدم: $e');
    }
  }
}