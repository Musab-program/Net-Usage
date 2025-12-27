import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/core/base_controllers/settings_controller.dart';
import '../constants/app_color.dart';

import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';

/// A dialog widget for updating application settings.
///
/// Allows the user to change the gigabyte price.
class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController =
        Get.find<SettingsController>();
    final TextEditingController priceController = TextEditingController(
      text: settingsController.gigabytePrice.value.toString(),
    );
    const primaryColor = AppColors.darkPrimaryColor;

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
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.settings, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  const CustomText(
                    text: 'تعديل الإعدادات',
                    textFontSize: 18,
                    textFontWeight: FontWeight.bold,
                    textColor: primaryColor,
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
                    hintText: 'سعر الجيجا بايت (ريال)',
                    controllerText: priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: const Icon(
                      Icons.local_offer_outlined,
                      color: primaryColor,
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
                            final double newPrice =
                                double.tryParse(priceController.text) ?? 0.0;
                            if (newPrice > 0) {
                              settingsController.updateGigabytePrice(newPrice);
                              Get.back();
                            } else {
                              Get.snackbar(
                                'خطأ',
                                'الرجاء إدخال سعر صحيح.',
                                backgroundColor: Colors.red.withValues(
                                  alpha: 0.1,
                                ),
                                colorText: Colors.red,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.save_rounded,
                            color: Colors.white,
                          ),
                          label: const CustomText(
                            text: 'حفظ',
                            textColor: Colors.white,
                            textFontWeight: FontWeight.bold,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
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
