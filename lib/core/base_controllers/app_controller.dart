import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/home/controllers/home_controller.dart';
import '../../modules/user_management/controllers/user_management_controller.dart';
import '../widgets/settings_dialog.dart';

class AppController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxBool isDarkMode = false.obs;
  static const String _themeKey = 'isDarkMode';

  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
    _loadThemeMode();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_themeKey) ?? false;
  }

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  void showSettingsDialog() {
    Get.dialog(const SettingsDialog());
  }

  void refreshAllData() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadData();
    }
    if (Get.isRegistered<UserManagementController>()) {
      Get.find<UserManagementController>().fetchUsers();
    }
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().fetchDashboardData();


    }
  }
}
