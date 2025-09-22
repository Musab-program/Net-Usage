import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/user_controller.dart';
import 'package:net_uasge/data/models/user_model.dart';
import 'package:net_uasge/data/repositories/usage_repository.dart';
import 'package:net_uasge/data/repositories/user_repository.dart';

class DashboardController extends GetxController {
  final UsageRepository _usageRepo = Get.find<UsageRepository>();
  final UserRepository _userRepo = Get.find<UserRepository>();
  final UserController _userController = Get.find<UserController>();

  var totalMonthlyUsage = 0.0.obs;
  var totalPayments = 0.0.obs;
  var totalRemainingBalance = 0.0.obs;
  var topUsers = <UserModel>[].obs;
  var usersUsageData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    await Future.wait([
      _fetchTotalMonthlyUsage(),
      _fetchTotalPayments(),
      _fetchTotalRemainingBalance(),
      _fetchTopUsers(),
      _fetchUsersUsageData(),
    ]);
  }

  Future<void> _fetchTotalMonthlyUsage() async {
    final allUsage = await _usageRepo.getAllUsageRecords();
    totalMonthlyUsage.value = allUsage.map((u) => u.weeklyUsage).fold(0.0, (sum, usage) => sum + usage);
  }

  Future<void> _fetchTotalPayments() async {
    final allUsage = await _usageRepo.getAllUsageRecords();
    totalPayments.value = allUsage.map((p) => p.amountPaid).fold(0.0, (sum, amount) => sum + amount);
  }

  Future<void> _fetchTotalRemainingBalance() async {
    await _userController.loadUsers();
    final allUsers = _userController.users;
    totalRemainingBalance.value =
        allUsers.map((u) => u.remainingBalance.value).fold(0.0, (sum, balance) => sum + balance);
  }

  Future<void> _fetchTopUsers() async {
    await _userController.loadUsers();
    final allUsers =_userController.users;
    final List<Map<String, dynamic>> usersWithTotalUsage = [];

    for (var user in allUsers) {
      final usage = await _usageRepo.getUserUsage(user.id!);
      final total = usage.map((e) => e.weeklyUsage).fold(0.0, (sum, usage) => sum + usage);
      usersWithTotalUsage.add({'user': user, 'totalUsage': total});
    }
    usersWithTotalUsage.sort((a, b) {
      final totalA = a['totalUsage'] as double;
      final totalB = b['totalUsage'] as double;
      return totalB.compareTo(totalA);
    });
    topUsers.assignAll(usersWithTotalUsage.map((e) => e['user'] as UserModel).take(5).toList());
  }

  Future<void> _fetchUsersUsageData() async {
    await _userController.loadUsers();
    final allUsers =_userController.users;
    final List<Map<String, dynamic>> data = [];
    for (var user in allUsers) {
      final usage = await _usageRepo.getUserUsage(user.id!);
      final total = usage.map((e) => e.weeklyUsage).fold(0.0, (sum, usage) => sum + usage);
      data.add({'name': user.name, 'usage': total});
    }
    usersUsageData.assignAll(data);
  }
}