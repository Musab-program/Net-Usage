import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/user_management/controllers/user_management_controller.dart';
import 'package:net_uasge/modules/user_management/views/user_form_dialog.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/custom_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart' as intl;

/// View widget for managing users (Add, Edit, Delete, Sort).
class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserManagementController controller = Get.find();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(const UserFormDialog());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Column(
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.sort_rounded,
                      color: Get.isDarkMode
                          ? Colors.white
                          : AppColors.primaryColor,
                    ),
                    onPressed: () {
                      _showSortDialog(context, controller);
                    },
                  ),
                ),
                const CustomText(
                  text: 'إدارة المستخدمين',
                  textFontSize: 24,
                  textFontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Avatar
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _getUserColor(
                                      user.name,
                                    ).withValues(alpha: 0.2),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 26,
                                  backgroundColor: _getUserColor(
                                    user.name,
                                  ).withValues(alpha: 0.1),
                                  child: Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _getUserColor(user.name),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: user.name,
                                      textFontSize: 18,
                                      textFontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(height: 8),
                                    Obx(() {
                                      final balance =
                                          user.remainingBalance.value;
                                      final balanceColor = _getBalanceColor(
                                        balance,
                                      );
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: balanceColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: balanceColor.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.account_balance_wallet,
                                              size: 14,
                                              color: balanceColor,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${balance.toStringAsFixed(2)} ريال',
                                              style: TextStyle(
                                                color: balanceColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 1,
                          color: Colors.grey.withValues(alpha: 0.1),
                        ),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  final date = intl.DateFormat(
                                    'yyyy/MM/dd – hh:mm a',
                                  ).format(DateTime.now());
                                  final message =
                                      '''
📊 *تقرير مدير الإنترنت*

👤 *المستخدم:* ${user.name}
💰 *الرصيد المتبقي:* ${user.remainingBalance.value.toStringAsFixed(2)} ريال

📅 *التاريخ:* $date

-------------------------
تم الإرسال عبر تطبيق مدير الإنترنت 🚀
''';
                                  // ignore: deprecated_member_use
                                  Share.share(message);
                                },
                                icon: const Icon(
                                  Icons.share_rounded,
                                  size: 20,
                                  color: AppColors.primaryColor,
                                ),
                                label: const CustomText(
                                  text: 'مشاركة',
                                  textFontSize: 13,
                                  textColor: AppColors.primaryColor,
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  Get.dialog(UserFormDialog(user: user));
                                },
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  size: 20,
                                  color: AppColors.accentColor,
                                ),
                                label: const CustomText(
                                  text: 'تعديل',
                                  textFontSize: 13,
                                  textColor: AppColors.accentColor,
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const CustomText(
                                        text: 'تأكيد الحذف',
                                      ),
                                      content: CustomText(
                                        text:
                                            'هل أنت متأكد من حذف ${user.name}؟',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const CustomText(
                                            text: 'إلغاء',
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.deleteUser(user.id!);
                                            Get.back();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.accentColor,
                                          ),
                                          child: const CustomText(text: 'حذف'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                label: const CustomText(
                                  text: 'حذف',
                                  textFontSize: 13,
                                  textColor: Colors.red,
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(
    BuildContext context,
    UserManagementController controller,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: 'ترتيب حسب',
              textFontSize: 18,
              textFontWeight: FontWeight.bold,
              textColor: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 16),
            _buildSortOption(
              context,
              controller,
              'الاسم',
              SortCriteria.name,
              Icons.sort_by_alpha,
              Colors.blue,
            ),
            _buildSortOption(
              context,
              controller,
              'الرصيد المتبقي',
              SortCriteria.balance,
              Icons.account_balance_wallet,
              Colors.green,
            ),
            _buildSortOption(
              context,
              controller,
              'تاريخ التسجيل',
              SortCriteria.date,
              Icons.date_range,
              Colors.orange,
            ),
            Divider(
              color: Get.isDarkMode ? Colors.grey[700] : Colors.grey[300],
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'اتجاه الترتيب',
              textFontSize: 16,
              textFontWeight: FontWeight.bold,
              textColor: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('تصاعدي'),
                    selected: controller.isAscending.value,
                    selectedColor: AppColors.primaryColor,
                    labelStyle: TextStyle(
                      color: controller.isAscending.value
                          ? Colors.white
                          : (Get.isDarkMode ? Colors.white : Colors.black),
                    ),
                    backgroundColor: Get.isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    onSelected: (bool selected) {
                      controller.changeSort(
                        controller.currentSortCriteria.value,
                        true,
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('تنازلي'),
                    selected: !controller.isAscending.value,
                    selectedColor: AppColors.primaryColor,
                    labelStyle: TextStyle(
                      color: !controller.isAscending.value
                          ? Colors.white
                          : (Get.isDarkMode ? Colors.white : Colors.black),
                    ),
                    backgroundColor: Get.isDarkMode
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    onSelected: (bool selected) {
                      controller.changeSort(
                        controller.currentSortCriteria.value,
                        false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    UserManagementController controller,
    String title,
    SortCriteria criteria,
    IconData icon,
    Color iconColor,
  ) {
    return Obx(() {
      final isSelected = controller.currentSortCriteria.value == criteria;
      final textColor = isSelected
          ? AppColors.primaryColor
          : (Get.isDarkMode ? Colors.white70 : Colors.black87);

      return ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: CustomText(
          text: title,
          textColor: textColor,
          textFontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        trailing: isSelected
            ? const Icon(Icons.check, color: AppColors.primaryColor)
            : null,
        onTap: () {
          controller.changeSort(criteria, controller.isAscending.value);
        },
      );
    });
  }

  Color _getUserColor(String name) {
    if (name.isEmpty) return AppColors.primaryColor;
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.brown,
      Colors.cyan,
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  Color _getBalanceColor(double balance) {
    if (balance <= 500) return Colors.green;
    if (balance <= 1500) return Colors.orange;
    return Colors.red;
  }
}
