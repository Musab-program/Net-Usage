import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../base_controllers/app_controller.dart';
import '../utils/themes.dart';

/// A customizable text widget.
class CustomText extends StatelessWidget {
  /// The text content to display.
  final String text;

  /// The color of the text.
  final Color? textColor;

  /// The font size of the text.
  final double? textFontSize;

  /// The alignment of the text.
  final TextAlign? textAlignment;

  /// The font weight of the text.
  final FontWeight? textFontWeight;

  /// The font style of the text.
  final FontStyle? textFontStyle;

  /// The maximum number of lines to display.
  final int? maxLines;

  /// How visual overflow should be handled.
  final TextOverflow? textOverflow;

  const CustomText({
    super.key,
    required this.text,
    this.textColor,
    this.textFontSize,
    this.textAlignment,
    this.textFontWeight,
    this.textFontStyle,
    this.maxLines,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();

    return Obx(() {
      final bool isDarkMode = appController.isDarkMode.value;
      final Color defaultTextColor = isDarkMode
          ? AppThemes.dark.colorScheme.onSurface
          : AppThemes.light.colorScheme.onSurface;

      return Text(
        text,
        textAlign: textAlignment,
        maxLines: maxLines,
        overflow: textOverflow,
        style: TextStyle(
          fontStyle: textFontStyle ?? FontStyle.normal,
          fontWeight: textFontWeight ?? FontWeight.normal,
          fontSize: textFontSize ?? 16,
          color: textColor ?? defaultTextColor,
        ),
      );
    });
  }
}
