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

  Future<void> loadUsers() async {
     try {
       final usersList = await _userRepo.getUsers();
       users.assignAll(usersList);
     } catch (e) {
       Get.snackbar('خطأ', 'فشل في تحميل المستخدمين: $e');
     }
  }

  Future<void> addUser(UserModel user) async {
    if (users.any((existingUser) => existingUser.name.toLowerCase() == user.name.toLowerCase())) {
      Get.snackbar('خطأ', 'المستخدم موجود بالفعل');
      return;
    }
    if (user.name.isEmpty) {
      Get.snackbar('خطأ', 'يجب عليك إدخال اسم المستخدم');
      return;
    }

    await _userRepo.insertUser(user);
    await loadUsers();
    Get.back();
    Get.snackbar('نجاح', 'تمت إضافة المستخدم بنجاح');
  }

  Future<void> updateUser(UserModel user) async {
    await _userRepo.updateUser(user);
    await loadUsers();
    Get.back();
  }

  Future<void> deleteUser(int id) async {
    await _userRepo.deleteUser(id);
    users.removeWhere((user) => user.id == id);
    await loadUsers();
    Get.snackbar('نجاح', 'تم حذف المستخدم بنجاح');
  }
}