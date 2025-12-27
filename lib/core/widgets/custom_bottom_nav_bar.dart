import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:net_uasge/core/constants/app_strings.dart';
import 'package:net_uasge/core/utils/nav_bar_theme.dart';

/// A custom bottom navigation bar widget.
///
/// Uses [GNav] for the navigation bar styling and interaction.
class CustomBottomNavBar extends StatelessWidget {
  /// The index of the currently selected tab.
  final int selectedIndex;

  /// Callback function triggered when a tab is selected.
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
        color: isDarkMode
            ? const Color(0xFF1E1E1E)
            : Theme.of(context).cardColor,
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
