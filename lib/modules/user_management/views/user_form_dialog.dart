import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base_controllers/user_controller.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/models/user_model.dart';

class UserFormDialog extends StatelessWidget {
  final UserModel? user;

  const UserFormDialog({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.find();
    final isEditing = user != null;
    final TextEditingController nameController =
    TextEditingController(text: isEditing ? user!.name : '');
    final TextEditingController remainingBalanceController =
    TextEditingController(text: isEditing ? user!.remainingBalance.toString() : '');

    return AlertDialog(
      title: CustomText(text: isEditing ? 'تعديل مستخدم' : 'إضافة مستخدم جديد'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            hintText: 'الاسم',
            controllerText: nameController,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hintText: 'الرصيد المتبقي',
            controllerText: remainingBalanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const CustomText(text: 'إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (isEditing) {
              final updatedUser = UserModel(
                id: user!.id,
                name: nameController.text,
                remainingBalance: double.tryParse(remainingBalanceController.text) ?? 0.0,
              );
              controller.updateUser(updatedUser);
            } else {
              final newUser = UserModel(
                id: null,
                name: nameController.text,
                remainingBalance: double.tryParse(remainingBalanceController.text) ?? 0.0,
              );
              controller.addUser(newUser);
            }
          },
          child: CustomText(text: isEditing ? 'تعديل' : 'إضافة'),
        ),
      ],
    );
  }
}