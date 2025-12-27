import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/home/controllers/home_controller.dart';
import '../../modules/user_management/controllers/user_management_controller.dart';
import '../widgets/settings_dialog.dart';

/// Controller responsible for managing global application state,
/// including theme toggling, bottom navigation, and data refreshing.
class AppController extends GetxController {
  /// The current index of the bottom navigation bar.
  RxInt selectedIndex = 0.obs;

  /// Observable boolean indicating if dark mode is enabled.
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

  /// Handles tapping on a bottom navigation item.
  ///
  /// [index] is the index of the tapped item.
  /// Animates the page view to the selected index.
  void onItemTapped(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  /// Updates the selected index when the page changes via swipe.
  ///
  /// [index] is the new page index.
  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_themeKey) ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Toggles the application theme between light and dark modes.
  ///
  /// Persists the selection using [SharedPreferences].
  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  /// Displays the settings dialog.
  void showSettingsDialog() {
    Get.dialog(const SettingsDialog());
  }

  /// Refreshes data across all registered controllers.
  ///
  /// Invokes data fetching methods in [HomeController], [UserManagementController],
  /// and [DashboardController] if they are currently registered in memory.
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
