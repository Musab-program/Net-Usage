import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();

  var users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();

  }

  void loadUsers() async {
    final usersList = await _userRepo.getUsers();
    users.value = usersList;
  }

  Future<void> addUser(UserModel user) async {
    // 1. منع المستخدمين المكررين
    if (users.any((existingUser) => existingUser.name.toLowerCase() == user.name.toLowerCase())) {
      Get.snackbar('خطأ', 'المستخدم موجود بالفعل');
      return; // توقف عن تنفيذ الدالة
    }

    await _userRepo.insertUser(user);
    loadUsers();
    Get.back(); // 2. إغلاق مربع الحوار بعد الإضافة
    Get.snackbar('نجاح', 'تمت إضافة المستخدم بنجاح');
  }

  Future<void> updateUser(UserModel user) async {
    await _userRepo.updateUser(user);
    loadUsers();
    Get.back(); // 3. إغلاق مربع الحوار بعد التعديل
    Get.snackbar('نجاح', 'تم تعديل المستخدم بنجاح');
  }

  Future<void> deleteUser(int id) async {
    await _userRepo.deleteUser(id);
    users.removeWhere((user) => user.id == id);
  }
}