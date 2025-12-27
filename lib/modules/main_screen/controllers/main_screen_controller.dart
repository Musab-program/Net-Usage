import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/app_controller.dart';

/// Controller for the Main Screen (Shell).
///
/// Manages bottom navigation state and page switching.
class MainScreenController extends GetxController {
  /// The current index of the selected tab.
  var selectedIndex = 0.obs;
  late PageController pageController;
  final AppController _appController = Get.find<AppController>();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: selectedIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Handles bottom navigation item taps.
  ///
  /// [index] The index of the tapped item.
  void onItemTapped(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    _appController.refreshAllData();
  }

  /// Validates index and refreshes data on page change.
  ///
  /// [index] The new page index.
  void onPageChanged(int index) {
    selectedIndex.value = index;
    _appController.refreshAllData();
  }
}
