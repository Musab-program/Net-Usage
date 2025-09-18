import 'package:get/get.dart';
import 'package:net_uasge/data/models/user_model.dart';
import 'package:net_uasge/data/repositories/user_repository.dart';

class UserManagementController extends GetxController {
  final UserRepository _userRepository;
  var users = <UserModel>[].obs;

  UserManagementController(this._userRepository);

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() async {
    try {
      final fetchedUsers = await _userRepository.getUsers();
      users.assignAll(fetchedUsers);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل المستخدمين: $e');
    }
  }

  void addUser(UserModel user) async {
    try {
      await _userRepository.insertUser(user);
      fetchUsers();
      Get.back();
      Get.snackbar('نجاح', 'تمت إضافة المستخدم بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إضافة المستخدم: $e');
    }
  }

  void updateUser(UserModel user) async {
    try {
      await _userRepository.updateUser(user);
      fetchUsers();
      Get.back();
      Get.snackbar('نجاح', 'تم تعديل المستخدم بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تعديل المستخدم: $e');
    }
  }

  void deleteUser(int id) async {
    try {
      await _userRepository.deleteUser(id);
      fetchUsers();
      Get.snackbar('نجاح', 'تم حذف المستخدم بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حذف المستخدم: $e');
    }
  }
}