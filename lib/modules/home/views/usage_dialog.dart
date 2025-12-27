import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/home/controllers/home_controller.dart';
import '../../../../core/constants/app_color.dart';

import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';

/// Dialog widget for adding weekly usage data.
class UsageDialog extends StatelessWidget {
  /// The ID of the user.
  final int userId;

  /// The week number for the usage record.
  final int week;

  const UsageDialog({super.key, required this.userId, required this.week});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final TextEditingController usageController = TextEditingController();
    const primaryColor = AppColors.primaryColor;

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
                    child: const Icon(
                      Icons.data_usage_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomText(
                    text: 'إدخال استخدام الأسبوع $week',
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
                    hintText: 'الاستخدام بالجيجا بايت',
                    controllerText: usageController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: const Icon(
                      Icons.network_check_rounded,
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
                            final double usage =
                                double.tryParse(usageController.text) ?? 0.0;
                            if (usage > 0) {
                              controller.addWeeklyUsage(
                                userId: userId,
                                weeklyUsage: usage,
                                recordDate: 'الأسبوع $week',
                              );
                              Get.back();
                            } else {
                              Get.snackbar(
                                'خطأ',
                                'الرجاء إدخال قيمة صحيحة.',
                                backgroundColor: Colors.red.withValues(
                                  alpha: 0.1,
                                ),
                                colorText: Colors.red,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                          ),
                          label: const CustomText(
                            text: 'إضافة',
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
