import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../base_controllers/app_controller.dart';
import '../constants/app_strings.dart';
import '../utils/nav_bar_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final navTheme = isDarkMode ? CustomGNavTheme.dark : CustomGNavTheme.light;

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: navTheme['rippleColor']!,
              hoverColor: navTheme['hoverColor']!,
              gap: 5,
              activeColor: navTheme['activeColor']!,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: navTheme['tabBackgroundColor']!,
              color: navTheme['iconColor']!,
              tabs: const [
                GButton(icon: Icons.home, text: AppStrings.homePageTitle),
                GButton(
                  icon: Icons.dashboard,
                  text: AppStrings.dashboardPageTitle,
                ),
                GButton(
                  icon: Icons.person,
                  text: AppStrings.userManagementPageTitle,
                ),
                GButton(
                  icon: Icons.calculate,
                  text: AppStrings.calculatorPageTitle,
                ),
              ],
              selectedIndex: controller.selectedIndex.value,
              onTabChange: controller.onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
