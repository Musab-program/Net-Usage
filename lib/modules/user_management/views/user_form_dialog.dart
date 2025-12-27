import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/user_management/controllers/user_management_controller.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/models/user_model.dart';

/// Dialog widget for adding or editing a user.
class UserFormDialog extends StatelessWidget {
  /// The user to edit (null if adding a new user).
  final UserModel? user;

  const UserFormDialog({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final UserManagementController controller = Get.find();
    final isEditing = user != null;
    final TextEditingController nameController = TextEditingController(
      text: isEditing ? user!.name : '',
    );
    final TextEditingController remainingBalanceController =
        TextEditingController(
          text: isEditing ? user!.remainingBalance.toString() : '',
        );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isEditing ? Icons.edit : Icons.person_add,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomText(
                    text: isEditing ? 'تعديل مستخدم' : 'إضافة مستخدم جديد',
                    textFontSize: 18,
                    textFontWeight: FontWeight.bold,
                    textColor: AppColors.primaryColor,
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'اسم المستخدم',
                    controllerText: nameController,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'الرصيد المتبقي (ريال)',
                    controllerText: remainingBalanceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const CustomText(
                            text: 'إلغاء',
                            textColor: Colors.grey,
                            textFontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (isEditing) {
                              final updatedUser = UserModel(
                                id: user!.id,
                                name: nameController.text,
                                remainingBalance:
                                    double.tryParse(
                                      remainingBalanceController.text,
                                    ) ??
                                    0.0,
                              );
                              controller.updateUser(updatedUser);
                            } else {
                              final newUser = UserModel(
                                id: null,
                                name: nameController.text,
                                remainingBalance:
                                    double.tryParse(
                                      remainingBalanceController.text,
                                    ) ??
                                    0.0,
                              );
                              controller.addUser(newUser);
                            }
                          },
                          icon: Icon(
                            isEditing ? Icons.save : Icons.add,
                            color: Colors.white,
                          ),
                          label: CustomText(
                            text: isEditing ? 'حفظ التعديلات' : 'إضافة',
                            textColor: Colors.white,
                            textFontWeight: FontWeight.bold,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
