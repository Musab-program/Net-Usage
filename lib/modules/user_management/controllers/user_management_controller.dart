import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/user_controller.dart';
import 'package:net_uasge/data/models/user_model.dart';
import 'package:net_uasge/core/base_controllers/app_controller.dart';

/// Controller for managing the list of users.
///
/// Handles fetching, sorting, adding, updating, and deleting users.
class UserManagementController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final AppController _appController = Get.find<AppController>();

  /// The list of users managed by the controller.
  var users = <UserModel>[].obs;

  /// The current criteria used for sorting users.
  var currentSortCriteria = SortCriteria.name.obs;

  /// Whether the sort order is ascending.
  var isAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// Fetches users from the repository and updates the list.
  void fetchUsers() async {
    try {
      await _userController.loadUsers();
      // users now automatically updated through ever() in onInit
      // but we sync it here too
      final fetchedUsers = _userController.users;

      // Update existing users
      for (var freshUser in fetchedUsers) {
        final existingUser = users.firstWhereOrNull(
          (u) => u.id == freshUser.id,
        );
        if (existingUser != null) {
          existingUser.remainingBalance.value =
              freshUser.remainingBalance.value;
        } else {
          users.add(freshUser);
        }
      }

      users.removeWhere((user) => !fetchedUsers.any((f) => f.id == user.id));
      sortUsers(); // Sort after fetching
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل المستخدمين: $e');
      print('$e');
    }
  }

  /// Sorts the user list based on current criteria.
  void sortUsers() {
    users.sort((a, b) {
      int compare;
      switch (currentSortCriteria.value) {
        case SortCriteria.name:
          compare = a.name.compareTo(b.name);
          break;
        case SortCriteria.balance:
          final balanceA = a.remainingBalance.value;
          final balanceB = b.remainingBalance.value;
          compare = balanceA.compareTo(balanceB);
          break;
        case SortCriteria.date:
          // Assuming higher ID means newer date
          compare = (a.id ?? 0).compareTo(b.id ?? 0);
          break;
      }
      return isAscending.value ? compare : -compare;
    });
    users.refresh();
  }

  /// Changes the sort criteria and direction.
  ///
  /// [criteria] The new sort criteria.
  /// [ascending] True for ascending, false for descending.
  void changeSort(SortCriteria criteria, bool ascending) {
    currentSortCriteria.value = criteria;
    isAscending.value = ascending;
    sortUsers();
  }

  /// Adds a new user.
  ///
  /// [user] The user model to add.
  void addUser(UserModel user) async {
    try {
      await _userController.addUser(user);
      fetchUsers();
      _appController.refreshAllData();
      Get.back();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إضافة المستخدم: $e');
    }
  }

  /// Updates an existing user.
  ///
  /// [user] The user model to update.
  void updateUser(UserModel user) async {
    try {
      await _userController.updateUser(user);
      fetchUsers();
      _appController.refreshAllData();
      Get.back();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تعديل المستخدم: $e');
    }
  }

  /// Deletes a user by ID.
  ///
  /// [id] The ID of the user to delete.
  void deleteUser(int id) async {
    try {
      await _userController.deleteUser(id);
      fetchUsers();
      _appController.refreshAllData();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في حذف المستخدم: $e');
    }
  }
}

/// Enum defining the criteria for sorting users.
enum SortCriteria { name, balance, date }
