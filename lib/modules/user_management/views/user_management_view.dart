import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/user_management/views/user_form_dialog.dart';
import '../../../core/base_controllers/user_controller.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/widgets/custom_text.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find();

    return Scaffold(
      appBar: const CustomAppbar(pageName: 'إدارة المستخدمين'),

      // زر العمل العائم
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const UserFormDialog());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // شريط التنقل السفلي
      bottomNavigationBar: CustomBottomNavBar(

      ),

      body: Obx(
            () {
          if (controller.users.isEmpty) {
            return const Center(
              child: CustomText(
                text: 'لا يوجد مستخدمين حاليًا.',
                textFontSize: 18,
                textColor: AppColors.secondaryText,
              ),
            );
          }
          return ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.darkPrimaryColor,
                    child: Icon(Icons.person, color: AppColors.textIcons),
                  ),
                  title: CustomText(text: user.name),
                  subtitle: CustomText(text: 'الرصيد المتبقي: ${user.remainingBalance}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.darkPrimaryColor),
                        onPressed: () {
                          Get.dialog(UserFormDialog(user: user));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.accentColor),
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              title: const CustomText(text: 'تأكيد الحذف'),
                              content: CustomText(text: 'هل أنت متأكد من حذف ${user.name}؟'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const CustomText(text: 'إلغاء'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.deleteUser(user.id!);
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentColor),
                                  child: const CustomText(text: 'حذف'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}