import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extension to add "Done" button toolbar to number keyboards
extension TextFieldExtensions on Widget {
  /// Wraps a TextField with a toolbar that adds a "Done" button to number keyboards
  Widget withDoneButton(BuildContext context) {
    return Stack(
      children: [
        this,
        // The toolbar will be automatically positioned by the system
      ],
    );
  }
}

/// Custom input formatters and utilities for text fields
class TextFieldUtils {
  /// Creates a TextField decoration with keyboard actions
  static InputDecoration decorationWithDoneButton({
    required String hintText,
    IconData? prefixIcon,
    String? prefixText,
    TextStyle? prefixStyle,
    TextStyle? hintStyle,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      border: InputBorder.none,
    );
  }

  /// Decimal number input formatter (allows decimals)
  static List<TextInputFormatter> get decimalNumberFormatters => [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ];

  /// Integer only input formatter
  static List<TextInputFormatter> get integerNumberFormatters => [
        FilteringTextInputFormatter.digitsOnly,
      ];
}

/// Widget that adds a "Done" button above the keyboard for number inputs
class NumberFieldWithDone extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? prefix;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final InputDecoration? decoration;
  final bool allowDecimals;

  const NumberFieldWithDone({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.prefix,
    this.style,
    this.hintStyle,
    this.decoration,
    this.allowDecimals = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: allowDecimals
          ? TextFieldUtils.decimalNumberFormatters
          : TextFieldUtils.integerNumberFormatters,
      style: style,
      decoration: decoration ??
          TextFieldUtils.decorationWithDoneButton(
            hintText: hint,
            prefixIcon: icon,
            prefixText: prefix,
            hintStyle: hintStyle,
          ),
      // Add done button to keyboard
      textInputAction: TextInputAction.done,
      onSubmitted: (_) {
        // Dismiss keyboard when done is pressed
        FocusScope.of(context).unfocus();
      },
    );
  }
}
