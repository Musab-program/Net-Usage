import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/user_controller.dart';
import 'package:net_uasge/data/models/user_model.dart';
import 'package:net_uasge/data/repositories/usage_repository.dart';

/// Controller for the Dashboard statistics.
///
/// Calculate and prepares data for visualization (Charts and Summary Cards).
class DashboardController extends GetxController {
  final UsageRepository _usageRepo = Get.find<UsageRepository>();
  final UserController _userController = Get.find<UserController>();

  var totalMonthlyUsage = 0.0.obs;
  var totalPayments = 0.0.obs;
  var totalRemainingBalance = 0.0.obs;
  var topUsers = <UserModel>[].obs;

  /// Formatted data for charts and lists.
  var usersUsageData = <Map<String, dynamic>>[].obs;
  var usersPaymentsData = <Map<String, dynamic>>[].obs;
  var usersBalanceData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  /// Fetches usage data and calculates dashboard statistics.
  ///
  /// Loads users and their usage records, then aggregates totals and
  /// prepares data structures for the UI.
  Future<void> fetchDashboardData() async {
    // 1. Load all data once
    await _userController.loadUsers();
    final allUsage = await _usageRepo.getAllUsageRecords();
    final allUsers = _userController.users;

    // 2. data processing in memory
    totalMonthlyUsage.value = allUsage
        .map((u) => u.weeklyUsage)
        .fold(0.0, (sum, usage) => sum + usage);

    totalPayments.value = allUsage
        .map((p) => p.amountPaid)
        .fold(0.0, (sum, amount) => sum + amount);

    totalRemainingBalance.value = allUsers
        .map((u) => u.remainingBalance.value)
        .fold(0.0, (sum, balance) => sum + balance);

    // Group usage by user to avoid repetitive DB calls
    final Map<int, List<dynamic>> usageByUser = {};
    for (var record in allUsage) {
      if (!usageByUser.containsKey(record.userId)) {
        usageByUser[record.userId] = [];
      }
      usageByUser[record.userId]!.add(record);
    }

    // 3. Process usage per user
    final List<Map<String, dynamic>> usageData = [];
    final List<Map<String, dynamic>> paymentData = [];
    final List<Map<String, dynamic>> balanceData = [];
    final List<Map<String, dynamic>> topUsersList = [];

    for (var user in allUsers) {
      final userRecords = usageByUser[user.id] ?? [];

      // Calculate Usage
      final userTotalUsage = userRecords
          .map((e) => e.weeklyUsage as double)
          .fold(0.0, (sum, val) => sum + val);

      // Calculate Payments
      final userTotalPayment = userRecords
          .map((e) => e.amountPaid as double)
          .fold(0.0, (sum, val) => sum + val);

      // Add to lists
      usageData.add({'name': user.name, 'usage': userTotalUsage});

      if (userTotalPayment > 0) {
        paymentData.add({'name': user.name, 'payment': userTotalPayment});
      }

      if (user.remainingBalance.value != 0) {
        balanceData.add({
          'name': user.name,
          'balance': user.remainingBalance.value,
        });
      }

      topUsersList.add({'user': user, 'totalUsage': userTotalUsage});
    }

    // 4. Sort and Assignments

    // Usage Data
    usersUsageData.assignAll(
      usageData,
    ); // Order by original list order or sort if needed? Original code didn't sort usageData explicitly but it iterated users list.

    // Payment Data (Sort Descending)
    paymentData.sort(
      (a, b) => (b['payment'] as double).compareTo(a['payment'] as double),
    );
    usersPaymentsData.assignAll(paymentData);

    // Balance Data (Sort Descending)
    balanceData.sort(
      (a, b) => (b['balance'] as double).compareTo(a['balance'] as double),
    );
    usersBalanceData.assignAll(balanceData);

    // Top Users (Sort Descending by Usage)
    topUsersList.sort(
      (a, b) =>
          (b['totalUsage'] as double).compareTo(a['totalUsage'] as double),
    );
    topUsers.assignAll(
      topUsersList.map((e) => e['user'] as UserModel).take(5).toList(),
    );
  }
}
