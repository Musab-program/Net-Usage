import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/home/controllers/home_controller.dart';

import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/custom_text_field.dart';

class PaymentDialog extends StatelessWidget {
  final int userId;

  const PaymentDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final TextEditingController amountController = TextEditingController();

    return AlertDialog(
      title: const CustomText(text: 'إضافة مبلغ مدفوع'),
      content: CustomTextField(
        hintText: 'المبلغ المدفوع',
        controllerText: amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const CustomText(text: 'إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final double amount = double.tryParse(amountController.text) ?? 0.0;
            if (amount > 0) {
              controller.addPayment(
                userId: userId,
                amountPaid: amount,
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