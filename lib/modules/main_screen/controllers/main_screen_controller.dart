import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/app_controller.dart';

class MainScreenController extends GetxController {
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

  void onItemTapped(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    _appController.refreshAllData();
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
    _appController.refreshAllData();
  }
}