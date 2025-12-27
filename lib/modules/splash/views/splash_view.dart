import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/splash/controllers/splash_controller.dart';

/// View widget for the initial Splash screen.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController()); // Initialize controller

    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: SizedBox(
          width: Get.width * 0.8, // Increased size
          child: Image.asset(
            Get.isDarkMode
                ? 'assets/img/dark_splash.png'
                : 'assets/img/light_splash.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
