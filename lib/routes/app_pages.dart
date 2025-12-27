import 'package:get/get.dart';
import 'package:net_uasge/modules/calculator/calculator_binding/controller_binding.dart';
import 'package:net_uasge/modules/calculator/views/calculator_view.dart';
import 'package:net_uasge/modules/dashboard/views/dashboard_view.dart';
import 'package:net_uasge/modules/splash/views/splash_view.dart';
import '../modules/dashboard/dashboard_binding/dashboard_binding.dart';
import '../modules/main_screen/main_binding/main_binding.dart';
import '../modules/main_screen/views/main_screen.dart';
import '../modules/user_management/user_binding/user_management_binding.dart';
import '../modules/user_management/views/user_management_view.dart';

part 'app_routes.dart';

/// Manages the application's pages and their routing configurations.
class AppPages {
  AppPages._();

  /// The initial route of the application.
  static const INITIAL = Routes.SPLASH;

  /// List of all available GetX pages and their bindings.
  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashView()),
    GetPage(
      name: Routes.HOME,
      page: () => const MainScreen(),
      binding: MainScreenBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.USERS,
      page: () => const UserManagementPage(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: Routes.CALCULATOR,
      page: () => const CalculatorPage(),
      binding: CalculatorBinding(),
    ),
  ];
}
