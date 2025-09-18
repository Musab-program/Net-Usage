import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxBool isDarkMode = false.obs;
  static const String _themeKey = 'isDarkMode';

  void onItemTapped(int index) {
    selectedIndex.value = index;
    // هنا يمكنك إضافة كود للتنقل بين الصفحات باستخدام Get.toNamed()
  }

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
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
}
