import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../base_controllers/settings_controller.dart';
import 'custom_text.dart';
import 'custom_text_field.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();
    final TextEditingController priceController = TextEditingController(
      text: settingsController.gigabytePrice.value.toString(),
    );

    return AlertDialog(
      title: const CustomText(text: 'إعدادات'),
      content: CustomTextField(
        hintText: 'سعر الجيجا بايت',
        controllerText: priceController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const CustomText(text: 'إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final double newPrice =
                double.tryParse(priceController.text) ?? 0.0;
            if (newPrice > 0) {
              settingsController.updateGigabytePrice(newPrice);
              Get.back();
              Get.snackbar('نجاح', 'تم تحديث سعر الجيجا بايت بنجاح');
            } else {
              Get.snackbar('خطأ', 'الرجاء إدخال سعر صحيح.');
            }
          },
          child: const CustomText(text: 'حفظ'),
        ),
      ],
    );
  }
}
