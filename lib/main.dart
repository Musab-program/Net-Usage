import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/routes/app_pages.dart';
import 'core/base_controllers/app_controller.dart';
import 'core/bindings/app_binding.dart';
import 'core/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppBindings().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();
    return GetMaterialApp(

      title: 'مدير الإنترنت',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: appController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialBinding: AppBindings(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
        );
  }
}