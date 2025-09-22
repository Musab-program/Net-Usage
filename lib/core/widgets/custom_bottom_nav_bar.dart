import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:net_uasge/core/constants/app_strings.dart';
import 'package:net_uasge/core/utils/nav_bar_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final navTheme = isDarkMode ? CustomGNavTheme.dark : CustomGNavTheme.light;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black),
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
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}