import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

/// Controller for managing user data.
///
/// Handles adding, updating, deleting, and retrieving users.
class UserController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();

  /// List of registered users.
  var users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  /// Loads users from the local storage.
  ///
  /// Syncs the local [users] list with data from the repository.
  /// Updates existing user objects to preserve observable references where possible.
  Future<void> loadUsers() async {
    try {
      final usersList = await _userRepo.getUsers();

      // Update existing users instead of replacing them
      for (var freshUser in usersList) {
        final existingUser = users.firstWhereOrNull(
          (u) => u.id == freshUser.id,
        );
        if (existingUser != null) {
          // Update value in the existing object to preserve .obs reference
          existingUser.remainingBalance.value =
              freshUser.remainingBalance.value;
        } else {
          // New user, add it
          users.add(freshUser);
        }
      }

      // Remove users that no longer exist in database
      users.removeWhere((user) => !usersList.any((f) => f.id == user.id));
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل المستخدمين: $e');
    }
  }

  /// Adds a new user to the system.
  ///
  /// Checks if a user with the same name already exists before adding.
  ///
  /// [user] The [UserModel] to add.
  Future<void> addUser(UserModel user) async {
    if (users.any(
      (existingUser) =>
          existingUser.name.toLowerCase() == user.name.toLowerCase(),
    )) {
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
  }

  /// Updates an existing user's details.
  ///
  /// [user] The [UserModel] with updated data.
  Future<void> updateUser(UserModel user) async {
    await _userRepo.updateUser(user);
    await loadUsers();
    Get.back();
  }

  /// Deletes a user from the system.
  ///
  /// [id] The unique ID of the user to delete.
  Future<void> deleteUser(int id) async {
    await _userRepo.deleteUser(id);
    users.removeWhere((user) => user.id == id);
    await loadUsers();
  }
}
