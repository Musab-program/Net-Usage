import 'package:get/get.dart';
import 'package:net_uasge/routes/app_pages.dart';

/// Controller class for the Splash screen.
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  /// Navigates to the Home screen after a delay.
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(Routes.HOME);
  }
}
