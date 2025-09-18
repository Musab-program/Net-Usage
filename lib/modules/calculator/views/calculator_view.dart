import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../core/widgets/custom_text.dart';
import '../controllers/calculator_controller.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();
    final isDarkMode = Get.isDarkMode;

    return Scaffold(
      appBar: const CustomAppbar(pageName: 'الحاسبة',),
      body: Column(
        children: [
          // شاشة عرض الإدخال
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Obx(
                  () => CustomText(
                text: controller.input,
                textFontSize: 28,
                textColor: isDarkMode ? AppColors.textIcons : AppColors.primaryText,
              ),
            ),
          ),

          // شاشة عرض الناتج
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Obx(
                    () => CustomText(
                  text: controller.output,
                  textFontSize: 48,
                  textColor: isDarkMode ? AppColors.textIcons : AppColors.primaryText,
                ),
              ),
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // صفوف الأزرار
          _buildButtonRow(['C', '()', '⌫', '/'], controller, isDarkMode),
          _buildButtonRow(['7', '8', '9', 'x'], controller, isDarkMode),
          _buildButtonRow(['4', '5', '6', '-'], controller, isDarkMode),
          _buildButtonRow(['1', '2', '3', '+'], controller, isDarkMode),
          _buildButtonRow(['+/-', '0', '.', '='], controller, isDarkMode),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildButtonRow(List<String> buttons, CalculatorController controller, bool isDarkMode) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) {
          final isOperator = ['/', 'x', '-', '+', '⌫', '+/-'].contains(text);
          final isClear = text == 'C';
          final isEquals = text == '=';
          final buttonColor = isEquals
              ? AppColors.accentColor
              : isOperator || isClear
              ? AppColors.darkPrimaryColor
              : AppColors.primaryColor;

          final textColor = isEquals ? AppColors.primaryText : (isDarkMode ? AppColors.textIcons : AppColors.primaryText);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  if (text == 'C') {
                    controller.clear();
                  } else if (text == '⌫') {
                    controller.deleteLast();
                  } else if (text == '=') {
                    controller.calculate();
                  } else if (text == '+/-') {
                    controller.toggleSign();
                  } else if (isOperator) {
                    controller.addOperator(text);
                  } else {
                    controller.addInput(text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: textColor,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                child: CustomText(
                  text: text,
                  textColor: textColor,
                  textFontSize: 24,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}