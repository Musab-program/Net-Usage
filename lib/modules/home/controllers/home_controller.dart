import 'package:get/get.dart';
import 'dart:async';
import 'package:net_uasge/core/base_controllers/settings_controller.dart';
import 'package:net_uasge/core/base_controllers/user_controller.dart';
import 'package:net_uasge/data/models/user_model.dart';
import '../../../core/base_controllers/usage_controller.dart';

/// Controller for the Home screen logic.
///
/// Manages user data loading, data reconciliation, and FAB visibility.
class HomeController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final UsageController _usageController = Get.find<UsageController>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  /// List of users displayed on the home screen.
  var users = <UserModel>[].obs;

  /// The current price per gigabyte.
  var gigabytePrice = 0.0.obs;

  // FAB Visibility Logic
  // FAB Visibility Logic
  /// Observable to control the visibility of the Floating Action Button.
  RxBool isFabVisible = true.obs;
  Timer? _hideFabTimer;

  @override
  void onInit() {
    super.onInit();
    ever(_userController.users, (_) => users.assignAll(_userController.users));
    ever(
      _settingsController.gigabytePrice,
      (_) => gigabytePrice.value = _settingsController.gigabytePrice.value,
    );
    loadData();
    startHideTimer(); // Start timer on init
  }

  @override
  void onClose() {
    _hideFabTimer?.cancel();
    super.onClose();
  }

  /// Starts a timer to hide the FAB after 3 seconds of inactivity.
  void startHideTimer() {
    _hideFabTimer?.cancel();
    _hideFabTimer = Timer(const Duration(seconds: 3), () {
      isFabVisible.value = false;
    });
  }

  /// Resets the FAB visibility timer (called on scroll).
  void resetFabTimer() {
    isFabVisible.value = true;
    startHideTimer(); // Reset timer
  }

  /// Loads users and their usage records from the database.
  Future<void> loadData() async {
    await _userController.loadUsers();
    for (var user in users) {
      user.usageRecords = await _usageController.getUserUsageRecords(user.id!);
    }
    users.refresh();
  }

  /// Adds a weekly usage record for a user.
  ///
  /// [userId] The user's ID.
  /// [weeklyUsage] The usage amount in GB.
  /// [recordDate] The date label for the record.
  Future<void> addWeeklyUsage({
    required int userId,
    required double weeklyUsage,
    required String recordDate,
  }) async {
    await _usageController.addWeeklyUsage(
      userId: userId,
      weeklyUsage: weeklyUsage,
      recordDate: recordDate,
    );
    await loadData();
  }

  /// Adds a payment record for a user.
  ///
  /// [userId] The user's ID.
  /// [amountPaid] The amount paid.
  Future<void> addPayment({
    required int userId,
    required double amountPaid,
  }) async {
    await _usageController.addPayment(userId: userId, amountPaid: amountPaid);
    await loadData();
  }

  /// Reconciles balances for all users and clears usage records.
  ///
  /// Calculates total due, subtracts payments, updates remaining balance,
  /// and then clears individual usage records for the new cycle.
  Future<void> reconcileData() async {
    for (var user in users) {
      final totalUsage =
          user.usageRecords
              ?.map((e) => e.weeklyUsage)
              .fold(0.0, (sum, usage) => sum + usage) ??
          0.0;

      final totalAmountDue = totalUsage * gigabytePrice.value;

      final totalAmountPaid =
          user.usageRecords
              ?.map((e) => e.amountPaid)
              .fold(0.0, (sum, amount) => sum + amount) ??
          0.0;

      final finalBalance =
          (user.remainingBalance.value + totalAmountDue) - totalAmountPaid;

      user.remainingBalance.value = finalBalance;

      await _userController.updateUser(user);
    }
    await _usageController.clearAllUsageRecords();

    await loadData();

    Get.snackbar('نجاح', 'تم ترحيل البيانات بنجاح.');
  }
}
