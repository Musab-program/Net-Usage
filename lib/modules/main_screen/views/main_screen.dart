import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/core/widgets/custom_appbar.dart';
import 'package:net_uasge/core/widgets/custom_bottom_nav_bar.dart';
import 'package:net_uasge/modules/calculator/views/calculator_view.dart';
import 'package:net_uasge/modules/dashboard/views/dashboard_view.dart';
import 'package:net_uasge/modules/home/views/home_page.dart';
import 'package:net_uasge/modules/user_management/views/user_management_view.dart';
import 'package:net_uasge/modules/main_screen/controllers/main_screen_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainScreenController mainController = Get.find<MainScreenController>();

    return Scaffold(
      appBar: CustomAppbar(pageName: 'مدير الإنترنت '),
      body: PageView(
        controller: mainController.pageController,
        onPageChanged: mainController.onPageChanged,
        children: const [
          HomePage(),
          DashboardPage(),
          UserManagementPage(),
          CalculatorPage(),
        ],
      ),
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          selectedIndex: mainController.selectedIndex.value,
          onTabChange: mainController.onItemTapped,
        ),

      ),
    );
  }
}