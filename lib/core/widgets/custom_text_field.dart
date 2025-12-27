import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../base_controllers/app_controller.dart';
import '../utils/themes.dart';

/// A customizable text field widget.
class CustomTextField extends StatelessWidget {
  /// The controller for the text field.
  final TextEditingController? controllerText;

  /// The hint text to display.
  final String? hintText;

  /// The label text to display.
  final String? labelText;

  /// Whether the text should be obscured (for passwords).
  final bool encryptionText;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  /// An icon to display before the input.
  final Widget? prefixIcon;

  /// An icon to display after the input.
  final Widget? suffixIcon;

  /// Validator function for form validation.
  final String? Function(String?)? validatorInput;

  /// The color of the text.
  final Color? textColor;

  /// The color of the hint text.
  final Color? hintColor;

  /// The color of the label text.
  final Color? labelColor;

  /// The color of the border.
  final Color? borderColor;

  /// Whether the text field should be filled.
  final bool? isFill;

  /// The background fill color.
  final Color? fillColor;

  const CustomTextField({
    super.key,
    this.controllerText,
    this.hintText,
    this.labelText,
    this.encryptionText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validatorInput,
    this.textColor,
    this.hintColor,
    this.labelColor,
    this.borderColor,
    this.isFill,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final AppController appController = Get.find();
      final bool isDarkMode = appController.isDarkMode.value;

      final Color defaultBorderColor = isDarkMode
          ? AppThemes
                    .dark
                    .inputDecorationTheme
                    .enabledBorder
                    ?.borderSide
                    .color ??
                Colors.grey
          : AppThemes
                    .light
                    .inputDecorationTheme
                    .enabledBorder
                    ?.borderSide
                    .color ??
                Colors.grey;
      final Color defaultFillColor = isDarkMode
          ? AppThemes.dark.inputDecorationTheme.fillColor ?? Colors.black
          : AppThemes.light.inputDecorationTheme.fillColor ?? Colors.white;
      final Color defaultLabelColor = isDarkMode
          ? AppThemes.dark.inputDecorationTheme.hintStyle?.color ?? Colors.grey
          : AppThemes.light.inputDecorationTheme.hintStyle?.color ??
                Colors.grey;

      return TextFormField(
        controller: controllerText,
        obscureText: encryptionText,
        keyboardType: keyboardType,
        validator: validatorInput,
        style: TextStyle(
          color:
              textColor ??
              (isDarkMode
                  ? AppThemes.dark.textTheme.bodyMedium?.color
                  : AppThemes.light.textTheme.bodyMedium?.color),
        ),

        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(color: hintColor ?? defaultLabelColor),
          labelStyle: TextStyle(color: labelColor ?? defaultLabelColor),

          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor ?? defaultBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor ?? defaultBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDarkMode
                  ? AppThemes
                            .dark
                            .inputDecorationTheme
                            .focusedBorder
                            ?.borderSide
                            .color ??
                        Colors.blue
                  : AppThemes
                            .light
                            .inputDecorationTheme
                            .focusedBorder
                            ?.borderSide
                            .color ??
                        Colors.blue,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          filled: isFill ?? true,
          fillColor: fillColor ?? defaultFillColor,
        ),
      );
    });
  }
}
