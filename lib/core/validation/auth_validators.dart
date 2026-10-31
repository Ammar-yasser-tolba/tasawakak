abstract final class AuthValidators {
  static const String nameMessage = 'Please enter your full name.';
  static const String emailMessage = 'Email must contain @gmail.com';
  static const String phoneMessage =
      'Invalid phone number, must be exactly 11 digits.';
  static const String passwordMessage =
      'Password must be at least 7 characters, include at least one uppercase letter, and at least one number.';
  static const String confirmPasswordRequiredMessage =
      'Please confirm your password.';
  static const String confirmPasswordMessage = 'Passwords do not match.';

  static final RegExp _phonePattern = RegExp(r'^\d{11}$');
  static final RegExp _uppercasePattern = RegExp(r'[A-Z]');
  static final RegExp _digitPattern = RegExp(r'[0-9]');

  static String? fullName(String? value) {
    final text = (value ?? '').trim();
    return text.isEmpty ? nameMessage : null;
  }

  static String? email(String? value) {
    final text = (value ?? '').trim().toLowerCase();
    const suffix = '@gmail.com';
    if (!text.endsWith(suffix) || text.length <= suffix.length) {
      return emailMessage;
    }
    final localPart = text.substring(0, text.length - suffix.length);
    if (localPart.contains('@') || localPart.contains(RegExp(r'\s'))) {
      return emailMessage;
    }
    return null;
  }

  static String? phone(String? value) {
    final text = (value ?? '').trim();
    return _phonePattern.hasMatch(text) ? null : phoneMessage;
  }

  static String? password(String? value) {
    final text = value ?? '';
    final isValid = text.length > 6 &&
        _uppercasePattern.hasMatch(text) &&
        _digitPattern.hasMatch(text);
    return isValid ? null : passwordMessage;
  }

  static String? confirmPassword(String? value, String password) {
    final text = value ?? '';
    if (text.isEmpty) return confirmPasswordRequiredMessage;
    return text == password ? null : confirmPasswordMessage;
  }

  /// Accepts a Gmail address or an 11 digit phone number.
  static String? emailOrPhone(String? value) {
    final text = (value ?? '').trim();
    return text.contains('@') ? email(text) : phone(text);
  }

  static const String signInEmailMessage = 'Email must include @gmail.com';
  static const String signInPhoneMessage = 'Phone number must be 11 digits';

  /// Sign In "Email or Phone Number" field: the format is decided by the
  /// first character typed (letter = email, digit = phone).
  static String? signInContact(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return phoneMessage;
    if (RegExp(r'[A-Za-z]').hasMatch(text[0])) {
      return email(text) == null ? null : signInEmailMessage;
    }
    return _phonePattern.hasMatch(text) ? null : signInPhoneMessage;
  }
}
