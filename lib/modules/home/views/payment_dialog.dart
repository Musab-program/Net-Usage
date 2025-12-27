import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/home/controllers/home_controller.dart';
import '../../../../core/constants/app_color.dart';

import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';

/// Dialog widget for adding a payment to a user.
class PaymentDialog extends StatelessWidget {
  /// The ID of the user receiving the payment.
  final int userId;

  const PaymentDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final TextEditingController amountController = TextEditingController();
    const primaryColor = AppColors.accentColor;

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
                      Icons.attach_money_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const CustomText(
                    text: 'إضافة دفعة جديدة',
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
                    hintText: 'المبلغ المدفوع (ريال)',
                    controllerText: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: const Icon(Icons.money, color: primaryColor),
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
                            final double amount =
                                double.tryParse(amountController.text) ?? 0.0;
                            if (amount > 0) {
                              controller.addPayment(
                                userId: userId,
                                amountPaid: amount,
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
                          icon: const Icon(Icons.add_card, color: Colors.white),
                          label: const CustomText(
                            text: 'إضافة المبلغ',
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
