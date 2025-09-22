
import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/settings_controller.dart';
import 'package:net_uasge/core/base_controllers/user_controller.dart';
import 'package:net_uasge/data/models/user_model.dart';
import '../../../core/base_controllers/usage_controller.dart';

class HomeController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final UsageController _usageController = Get.find<UsageController>();
  final SettingsController _settingsController = Get.find<SettingsController>();

  var users = <UserModel>[].obs;
  var gigabytePrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_userController.users, (_) => users.assignAll(_userController.users));
    ever(_settingsController.gigabytePrice,
            (_) => gigabytePrice.value = _settingsController.gigabytePrice.value);
    loadData();
  }

  Future<void> loadData() async {
    await _userController.loadUsers();
    for (var user in users) {
      user.usageRecords = await _usageController.getUserUsageRecords(user.id!);
    }
  }

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
    Get.snackbar('نجاح', 'تمت إضافة الاستخدام بنجاح.');
  }

  Future<void> addPayment({
    required int userId,
    required double amountPaid,
  }) async {
    await _usageController.addPayment(
      userId: userId,
      amountPaid: amountPaid,
    );
    await loadData();
    Get.snackbar('نجاح', 'تمت إضافة الدفعة بنجاح.');
  }

  Future<void> reconcileData() async {
    for (var user in users) {
      final totalUsage = user.usageRecords
          ?.map((e) => e.weeklyUsage)
          .fold(0.0, (sum, usage) => sum + usage) ??
          0.0;

      final totalAmountDue = totalUsage * gigabytePrice.value;

      final totalAmountPaid = user.usageRecords
          ?.map((e) => e.amountPaid)
          .fold(0.0, (sum, amount) => sum + amount) ??
          0.0;

      final finalBalance =
          (user.remainingBalance.value + totalAmountDue) - totalAmountPaid;

      user.remainingBalance.value = finalBalance;

      await _userController.updateUser(user);
    }
    await _usageController.clearAllUsageRecords();

    loadData();

    Get.snackbar('نجاح', 'تم ترحيل البيانات بنجاح.');
  }
}