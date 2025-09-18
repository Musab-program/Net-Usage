import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base_controllers/app_controller.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String pageName;
  const CustomAppbar({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();
    return AppBar(
      title: Text(pageName),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.settings),
        //   onPressed: () {
        //
        //   },
        // ),
        IconButton(onPressed: (){
          appController.toggleTheme();
        }, icon: Icon(Icons.brightness_4))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
