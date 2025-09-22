import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/home/controllers/home_controller.dart';

import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';

class UsageDialog extends StatelessWidget {
  final int userId;
  final int week;

  const UsageDialog({super.key, required this.userId, required this.week});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final TextEditingController usageController = TextEditingController();

    return AlertDialog(
      title: CustomText(text: 'إدخال استخدام الأسبوع $week'),
      content: CustomTextField(
        hintText: 'الاستخدام بالجيجا بايت',
        controllerText: usageController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const CustomText(text: 'إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final double usage = double.tryParse(usageController.text) ?? 0.0;
            if (usage > 0) {
              controller.addWeeklyUsage(
                userId: userId,
                weeklyUsage: usage,
                recordDate: 'الأسبوع $week',
              );
              Get.back();
            } else {
              Get.snackbar('خطأ', 'الرجاء إدخال قيمة صحيحة.');
            }
          },
          child: const CustomText(text: 'إضافة'),
        ),
      ],
    );
  }
}