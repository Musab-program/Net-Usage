import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/modules/calculator/controllers/calculator_controller.dart';
import 'package:net_uasge/core/constants/app_color.dart';
import 'package:net_uasge/core/base_controllers/app_controller.dart';

/// View widget for the calculator screen.
class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.find<CalculatorController>();
    final AppController appController = Get.find<AppController>();

    return Obx(() {
      final bool isDark = appController.isDarkMode.value;

      // Define Colors based on Theme
      final Color displayColor = isDark
          ? Colors.black
          : const Color(0xFFF2F2F2);
      final Color btnColorNumber = isDark
          ? const Color(0xFF333333)
          : Colors.white;
      final Color btnColorOperator =
          AppColors.primaryColor; // Using App Primary Color
      final Color btnColorFunction = isDark
          ? const Color(0xFFA5A5A5)
          : const Color(0xFFD4D4D2);

      final Color txtColorNum = isDark ? Colors.white : Colors.black;
      final Color txtColorFunc = Colors.black;
      final Color txtColorOp = Colors.white;

      return Scaffold(
        backgroundColor: displayColor,
        body: SafeArea(
          child: Column(
            children: [
              // Display Area
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Input Equation
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            controller.input.isEmpty ? ' ' : controller.input,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey
                                  : Colors.grey.shade700,
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Output Result
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            controller.output,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Keypad Area
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRow(
                        ['⌫', 'C', '%', '/'],
                        controller,
                        btnColorFunction,
                        btnColorOperator,
                        txtColorFunc,
                        txtColorOp,
                        txtColorNum,
                      ),
                      _buildRow(
                        ['7', '8', '9', 'x'],
                        controller,
                        btnColorNumber,
                        btnColorOperator,
                        txtColorFunc,
                        txtColorOp,
                        txtColorNum,
                      ),
                      _buildRow(
                        ['4', '5', '6', '-'],
                        controller,
                        btnColorNumber,
                        btnColorOperator,
                        txtColorFunc,
                        txtColorOp,
                        txtColorNum,
                      ),
                      _buildRow(
                        ['1', '2', '3', '+'],
                        controller,
                        btnColorNumber,
                        btnColorOperator,
                        txtColorFunc,
                        txtColorOp,
                        txtColorNum,
                      ),
                      _buildRow(
                        ['+/-', '0', '.', '='],
                        controller,
                        btnColorNumber,
                        btnColorOperator,
                        txtColorFunc,
                        txtColorOp,
                        txtColorNum,
                        isLastRow: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRow(
    List<String> buttons,
    CalculatorController controller,
    Color funcColor,
    Color opColor,
    Color funcTextColor,
    Color opTextColor,
    Color numTextColor, {
    bool isLastRow = false,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((text) {
          Color bgColor;
          Color txtColor;

          if (['C', '()', '%', '⌫'].contains(text)) {
            bgColor = funcColor;
            txtColor = funcTextColor;
          } else if (['/', 'x', '-', '+', '='].contains(text)) {
            bgColor = opColor;
            txtColor = opTextColor;
          } else {
            // Numbers
            if (numTextColor == Colors.white) {
              // Dark Mode logic passed
              bgColor = const Color(0xFF333333);
              txtColor = Colors.white;
            } else {
              // Light Mode logic passed
              bgColor = Colors.white;
              txtColor = Colors.black;
            }
          }

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ElevatedButton(
                    onPressed: () => _handlePress(text, controller),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: bgColor,
                      padding: const EdgeInsets.all(16),
                      elevation: 0,
                    ),
                    child: FittedBox(
                      child: text == '⌫'
                          ? Icon(
                              Icons.backspace_outlined,
                              color: txtColor,
                              size: 28,
                            )
                          : Text(
                              text,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                                color: txtColor,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handlePress(String text, CalculatorController controller) {
    if (text == 'C') {
      controller.clear();
    } else if (text == '⌫' || text == '<') {
      controller.deleteLast();
    } else if (text == '=') {
      controller.calculate();
    } else if (text == '+/-') {
      controller.toggleSign();
    } else if (['/', 'x', '-', '+', '%'].contains(text)) {
      controller.addOperator(text);
    } else {
      controller.addInput(text);
    }
  }
}
