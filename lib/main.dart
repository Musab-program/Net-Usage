import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/base_controllers/app_controller.dart';
import 'core/bindings/app_binding.dart';
import 'core/utils/themes.dart';
import 'modules/calculator/controllers/calculator_controller.dart';
import 'modules/user_management/controllers/user_management_controller.dart';
import 'modules/user_management/views/user_management_view.dart';

void main() async {
  // يجب أن يتم التأكد من تهيئة Flutter قبل الوصول إلى الشغلات المحلية
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة جميع الخدمات الأساسية والمستودعات في AppBindings
  AppBindings().dependencies();

  // الحل: قم بإنشاء متحكم الحاسبة يدويًا هنا
  Get.lazyPut<CalculatorController>(() => CalculatorController());
  // Get.find()<UserManagementController>(() => UserManagementController());
  Get.lazyPut<UserManagementController>(() => UserManagementController(Get.find()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على مثيل AppController الذي تم حقنه في الذاكرة
    final AppController appController = Get.find();
    return GetMaterialApp(
      title: 'مدير الإنترنت',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      // استخدام reactive state لإدارة الثيم
      themeMode: appController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialBinding: AppBindings(),
      home: UserManagementPage(),
    );
  }
}