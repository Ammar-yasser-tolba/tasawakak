import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/brand/brand_palette.dart';
import '../../core/routes/route_names.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_scaffold.dart';
import '../../core/widgets/brand_logo.dart';
import '../../core/widgets/primary_button.dart';
import 'state/auth_form_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthFormController(mode: AuthFormMode.signup),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _submit() {
    final form = context.read<AuthFormController>();
    FocusScope.of(context).unfocus();
    if (!form.validateAll()) return;
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.success,
      arguments: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AuthFormController>();

    return AuthScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthTopBar(pillLabel: 'حساب جديد'),
          const SizedBox(height: 22),
          const Center(child: BrandLogo(size: 76)),
          const SizedBox(height: 18),
          const Text(
            'انضم إلى عالم تسوقك',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: BrandPalette.navy,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'أنشئ حسابك لاستكشاف الموضة والساعات الفاخرة.',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: BrandPalette.inkMuted,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 22),
          AppTextField(
            label: 'الاسم الكامل',
            hint: 'مثال: أحمد محمود',
            icon: Icons.person_outline_rounded,
            controller: form.fullNameController,
            errorText: form.fullNameError,
            keyboardType: TextInputType.name,
            autofillHints: const [AutofillHints.name],
            onChanged: form.onFullNameChanged,
            onFocusLost: form.onFullNameFocusLost,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'البريد الإلكتروني',
            hint: 'you@gmail.com',
            icon: Icons.alternate_email_rounded,
            controller: form.emailController,
            errorText: form.emailError,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            onChanged: form.onEmailChanged,
            onFocusLost: form.onEmailFocusLost,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'رقم الهاتف',
            hint: '01012345678',
            icon: Icons.smartphone_rounded,
            controller: form.phoneController,
            errorText: form.phoneError,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            letterSpacing: 0.4,
            autofillHints: const [AutofillHints.telephoneNumber],
            onChanged: form.onPhoneChanged,
            onFocusLost: form.onPhoneFocusLost,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'كلمة السر',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            controller: form.passwordController,
            errorText: form.passwordError,
            obscureText: _obscurePassword,
            onToggleObscure: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            autofillHints: const [AutofillHints.newPassword],
            onChanged: form.onPasswordChanged,
            onFocusLost: form.onPasswordFocusLost,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'تأكيد كلمة السر',
            hint: '••••••••',
            icon: Icons.lock_reset_rounded,
            controller: form.confirmPasswordController,
            errorText: form.confirmPasswordError,
            obscureText: _obscureConfirmPassword,
            onToggleObscure: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
            autofillHints: const [AutofillHints.newPassword],
            onChanged: form.onConfirmPasswordChanged,
            onFocusLost: form.onConfirmPasswordFocusLost,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            key: const Key('signup-submit'),
            label: 'إنشاء حساب',
            onPressed: _submit,
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 12),
          AuthFooterPrompt(
            question: 'لديك حساب بالفعل؟',
            action: 'تسجيل الدخول',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}
