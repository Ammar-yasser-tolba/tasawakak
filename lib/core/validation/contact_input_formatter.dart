import 'package:flutter/services.dart';

/// Keeps phone-number input limited to 11 digits while leaving email input
/// free-form, so a single field can accept either format.
class EmailOrPhoneInputFormatter extends TextInputFormatter {
  static final RegExp _digitsOnly = RegExp(r'^\d+$');

  static const int phoneLength = 11;
  static const int emailMaxLength = 64;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    if (text.contains('@')) {
      return text.length <= emailMaxLength
          ? newValue
          : _truncate(newValue, emailMaxLength);
    }

    if (_digitsOnly.hasMatch(text) && text.length > phoneLength) {
      return _truncate(newValue, phoneLength);
    }

    return newValue;
  }

  TextEditingValue _truncate(TextEditingValue value, int length) {
    return TextEditingValue(
      text: value.text.substring(0, length),
      selection: TextSelection.collapsed(offset: length),
      composing: TextRange.empty,
    );
  }
}
