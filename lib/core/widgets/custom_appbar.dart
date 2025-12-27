import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base_controllers/app_controller.dart';

/// A custom app bar widget used across the application.
///
/// Implements [PreferredSizeWidget] to define its height.
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the app bar.
  final String pageName;
  const CustomAppbar({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();
    return AppBar(
      title: Text(pageName),
      leading: IconButton(
        onPressed: () {
          appController.showSettingsDialog();
        },
        icon: Icon(Icons.settings),
      ),
      actions: [
        IconButton(
          onPressed: () {
            appController.toggleTheme();
          },
          icon: Icon(Icons.brightness_4),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
