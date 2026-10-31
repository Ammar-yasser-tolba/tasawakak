import 'package:flutter/widgets.dart';

import '../../../core/validation/auth_validators.dart';

enum AuthFormMode { login, signup, reset }

class AuthFormController extends ChangeNotifier {
  AuthFormController({required this.mode});

  final AuthFormMode mode;

  String? Function(String?) get _contactValidator =>
      mode == AuthFormMode.login
          ? AuthValidators.signInContact
          : AuthValidators.emailOrPhone;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController contactController = TextEditingController();

  String? fullNameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;
  String? contactError;

  bool _submitted = false;

  bool get hasErrors =>
      fullNameError != null ||
      emailError != null ||
      phoneError != null ||
      passwordError != null ||
      confirmPasswordError != null ||
      contactError != null;

  void onFullNameChanged(String value) {
    fullNameError = _live(value, AuthValidators.fullName);
    notifyListeners();
  }

  void onEmailChanged(String value) {
    emailError = _live(value, AuthValidators.email);
    notifyListeners();
  }

  void onPhoneChanged(String value) {
    phoneError = _live(value, AuthValidators.phone);
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    passwordError = _live(value, AuthValidators.password);
    if (confirmPasswordController.text.isNotEmpty || _submitted) {
      confirmPasswordError = AuthValidators.confirmPassword(
        confirmPasswordController.text,
        value,
      );
    }
    notifyListeners();
  }

  void onConfirmPasswordChanged(String value) {
    if (value.isEmpty && !_submitted) {
      confirmPasswordError = null;
    } else {
      confirmPasswordError = AuthValidators.confirmPassword(
        value,
        passwordController.text,
      );
    }
    notifyListeners();
  }

  void onContactChanged(String value) {
    contactError = _live(value, _contactValidator);
    notifyListeners();
  }

  void onFullNameFocusLost() => _validateOnBlur(
        fullNameController.text,
        AuthValidators.fullName,
        (error) => fullNameError = error,
      );

  void onEmailFocusLost() => _validateOnBlur(
        emailController.text,
        AuthValidators.email,
        (error) => emailError = error,
      );

  void onPhoneFocusLost() => _validateOnBlur(
        phoneController.text,
        AuthValidators.phone,
        (error) => phoneError = error,
      );

  void onPasswordFocusLost() {
    _validateOnBlur(
      passwordController.text,
      AuthValidators.password,
      (error) => passwordError = error,
    );
    if (confirmPasswordController.text.isNotEmpty) {
      confirmPasswordError = AuthValidators.confirmPassword(
        confirmPasswordController.text,
        passwordController.text,
      );
      notifyListeners();
    }
  }

  void onConfirmPasswordFocusLost() => _validateOnBlur(
        confirmPasswordController.text,
        (value) => AuthValidators.confirmPassword(
          value,
          passwordController.text,
        ),
        (error) => confirmPasswordError = error,
      );

  void onContactFocusLost() => _validateOnBlur(
        contactController.text,
        _contactValidator,
        (error) => contactError = error,
      );

  bool validateAll() {
    _submitted = true;
    switch (mode) {
      case AuthFormMode.login:
        contactError = AuthValidators.signInContact(contactController.text);
        passwordError = AuthValidators.password(passwordController.text);
        break;
      case AuthFormMode.signup:
        fullNameError = AuthValidators.fullName(fullNameController.text);
        emailError = AuthValidators.email(emailController.text);
        phoneError = AuthValidators.phone(phoneController.text);
        passwordError = AuthValidators.password(passwordController.text);
        confirmPasswordError = AuthValidators.confirmPassword(
          confirmPasswordController.text,
          passwordController.text,
        );
        break;
      case AuthFormMode.reset:
        contactError = AuthValidators.emailOrPhone(contactController.text);
        break;
    }
    notifyListeners();
    return !hasErrors;
  }

  String? _live(String value, String? Function(String?) validator) {
    if (value.trim().isEmpty && !_submitted) return null;
    return validator(value);
  }

  void _validateOnBlur(
    String value,
    String? Function(String?) validator,
    void Function(String?) apply,
  ) {
    if (value.trim().isEmpty && !_submitted) return;
    apply(validator(value));
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    contactController.dispose();
    super.dispose();
  }
}
