import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../base_controllers/app_controller.dart';
import '../utils/themes.dart';
import 'custom_text.dart';

/// A customizable button widget.
class CustomButton extends StatelessWidget {
  /// The text to display on the button.
  final String? buttonText;

  /// The callback function to execute when the button is pressed.
  final VoidCallback onPressed;

  /// The background color of the button.
  final Color? buttonColor;

  /// The color of the text or icon.
  final Color? textColor;

  /// The font size of the text.
  final double? textFontSize;

  /// The font weight of the text.
  final FontWeight? textFontWeight;

  /// The font style of the text.
  final FontStyle? textFontStyle;

  /// The width of the button.
  final double? buttonWidth;

  /// The height of the button.
  final double? buttonHeight;

  /// An optional icon to display on the button.
  final IconData? buttonIcon;

  /// The border radius of the button.
  final double? buttonRadius;

  const CustomButton({
    super.key,
    this.buttonText,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonIcon,
    this.buttonRadius,
    this.textFontSize,
    this.textFontWeight,
    this.textFontStyle,
  });

  @override
  Widget build(BuildContext context) {
    //The widget that we will return
    return Obx(() {
      final AppController appController = Get.find();
      final bool isDarkMode = appController.isDarkMode.value;
      final Color defaultButtonColor = isDarkMode
          ? AppThemes.dark.colorScheme.primary
          : AppThemes.light.colorScheme.primary;
      final Color defaultTextColor = isDarkMode
          ? AppThemes.dark.colorScheme.onPrimary
          : AppThemes.light.colorScheme.onPrimary;

      return SizedBox(
        width: buttonWidth ?? double.infinity,
        height: buttonHeight ?? 50.0,
        //The button
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor ?? defaultButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius ?? 10.0),
            ),
            elevation: 0,
          ),
          child: _buildButtonChild(defaultTextColor),
        ),
      );
    });
  }

  Widget _buildButtonChild(Color defaultTextColor) {
    //there is an icon and text ,so we display both
    if (buttonText != null && buttonIcon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(buttonIcon, color: textColor ?? defaultTextColor),
          const SizedBox(width: 8),
          CustomText(
            text: buttonText!,
            textFontSize: textFontSize,
            textFontWeight: textFontWeight,
            textFontStyle: textFontStyle,
            textColor: textColor ?? defaultTextColor,
          ),
        ],
      );
    }
    // if there is an icon just we display it
    else if (buttonIcon != null) {
      return Icon(buttonIcon, color: textColor ?? defaultTextColor);
    }
    // if there is an text just we display it
    else {
      return CustomText(
        text: buttonText!,
        textFontSize: textFontSize,
        textFontWeight: textFontWeight,
        textFontStyle: textFontStyle,
        textColor: textColor ?? defaultTextColor,
      );
    }
  }
}
